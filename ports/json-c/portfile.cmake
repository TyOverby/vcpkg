vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO json-c/json-c
    REF bae2f10c436eaf0d95746cbc5f1c1f0ecb866a8e
    SHA512 d172a295cd7407c43aba828711d4f25ad2da8f0289726141d9af087c6ea6c5807a49fdb243d498bf322cec685fd3168ca8306512c6493b458d6e64bb080c3b1a
    HEAD_REF master
    PATCHES pkgconfig.patch
)


vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/${PORT})
vcpkg_fixup_pkgconfig()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
configure_file(${SOURCE_PATH}/COPYING ${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright COPYONLY)

# CMake integration test
vcpkg_test_cmake(PACKAGE_NAME ${PORT})
