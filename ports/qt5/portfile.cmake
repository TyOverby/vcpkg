include(vcpkg_common_functions)

string(LENGTH "${CURRENT_BUILDTREES_DIR}" BUILDTREES_PATH_LENGTH)
if(BUILDTREES_PATH_LENGTH GREATER 27)
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

set(QT_MAJOR_VER "5")
set(QT_MINOR_VER "10")
set(QT_REV_VER "0")
set(QT_FULL_VER "${QT_MAJOR_VER}.${QT_MINOR_VER}.${QT_REV_VER}")
set(SOURCE_PATH "${CURRENT_BUILDTREES_DIR}/src/qt-${QT_FULL_VER}")



vcpkg_download_distfile(ARCHIVE_FILE
    URLS "http://download.qt.io/official_releases/qt/${QT_MAJOR_VER}.${QT_MINOR_VER}/${QT_FULL_VER}/single/qt-everywhere-src-${QT_FULL_VER}.tar.xz"
    FILENAME "qt-${QT_FULL_VER}.tar.xy"
    SHA512 22706bb5bfe943ee09f7750e473b2b46b879fd04220cb2325f4df8ffa0c128646e525bb1a90afe08d23ec9b949bfa87795cade4c8ae2ae63a5c6b33de94d95d5
)
vcpkg_extract_source_archive(${ARCHIVE_FILE})
if (EXISTS ${CURRENT_BUILDTREES_DIR}/src/qt-everywhere-src-${QT_FULL_VER})
    file(RENAME ${CURRENT_BUILDTREES_DIR}/src/qt-everywhere-src-${QT_FULL_VER} ${SOURCE_PATH})
endif()

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
	PATCHES "${CMAKE_CURRENT_LIST_DIR}/fix-system-pcre2.patch" "${CMAKE_CURRENT_LIST_DIR}/fix_flex_angle.patch" "${CMAKE_CURRENT_LIST_DIR}/fix_qtwebengine.patch"
    #PATCHES "${CMAKE_CURRENT_LIST_DIR}/fix-system-pcre2.patch" "${CMAKE_CURRENT_LIST_DIR}/fix_flex_angle.patch" "${CMAKE_CURRENT_LIST_DIR}/fix_qtwebengine_bootstrap.patch"
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
        #-system-sqlite
		-qt-sqlite
        -sql-sqlite
        -sql-psql
        -feature-freetype
        -nomake examples -nomake tests
        -opengl dynamic # other options are "-no-opengl" and "-opengl angle" "-opengl dynamic"
		-skip qtwebengine
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

vcpkg_apply_patches(
    SOURCE_PATH ${CURRENT_PACKAGES_DIR}/lib/cmake
    PATCHES "${CMAKE_CURRENT_LIST_DIR}/add-private-header-paths.patch"
)
file(RENAME ${CURRENT_PACKAGES_DIR}/lib/cmake ${CURRENT_PACKAGES_DIR}/share/cmake)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/cmake)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

file(GLOB BINARY_TOOLS "${CURRENT_PACKAGES_DIR}/bin/*.exe")
file(INSTALL ${BINARY_TOOLS} DESTINATION ${CURRENT_PACKAGES_DIR}/tools/qt5)
file(REMOVE ${BINARY_TOOLS})
file(GLOB BINARY_TOOLS "${CURRENT_PACKAGES_DIR}/debug/bin/*.exe")
file(REMOVE ${BINARY_TOOLS})
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

vcpkg_execute_required_process(
    COMMAND ${PYTHON2} ${CMAKE_CURRENT_LIST_DIR}/fixcmake.py
    WORKING_DIRECTORY ${CURRENT_PACKAGES_DIR}/share/cmake
    LOGNAME fix-cmake
)

vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/${PORT})
vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/qt5)

