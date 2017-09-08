#header-only library
include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO imneme/pcg-cpp
    REF 0ca2e8ea6ba212bdfbc6219c2313c45917e34b8d
    SHA512 0d15d1336950b19e796fa3cbcd69396a487ff20efef5b2d409001a067e5328031c0555bc85289977dd4ab84de7c5fc5ec436954f5d23e03733893f9a37f6ba2e
    HEAD_REF master
)
#vcpkg_extract_source_archive(${ARCHIVE})

# Put the licence file where vcpkg expects it
file(COPY ${SOURCE_PATH}/license-mit.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/pcg-cpp)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/pcg-cpp/license-mit.txt ${CURRENT_PACKAGES_DIR}/share/pcg-cpp/copyright)


# Copy the rapidjson header files
file(INSTALL ${SOURCE_PATH}/include DESTINATION ${CURRENT_PACKAGES_DIR} FILES_MATCHING PATTERN "*.hpp")
vcpkg_copy_pdbs()

#file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug)

#file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
