# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/phoenix
    REF boost-1.71.0
    SHA512 c516f30628a4f087ab7165be4a75925f85431389c7af62a080bbb65ecc9522eee7dbbf89affddff75843fb79f46e192600450f19594323e886e7e0445c349e3b
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