#---------------------------------------------------------------------------
# Qt5Bootstrap: a release-only dependency
#---------------------------------------------------------------------------
# Remove release-only Qt5Bootstrap.lib from debug folders:
#file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/lib/Qt5Bootstrap.lib)
#file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/lib/Qt5Bootstrap.prl)
# Above approach does not work: 
#   check_matching_debug_and_release_binaries(dbg_libs, rel_libs)
# requires the two sets to be of equal size!
# Alt. approach, create dummy folder instead:
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug/lib/dont-use)
file(COPY ${CURRENT_PACKAGES_DIR}/debug/lib/Qt5Bootstrap.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib/dont-use)
file(COPY ${CURRENT_PACKAGES_DIR}/debug/lib/Qt5Bootstrap.prl DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib/dont-use)
file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/lib/Qt5Bootstrap.lib)
file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/lib/Qt5Bootstrap.prl)
#---------------------------------------------------------------------------

#---------------------------------------------------------------------------
# qtmain(d) vs. Qt5AxServer(d)
#---------------------------------------------------------------------------
# Qt applications have to either link to qtmain(d) or to Qt5AxServer(d),
# never both. See http://doc.qt.io/qt-5/activeqt-server.html for more info.
#
# Create manual-link folders:
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/lib/manual-link)
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug/lib/manual-link)
#
# Either have users explicitly link against qtmain.lib, qtmaind.lib:
file(COPY ${CURRENT_PACKAGES_DIR}/lib/qtmain.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib/manual-link)
file(COPY ${CURRENT_PACKAGES_DIR}/lib/qtmain.prl DESTINATION ${CURRENT_PACKAGES_DIR}/lib/manual-link)
file(REMOVE ${CURRENT_PACKAGES_DIR}/lib/qtmain.lib)
file(REMOVE ${CURRENT_PACKAGES_DIR}/lib/qtmain.prl)
file(COPY ${CURRENT_PACKAGES_DIR}/debug/lib/qtmaind.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib/manual-link)
file(COPY ${CURRENT_PACKAGES_DIR}/debug/lib/qtmaind.prl DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib/manual-link)
file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/lib/qtmaind.lib)
file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/lib/qtmaind.prl)
#
# ... or have users explicitly link against Qt5AxServer.lib, Qt5AxServerd.lib:
file(COPY ${CURRENT_PACKAGES_DIR}/lib/Qt5AxServer.lib DESTINATION ${CURRENT_PACKAGES_DIR}/lib/manual-link)
file(COPY ${CURRENT_PACKAGES_DIR}/lib/Qt5AxServer.prl DESTINATION ${CURRENT_PACKAGES_DIR}/lib/manual-link)
file(REMOVE ${CURRENT_PACKAGES_DIR}/lib/Qt5AxServer.lib)
file(REMOVE ${CURRENT_PACKAGES_DIR}/lib/Qt5AxServer.prl)
file(COPY ${CURRENT_PACKAGES_DIR}/debug/lib/Qt5AxServerd.lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib/manual-link)
file(COPY ${CURRENT_PACKAGES_DIR}/debug/lib/Qt5AxServerd.prl DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib/manual-link)
file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/lib/Qt5AxServerd.lib)
file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/lib/Qt5AxServerd.prl)
#---------------------------------------------------------------------------

file(INSTALL ${SOURCE_PATH}/LICENSE.LGPLv3 DESTINATION  ${CURRENT_PACKAGES_DIR}/share/qt5 RENAME copyright)
if(EXISTS ${CURRENT_PACKAGES_DIR}/plugins)
    file(INSTALL ${CMAKE_CURRENT_LIST_DIR}/qtdeploy.ps1 DESTINATION ${CURRENT_PACKAGES_DIR}/plugins)
endif()
if(EXISTS ${CURRENT_PACKAGES_DIR}/debug/plugins)
    file(INSTALL ${CMAKE_CURRENT_LIST_DIR}/qtdeploy.ps1 DESTINATION ${CURRENT_PACKAGES_DIR}/debug/plugins)
endif()

