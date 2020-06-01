if(NOT VCPKG_USE_EXTERNAL_Fortran AND CMAKE_HOST_WIN32)

    if(DEFINED ENV{PROCESSOR_ARCHITEW6432})
        set(HOST_ARCH $ENV{PROCESSOR_ARCHITEW6432})
    else()
        set(HOST_ARCH $ENV{PROCESSOR_ARCHITECTURE})
    endif()

    if(HOST_ARCH MATCHES "(amd|AMD)64")
        set(MINGW_W w64)
        set(MSYS_HOST x86_64)
    elseif(HOST_ARCH MATCHES "(x|X)86")
        set(MINGW_W w32)
        set(MSYS_HOST i686)
    else()
        message(FATAL_ERROR "Unsupported host architecture ${HOST_ARCH}!" )
    endif()

    if(VCPKG_TARGET_ARCHITECTURE MATCHES "(x|X)64")
        set(MSYS_TARGET x86_64)
        set(MINGW_W_TARGET 64)
        et(GCC_LIB_SUFFIX s_seh-1)
    elseif(VCPKG_TARGET_ARCHITECTURE MATCHES "(x|X)86")
        set(MSYS_TARGET i686)
        set(MINGW_W_TARGET 32)
        set(GCC_LIB_SUFFIX s_dw2-1)
    else()
        message(FATAL_ERROR "Unsupported target architecture ${VCPKG_TARGET_ARCHITECTURE}!" )
    endif()


    vcpkg_acquire_msys(MSYS_ROOT PACKAGES "mingw-w64-${MSYS_HOST}-gcc-fortran") # TODO: make x86 work

    set(MINGW_BIN "${MSYS_ROOT}/mingw${MINGW_W_TARGET}/bin/")
    set(MINGW_Fortran_DLLS "${MINGW_BIN}/libgfortran-5.dll"
                           "${MINGW_BIN}/libquadmath-0.dll"
                           "${MINGW_BIN}/libwinpthread-1.dll"
                           "${MINGW_BIN}/libgcc_${GCC_LIB_SUFFIX}.dll")
    file(INSTALL ${MINGW_Fortran_DLLS} DESTINATION "${CURRENT_PACKAGES_DIR}/bin")
    file(INSTALL ${MINGW_Fortran_DLLS} DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin")
    set(VCPKG_POLICY_SKIP_DUMPBIN_CHECKS enabled) # due to outdated msvcrt
    set(VCPKG_POLICY_DLLS_WITHOUT_LIBS enabled)
    set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)
    file(INSTALL "${MSYS_ROOT}/mingw${MINGW_W_TARGET}/share/licenses/winpthreads" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}/license")
    file(INSTALL "${MSYS_ROOT}/mingw${MINGW_W_TARGET}/share/licenses/gcc-libs" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}/license")
    file(INSTALL "${MSYS_ROOT}/mingw${MINGW_W_TARGET}/share/licenses/crt/COPYING.MinGW-w64-runtime.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
else()
    set(VCPKG_POLICY_EMPTY_PACKAGE enabled)
endif()