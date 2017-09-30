#header-only library
include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Neumann-A/pcg-cpp
    REF 93b77ae39315699bf532a949142bac3be01e2dc9
    SHA512 1700ef6a4498bf526e06647872cab8de60179e3fed398d22551ff197fa66a076208a4aa84bf777877fd4689fa38b9f42a03f40f14535cbfc12d7f6c99c5e09fe
    HEAD_REF vs_2017fix_and_cmake
)

VCPKG_CONFIGURE_CMAKE(
    SOURCE_PATH ${SOURCE_PATH}
	PREFER_NINJA
    OPTIONS
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH "cmake")

# Put the licence file where vcpkg expects it
file(COPY ${SOURCE_PATH}/license-mit.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/pcg-cpp)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/pcg-cpp/license-mit.txt ${CURRENT_PACKAGES_DIR}/share/pcg-cpp/copyright)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug)

# Copy the pcg-cpp header files
file(INSTALL ${SOURCE_PATH}/include DESTINATION ${CURRENT_PACKAGES_DIR} FILES_MATCHING PATTERN "*.hpp")
vcpkg_copy_pdbs()

#file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug)

#file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
