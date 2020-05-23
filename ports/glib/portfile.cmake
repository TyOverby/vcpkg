# Glib uses winapi functions not available in WindowsStore
vcpkg_fail_port_install(ON_TARGET "UWP")

# Glib relies on DllMain on Windows
if (VCPKG_TARGET_IS_WINDOWS)
    vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)
endif()

set(GLIB_VERSION 2.64.3)
vcpkg_download_distfile(ARCHIVE
    URLS "https://ftp.gnome.org/pub/gnome/sources/glib/2.64/glib-${GLIB_VERSION}.tar.xz"
    FILENAME "glib-${GLIB_VERSION}.tar.xz"
    SHA512 a3828c37a50e86eb8791be53bd8af848d144e4580841ffab28f3b6eae5144f5cdf4a5d4b43130615b97488e700b274c2468fc7d561b3701a1fc686349501a1db)


vcpkg_find_acquire_program(PYTHON3)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${GLIB_VERSION}
    PATCHES
        fix-meson.patch
        use-libiconv-on-windows.patch
        fix-arm-builds.patch
        build.patch
)

file(REMOVE ${SOURCE_PATH}/glib/win_iconv.c)

if (selinux IN_LIST FEATURES AND NOT VCPKG_TARGET_IS_WINDOWS AND NOT EXISTS "/usr/include/selinux")
    message("Selinux was not found in its typical system location. Your build may fail. You can install Selinux with \"apt-get install selinux\".")
endif()

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    selinux HAVE_SELINUX
)

vcpkg_configure_meson(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        --backend=ninja
        -Dbuild_tests=false
        -Dlibintlinc=${CURRENT_INSTALLED_DIR}/include
        -Dpythonexe=${PYTHON3}
    OPTIONS_DEBUG
        -Dlibintldir=${CURRENT_INSTALLED_DIR}/debug/lib
    OPTIONS_RELEASE
        -Dlibintldir=${CURRENT_INSTALLED_DIR}/lib
)

vcpkg_install_meson()

vcpkg_copy_pdbs()
vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/${PORT})

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
if(VCPKG_TARGET_IS_WINDOWS)
    list(APPEND ADDITIONAL_TOOLS gspawn-win64-helper-console gspawn-win64-helper)
endif()
vcpkg_copy_tools(TOOL_NAMES gdbus gio-querymodules gio glib-compile-resources glib-compile-schemas gobject-query gresource gsettings ${ADDITIONAL_TOOLS} AUTO_CLEAN)
vcpkg_fixup_pkgconfig(SKIP_CHECK) # Probably need to fix executable paths

file(INSTALL ${CURRENT_PACKAGES_DIR}/lib/glib-2.0/include/glibconfig.h DESTINATION ${CURRENT_PACKAGES_DIR}/include/glib-2.0)

file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
# for backward compatibility with existing ports
file(INSTALL ${CMAKE_CURRENT_LIST_DIR}/cmake/unofficial-glib-config.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/unofficial-glib/)
file(INSTALL ${CMAKE_CURRENT_LIST_DIR}/cmake/unofficial-glib-targets-debug.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/unofficial-glib/)
file(INSTALL ${CMAKE_CURRENT_LIST_DIR}/cmake/unofficial-glib-targets-release.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/unofficial-glib/)
file(INSTALL ${CMAKE_CURRENT_LIST_DIR}/cmake/unofficial-glib-targets.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/unofficial-glib/)
