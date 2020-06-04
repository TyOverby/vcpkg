set(VCPKG_POLICY_EMPTY_PACKAGE enabled)

set(BOOST_VERSION 1.72.0)

include("${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake")

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/headers
    REF boost-${BOOST_VERSION}
    SHA512  2956da3f88a545ac822f223e6280626514a67d97d692d0c1760064cc1a42041638dd38f5e8d5c9de3b7bf01d9260b5f57961def4816bccc29b24b40a92be2a07
    HEAD_REF master
)

configure_file("${CURRENT_INSTALLED_DIR}/share/boost-build/boost-build.jam.in" DESTINATION "${SOURCE_PATH}/build/boost-build.jam")

set(jamfile "${SOURCE_PATH}/build/Jamfile")
file(READ "${jamfile}" _contents)
string(REGEX REPLACE "../../../tools/boost_install/([^ ]+)" "\"${CURRENT_INSTALLED_DIR}/share/boost_install/\\1\"" _contents "${_contents}")
file(WRITE "${jamfile}" "${_contents}")

boost_modular_build(SOURCE_PATH ${SOURCE_PATH} OPTIONS "--layout=tagged")
# file
# vcpkg_execute_required_process(
    # COMMAND "./b2"
            # install
            # --prefix=${CURRENT_PACKAGES_DIR}
            # --build-dir="${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}"
    # WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}"
    # LOGNAME install-${TARGET_TRIPLET}
# )

file(TOUCH "${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright")

