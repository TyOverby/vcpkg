if(NOT VCPKG_TARGET_IS_WINDOWS)
    # theoretically VCPKG needs a check here if or if not iconv is provided by the C library
    message(STATUS "On platforms which are not Windows VCPKG. Assumes iconv is provided by the C library or available from the system.")
    set(VCPKG_POLICY_EMPTY_PACKAGE enabled)
    return()
endif()

set(LIBICONV_VERSION 1.16)

vcpkg_download_distfile(ARCHIVE
    URLS "https://ftp.gnu.org/gnu/libiconv/libiconv-${LIBICONV_VERSION}.tar.gz" "https://www.mirrorservice.org/sites/ftp.gnu.org/gnu/libiconv/libiconv-${LIBICONV_VERSION}.tar.gz"
    FILENAME "libiconv-${LIBICONV_VERSION}.tar.gz"
    SHA512 365dac0b34b4255a0066e8033a8b3db4bdb94b9b57a9dca17ebf2d779139fe935caf51a465d17fd8ae229ec4b926f3f7025264f37243432075e5583925bb77b7
)
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${LIBICONV_VERSION}
    PATCHES
        0002-Config-for-MSVC.patch
        0003-Add-export.patch
        configure.ac.patch
        rc2.patch
)

#Since libiconv uses automake, make and configure, we use a custom CMake file
#file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

#vcpkg_configure_cmake(
#    SOURCE_PATH ${SOURCE_PATH}
#    PREFER_NINJA
#    OPTIONS -DINSTALLDIR=\"\" -DLIBDIR=\"\"
#    OPTIONS_DEBUG -DDISABLE_INSTALL_HEADERS=ON
#)

#vcpkg_install_cmake()

#vcpkg_fixup_cmake_targets(CONFIG_PATH share/unofficial-iconv TARGET_PATH share/unofficial-iconv)

# if(VCPKG_TARGET_IS_WINDOWS)
    # if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
        # list(APPEND ADDITIONAL_OPTIONS BUILD_TRIPLET --host=i686-w64-mingw32) # --host -> building for. --build -> building on. 
    # elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
        # list(APPEND ADDITIONAL_OPTIONS BUILD_TRIPLET --host=x86_64-w64-mingw32)
    # elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
        # list(APPEND ADDITIONAL_OPTIONS BUILD_TRIPLET --host=armv8-w64-mingw32)
    # elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm")
        # list(APPEND ADDITIONAL_OPTIONS BUILD_TRIPLET --host=armv7-w64-mingw32)
    # else()
        # message(STATUS "Unsupported architecture for windows targets!")
    # endif()
#endif()
if(CMAKE_HOST_WIN32)
    vcpkg_add_to_path(${CURRENT_PORT_DIR})
    set(WINDRES ":")
    set(RC ":")
    list(APPEND ADDITIONAL_OPTIONS CONFIGURE_ENVIRONMENT_VARIABLES WINDRES RC)
endif()
vcpkg_configure_make(
    AUTOCONFIG
    SOURCE_PATH ${SOURCE_PATH}
    ${ADDITIONAL_OPTIONS}
)

vcpkg_install_make()
vcpkg_fixup_pkgconfig()

vcpkg_copy_pdbs()
vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin )

file(COPY ${CMAKE_CURRENT_LIST_DIR}/vcpkg-cmake-wrapper.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/Iconv)

file(INSTALL ${SOURCE_PATH}/COPYING.LIB DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

set(VCPKG_POLICY_ALLOW_RESTRICTED_HEADERS enabled)
