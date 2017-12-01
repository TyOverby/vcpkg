include(vcpkg_common_functions)

string(LENGTH "${CURRENT_BUILDTREES_DIR}" BUILDTREES_PATH_LENGTH)
if(BUILDTREES_PATH_LENGTH GREATER 37)
    message(WARNING "Qt5's buildsystem uses very long paths and may fail on your system.\n"
        "We recommend moving vcpkg to a short path such as 'C:\\src\\vcpkg' or using the subst command."
    )
endif()

if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    message(FATAL_ERROR "Qt5 doesn't currently support static builds. Please use a dynamic triplet instead.")
endif()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})
include(configure_qt)
include(install_qt)

set(SRCDIR_NAME "qtbase-5.9.3")
set(ARCHIVE_NAME "qtbase-opensource-src-5.9.3")
set(ARCHIVE_EXTENSION ".tar.xz")

set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/${SRCDIR_NAME})
vcpkg_download_distfile(ARCHIVE_FILE
    URLS "http://download.qt.io/official_releases/qt/5.9/5.9.3/submodules/${ARCHIVE_NAME}${ARCHIVE_EXTENSION}"
    FILENAME ${SRCDIR_NAME}${ARCHIVE_EXTENSION}
    SHA512 256ffb8760e94c0f87790ed35e210d0c9613e14314ff442dd763cc93fbd5caa6c11c95f5d44b12a7687fb93c9f857878132cf6d76e5933f647ca7beb54b18c7c
)
vcpkg_extract_source_archive(${ARCHIVE_FILE})
if (EXISTS ${CURRENT_BUILDTREES_DIR}/src/${ARCHIVE_NAME})
    file(RENAME ${CURRENT_BUILDTREES_DIR}/src/${ARCHIVE_NAME} ${CURRENT_BUILDTREES_DIR}/src/${SRCDIR_NAME})
endif()

vcpkg_apply_patches(
    SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/${SRCDIR_NAME}
    PATCHES "${CMAKE_CURRENT_LIST_DIR}/fix-system-pcre2.patch"
)

vcpkg_apply_patches(
    SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/${SRCDIR_NAME}
    PATCHES "${CMAKE_CURRENT_LIST_DIR}/fix_flex_angle.patch"
)


# This fixes issues on machines with default codepages that are not ASCII compatible, such as some CJK encodings
set(ENV{_CL_} "/utf-8")

configure_qt(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -confirm-license
        -opensource
        -system-zlib
        -system-libjpeg
        -system-libpng
        -system-freetype
        -system-pcre
        -system-harfbuzz
        -system-doubleconversion
        -system-sqlite
        -sql-sqlite
        -sql-psql
        -feature-freetype
        -nomake examples -nomake tests
        -opengl dynamic # other options are "-no-opengl" and "-opengl angle" "-opengl dynamic"
		#-no-angle
        -mp
        LIBJPEG_LIBS="-ljpeg"
    OPTIONS_RELEASE
        ZLIB_LIBS="-lzlib"
        LIBPNG_LIBS="-llibpng16"
    OPTIONS_DEBUG
        ZLIB_LIBS="-lzlibd"
        LIBPNG_LIBS="-llibpng16d"
        PSQL_LIBS="-llibpqd"
        FREETYPE_LIBS="-lfreetyped"
)

install_qt()

file(RENAME ${CURRENT_PACKAGES_DIR}/lib/cmake ${CURRENT_PACKAGES_DIR}/share/cmake)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/cmake)

file(GLOB BINARY_TOOLS "${CURRENT_PACKAGES_DIR}/bin/*.exe")
file(INSTALL ${BINARY_TOOLS} DESTINATION ${CURRENT_PACKAGES_DIR}/tools/qt5)
file(REMOVE ${BINARY_TOOLS})
file(GLOB BINARY_TOOLS "${CURRENT_PACKAGES_DIR}/debug/bin/*.exe")
file(INSTALL ${BINARY_TOOLS} DESTINATION ${CURRENT_PACKAGES_DIR}/debug/tools/qt5)
file(REMOVE ${BINARY_TOOLS})

file(COPY ${CMAKE_CURRENT_LIST_DIR}/qt_debug.conf ${CMAKE_CURRENT_LIST_DIR}/qt_release.conf DESTINATION ${CURRENT_PACKAGES_DIR}/tools/qt5)

vcpkg_execute_required_process(
    COMMAND ${PYTHON3} ${CMAKE_CURRENT_LIST_DIR}/fixcmake.py
    WORKING_DIRECTORY ${CURRENT_PACKAGES_DIR}/share/cmake
    LOGNAME fix-cmake
)

vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/${PORT})
vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/qt5)

file(INSTALL ${SOURCE_PATH}/LICENSE.LGPLv3 DESTINATION  ${CURRENT_PACKAGES_DIR}/share/qt5base RENAME copyright)
