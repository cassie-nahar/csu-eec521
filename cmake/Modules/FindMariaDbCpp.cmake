# File:        DRESS/cmake/Modules/FindMariaDbCpp.cmake
# Authors:     Kevin Rak
# Description: This is the CMake file responsible for locating MariaDbCpp and creating targets for it.

INCLUDE(LibFindMacros)

if(NOT TARGET MariaDbCpp::Headers)
	FIND_PATH(MariaDbCpp_INCLUDE_DIR
		      NAMES mariadb++/types.hpp
			  PATHS ${CMAKE_PREFIX_PATH}
			  PATH_SUFFIXES include
			  NO_DEFAULT_PATH
			 )
	if (NOT MariaDbCpp_INCLUDE_DIR STREQUAL "MariaDbCpp_INCLUDE_DIR-NOTFOUND")
		add_library(MariaDbCpp::Headers INTERFACE IMPORTED)
		set_target_properties(MariaDbCpp::Headers PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${MariaDbCpp_INCLUDE_DIR}")
	endif()
	SET(MariaDbCpp_PROCESS_INCLUDES MariaDbCpp_INCLUDE_DIR)
endif()

if(NOT TARGET MariaDbCpp::Library)
	FIND_LIBRARY(MariaDbCpp_LIBRARY
		         NAMES mariadbclientpp
				 PATHS ${CMAKE_PREFIX_PATH}
				 PATH_SUFFIXES lib lib64 lib/${CMAKE_LIBRARY_ARCHITECTURE}
				 NO_DEFAULT_PATH
				)
	if (NOT MariaDbCpp_LIBRARY STREQUAL "MariaDbCpp_LIBRARY-NOTFOUND")
		add_library(MariaDbCpp::Library UNKNOWN IMPORTED)
		set_target_properties(MariaDbCpp::Library PROPERTIES IMPORTED_LOCATION "${MariaDbCpp_LIBRARY}" )
		target_link_libraries(MariaDbCpp::Library INTERFACE MariaDbCpp::Headers)

		find_package(MySQL REQUIRED)
		target_link_libraries(MariaDbCpp::Library INTERFACE MySQL::Library)
		target_link_libraries(MariaDbCpp::Headers INTERFACE MySQL::Headers)
	endif()
	LIST(APPEND MariaDbCpp_PROCESS_LIBS MariaDbCpp_LIBRARY)
endif()

LIBFIND_PROCESS(MariaDbCpp)

FOREACH(component ${MariaDbCpp_PROCESS_INCLUDES})
    message(STATUS "  ${component} = ${${component}}")
ENDFOREACH()
FOREACH(component ${MariaDbCpp_PROCESS_LIBS})
    message(STATUS "  ${component} = ${${component}}")
ENDFOREACH()
