vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO rougier/freetype-gl
    REF a91a3dda326ceaf66b7279bf64ba07014d3f81b8
    SHA512 8e04573dfb400e14e2c1d3a2cd851a66f8218ccfdaa4f701ed9369d7f040d7028582e72af9b236af42d9d3c6c128014670e8ae0261c6f4770affd1aea1454b1e
    HEAD_REF master
    PATCHES GLEW_and_TARGET.patch
)

# make sure that no "internal" libraries are used by removing them
file(REMOVE_RECURSE ${SOURCE_PATH}/windows/freetype)
file(REMOVE_RECURSE ${SOURCE_PATH}/windows/AntTweakBar)
file(REMOVE_RECURSE ${SOURCE_PATH}/windows/glew)
file(REMOVE ${SOURCE_PATH}/cmake/Modules/FindGLEW.cmake)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -Dfreetype-gl_BUILD_APIDOC=OFF
        -Dfreetype-gl_BUILD_DEMOS=OFF
        -Dfreetype-gl_BUILD_TESTS=OFF
        -Dfreetype-gl_BUILD_MAKEFONT=OFF
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake)

vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
