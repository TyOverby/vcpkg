include(vcpkg_common_functions)

set(VCPKG_POLICY_EMPTY_PACKAGE enabled)

if(NOT VCPKG_TARGET_ARCHITECTURE STREQUAL "x64" AND NOT VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
    return()
elseif(CMAKE_HOST_WIN32 AND VCPKG_CMAKE_SYSTEM_NAME AND NOT VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
    return()
endif()

set(BOOST_VERSION 1.72.0)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/build
    REF boost-${BOOST_VERSION}
    SHA512 744816ba805013a49029373a4d2aa5b5f543275a1cdef2812c2120c868c55bf36a0bb0fb891cd955ad7319e582fd5212bd52ff071703a8654b345c478e810a19
    HEAD_REF master
)

vcpkg_download_distfile(LICENSE
    URLS "https://raw.githubusercontent.com/boostorg/boost/boost-${BOOST_VERSION}/LICENSE_1_0.txt"
    FILENAME "boost_LICENSE_1_0.txt"
    SHA512 d6078467835dba8932314c1c1e945569a64b065474d7aced27c9a7acc391d52e9f234138ed9f1aa9cd576f25f12f557e0b733c14891d42c16ecdc4a7bd4d60b8
)

vcpkg_download_distfile(BOOSTCPP_ARCHIVE
    URLS "https://raw.githubusercontent.com/boostorg/boost/boost-${BOOST_VERSION}/boostcpp.jam"
    FILENAME "boost-${BOOST_VERSION}-boostcpp.jam"
    SHA512 7fac16c1f082821dd52cae39601f60bbdbd5ce043fbd19699da54c74fc5df1ed2ad6d3cefd3ae9a0a7697a2c34737f0c9e2b4bd3590c1f45364254875289cd17
)

file(INSTALL ${LICENSE} DESTINATION "${CURRENT_PACKAGES_DIR}/share/boost-build" RENAME copyright)
file(INSTALL ${BOOSTCPP_ARCHIVE} DESTINATION "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}" RENAME boostcpp.jam)
file(INSTALL ${BOOSTCPP_ARCHIVE} DESTINATION "${CURRENT_PACKAGES_DIR}/tools/${PORT}" RENAME boostcpp.jam)
# This fixes the lib path to use desktop libs instead of uwp -- TODO: improve this with better "host" compilation
string(REPLACE "\\store\\;" "\\;" LIB "$ENV{LIB}")
set(ENV{LIB} "${LIB}")

file(COPY
    ${SOURCE_PATH}/
    DESTINATION ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}
)

file(READ "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}/src/tools/msvc.jam" _contents)
string(REPLACE " /ZW /EHsc " "" _contents "${_contents}")
string(REPLACE "-nologo" "" _contents "${_contents}")
string(REPLACE "/nologo" "" _contents "${_contents}")
string(REPLACE "/Zm800" "" _contents "${_contents}")
string(REPLACE "<define>_WIN32_WINNT=0x0602" "" _contents "${_contents}")
file(WRITE "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}/src/tools/msvc.jam" "${_contents}")

message(STATUS "Bootstrapping...")
if(CMAKE_HOST_WIN32)
    vcpkg_execute_required_process(
        COMMAND "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}/bootstrap.bat" msvc
        WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}"
        LOGNAME bootstrap-${TARGET_TRIPLET}
    )
    if(NOT VCPKG_BOOST_TOOLSET)
        set(VCPKG_BOOST_TOOLSET msvc)
    endif()
else()
    vcpkg_execute_required_process(
        COMMAND "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}/bootstrap.sh"
        WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}"
        LOGNAME bootstrap-${TARGET_TRIPLET}
    )    
    if(NOT VCPKG_BOOST_TOOLSET)
        if(VCPKG_TARGET_IS_OSX)
            set(VCPKG_BOOST_TOOLSET darwin)
        else()
            set(VCPKG_BOOST_TOOLSET gcc)
        endif()
    endif()
endif()


