set(FONTCONFIG_VERSION 2.12.4)

vcpkg_from_gitlab(
    GITLAB_URL https://gitlab.freedesktop.org/
    OUT_SOURCE_PATH SOURCE_PATH
    REPO fontconfig/fontconfig
    REF  b1df1101a643ae16cdfa1d83b939de2497b1bf27
    SHA512 9165c758de40053d9ab9a1ae86f41e7076e730eaba6b4a0b2673b6535d2cb9708de4fcac2bb8883477e17b8e52d4396a3392cdbf3ca90109c8b3c1b749dd6d3c
    HEAD_REF master # branch name
    PATCHES fcobjtypehash.patch
            build.patch
) 

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

# vcpkg_configure_cmake(
    # SOURCE_PATH ${SOURCE_PATH}
    # PREFER_NINJA
    # OPTIONS
        # -DFC_INCLUDE_DIR=${CMAKE_CURRENT_LIST_DIR}/include
    # OPTIONS_DEBUG
        # -DFC_SKIP_TOOLS=ON
        # -DFC_SKIP_HEADERS=ON
# )
vcpkg_find_acquire_program(GPERF)
get_filename_component(GPERF_PATH ${GPERF} DIRECTORY)
vcpkg_add_to_path(${GPERF_PATH})

if(VCPKG_TARGET_IS_WINDOWS)
    list(APPEND OPTIONS os_win32=yes
                        ms_librarian=yes)
endif()

vcpkg_configure_make(
    AUTOCONFIG
    COPY_SOURCE
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        --disable-docs
        ${OPTIONS}
        ac_cv_type_pid_t=yes
        --enable-iconv
        #--enable-expat
        "--with-expat=${CURRENT_INSTALLED_DIR}"
        "--with-expat-includes=${CURRENT_INSTALLED_DIR}/include"
        "--with-libiconv=${CURRENT_INSTALLED_DIR}"
        "--with-libiconv-includes=${CURRENT_INSTALLED_DIR}/include"
    OPTIONS_DEBUG
        "--with-expat-lib=${CURRENT_INSTALLED_DIR}/debug/lib"
        "--with-libiconv-lib=${CURRENT_INSTALLED_DIR}/debug/lib"
    OPTIONS_RELEASE
        "--with-expat-lib=${CURRENT_INSTALLED_DIR}/lib"
        "--with-libiconv-lib=${CURRENT_INSTALLED_DIR}/lib"
)
	# [AC_HELP_STRING([--enable-libxml2],
			# [Use libxml2 instead of Expat])])

vcpkg_install_make()


#vcpkg_install_cmake()
#vcpkg_fixup_cmake_targets(CONFIG_PATH share/unofficial-fontconfig TARGET_PATH share/unofficial-fontconfig)
vcpkg_fixup_pkgconfig()
vcpkg_copy_pdbs()
vcpkg_copy_tool_dependencies("${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin")
if(VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    foreach(HEADER fcfreetype.h fontconfig.h)
        file(READ ${CURRENT_PACKAGES_DIR}/include/fontconfig/${HEADER} FC_HEADER)
        if(NOT VCPKG_CMAKE_SYSTEM_NAME OR VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
            string(REPLACE "#define FcPublic" "#define FcPublic __declspec(dllimport)" FC_HEADER "${FC_HEADER}")
        else()
            string(REPLACE "#define FcPublic" "#define FcPublic __attribute__((visibility(\"default\")))" FC_HEADER "${FC_HEADER}")
        endif()
        file(WRITE ${CURRENT_PACKAGES_DIR}/include/fontconfig/${HEADER} "${FC_HEADER}")
    endforeach()
endif()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/fontconfig/" RENAME copyright)

#vcpkg_test_cmake(PACKAGE_NAME unofficial-fontconfig)
