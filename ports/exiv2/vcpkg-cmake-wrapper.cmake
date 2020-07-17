_find_package(${ARGS})

if("@VCPKG_LIBRARY_LINKAGE@" STREQUAL "static")
    find_package(Iconv REQUIRED)
    find_package(unofficial-gettext CONFIG REQUIRED)
    if(TARGET exiv2lib)
        set_property(TARGET exiv2lib APPEND PROPERTY INTERFACE_LINK_LIBRARIES 
            Iconv::Iconv
            unofficial::gettext::libintl)
    endif()
endif()
