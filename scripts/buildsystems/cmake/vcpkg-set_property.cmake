option(VCPKG_ENABLE_SET_PROPERTY "Enables override of the cmake function set_property." ON)
mark_as_advanced(VCPKG_ENABLE_SET_PROPERTY)
CMAKE_DEPENDENT_OPTION(VCPKG_ENABLE_SET_PROPERTY_EXTERNAL_OVERRIDE "Tells VCPKG to use _set_property instead of set_property." OFF "NOT VCPKG_ENABLE_SET_TARGET_PROPERTIES" OFF)
mark_as_advanced(VCPKG_ENABLE_SET_PROPERTY_EXTERNAL_OVERRIDE)

function(vcpkg_set_property _vcpkg_set_property_mode_impl)
    if(${_vcpkg_set_property_mode_impl} MATCHES "TARGET" AND "${ARGV}" MATCHES "IMPORTED_LOCATION|IMPORTED_IMPLIB")
        cmake_parse_arguments(PARSE_ARGV 1 _vcpkg_set_property "APPEND;APPEND_STRING" "" "PROPERTY")
    else()
        if(VCPKG_ENABLE_SET_PROPERTY OR VCPKG_ENABLE_SET_PROPERTY_EXTERNAL_OVERRIDE)
            _set_property(${ARGV})
        else()
            set_property(${ARGV})
        endif()
    endif()
endfunction()

if(VCPKG_ENABLE_SET_PROPERTY)
    function(set_property _vcpkg_set_property_mode)
        if(DEFINED _vcpkg_set_property_guard)
            vcpkg_msg(FATAL_ERROR "set_property" "INFINIT LOOP DETECT. Guard _vcpkg_set_property_guard. Did you supply your own set_property override? \n \
                                    If yes: please set VCPKG_ENABLE_SET_PROPERTY off and call vcpkg_set_property if you want to have vcpkg corrected behavior. You might also want to check VCPKG_ENABLE_SET_PROPERTY_EXTERNAL_OVERRIDE\n \
                                    If no: please open an issue on GITHUB describe the fail case!" ALWAYS)
        else()
            set(_vcpkg_set_property_guard ON)
        endif()
        cmake_parse_arguments(PARSE_ARGV 0 _vcpkg_set_property "APPEND;APPEND_STRING" "" "PROPERTY")
        vcpkg_set_property(${ARGV})
        unset(_vcpkg_set_property_guard)
    endfunction()
endif()