file(TO_NATIVE_PATH "${CURRENT_PACKAGES_DIR}" INSTALL_PREFIX_PATH )
file(TO_NATIVE_PATH "${CURRENT_PACKAGES_DIR}/tools/${PORT}" INSTALL_TOOLS_PATH )
vcpkg_execute_required_process(
    COMMAND "./b2;install;--prefix=${INSTALL_PREFIX_PATH};--bindir=${INSTALL_TOOLS_PATH};toolset=${VCPKG_BOOST_TOOLSET}"
    WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}"
    LOGNAME install-${TARGET_TRIPLET}
)
file(READ "${CURRENT_PACKAGES_DIR}/share/boost-build/boost-build.jam" _contents)
string(REPLACE "boost-build src/kernel ;" "boost-build ../../share/boost-build/src/kernel ;" _contents1 "${_contents}")
string(REPLACE "boost-build src/kernel ;" "boost-build \"\@CURRENT_INSTALLED_DIR@/share/boost-build/src/kernel\" ;" _contents2 "${_contents}")
file(WRITE "${CURRENT_PACKAGES_DIR}/tools/${PORT}/boost-build.jam" "${_contents1}")
file(WRITE "${CURRENT_PACKAGES_DIR}/share/${PORT}/boost-build.jam.in" "${_contents2}")
#b2 correctly installed get boost-install scripts

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_BOOST_INSTALL
    REPO boostorg/boost_install
    REF boost-${BOOST_VERSION}
    SHA512 0c3b319d0828df2dfafd60c02c8d0b4a349c0843162f02735954a2e586e846ce76b1ccca0c7d05669486f0f37bd0740fee66c8f74461ef6ff397cb0832dff886
    HEAD_REF master
)
#set(CURRENT_INSTALLED_DIR_BACKUP "${CURRENT_INSTALLED_DIR}")
#set(CURRENT_INSTALLED_DIR "${CURRENT_PACKAGES_DIR}")
#configure_file("${CURRENT_PACKAGES_DIR}/tools/${PORT}/boost-build.jam.in" "${SOURCE_BOOST_INSTALL}/boost-build.jam")
#set(CURRENT_INSTALLED_DIR "${CURRENT_INSTALLED_DIR_BACKUP}")

file(COPY
    ${SOURCE_BOOST_INSTALL}/
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/boost_install/
)

file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/share/boost/")
#Install CMake files
file(RENAME "${CURRENT_PACKAGES_DIR}/share/boost_install/BoostConfig.cmake" "${CURRENT_PACKAGES_DIR}/share/boost/BoostConfig.cmake")
file(RENAME "${CURRENT_PACKAGES_DIR}/share/boost_install/BoostDetectToolset.cmake" "${CURRENT_PACKAGES_DIR}/share/boost/BoostDetectToolset.cmake")
file(RENAME "${CURRENT_PACKAGES_DIR}/share/boost_install/test/BoostVersion.cmake" "${CURRENT_PACKAGES_DIR}/share/boost/BoostVersion.cmake")

file(
    COPY
        "${CMAKE_CURRENT_LIST_DIR}/modular/boost-modular-build.cmake"
        "${CMAKE_CURRENT_LIST_DIR}/modular/Jamroot.jam.in"
        "${CMAKE_CURRENT_LIST_DIR}/modular/user-config.jam.in"
        "${CMAKE_CURRENT_LIST_DIR}/modular/nothing.bat"
        "${CMAKE_CURRENT_LIST_DIR}/modular/CMakeLists.txt"
    DESTINATION
        "${CURRENT_PACKAGES_DIR}/share/boost-build"
)

# vcpkg_execute_required_process(
    # COMMAND "${CURRENT_PACKAGES_DIR}/tools/${PORT}/b2;--prefix=${INSTALL_PREFIX_PATH};toolset=${VCPKG_BOOST_TOOLSET}"
    # WORKING_DIRECTORY "${SOURCE_BOOST_INSTALL}"
    # LOGNAME install-boost_install-${TARGET_TRIPLET}
# )

#--build-dir
#--exec-prefix