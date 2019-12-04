# File:        DRESS/cmake/Modules/FindCivetWeb.cmake
# Authors:     Kevin Rak
# Description: This is the CMake file responsible for locating CivetWeb and creating targets for it.

INCLUDE(LibFindMacros)

if(NOT TARGET CivetWeb::Headers)
	FIND_PATH(CivetWeb_INCLUDE_DIR
		      NAMES civetweb.h CivetServer.h
			  PATHS ${CMAKE_PREFIX_PATH}
			  PATH_SUFFIXES include
			  NO_DEFAULT_PATH
			 )
		if (NOT CivetWeb_INCLUDE_DIR STREQUAL "CivetWeb_INCLUDE_DIR-NOTFOUND")
		add_library(CivetWeb::Headers INTERFACE IMPORTED)
		set_target_properties(CivetWeb::Headers PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${CivetWeb_INCLUDE_DIR}")
	endif()
	SET(CivetWeb_PROCESS_INCLUDES CivetWeb_INCLUDE_DIR)
endif()

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

if(NOT TARGET CivetWeb::Library)
	FIND_LIBRARY(civetweb_LIBRARY
		         NAMES civetweb
				 PATHS ${CMAKE_PREFIX_PATH}
				 PATH_SUFFIXES lib lib64 lib/${CMAKE_LIBRARY_ARCHITECTURE}
				 NO_DEFAULT_PATH
				)
			if (NOT civetweb_LIBRARY STREQUAL "civetweb_LIBRARY-NOTFOUND")
		add_library(CivetWeb::Library UNKNOWN IMPORTED)
		set_target_properties(CivetWeb::Library PROPERTIES IMPORTED_LOCATION "${civetweb_LIBRARY}" )
		target_link_libraries(CivetWeb::Library INTERFACE CivetWeb::Headers Threads::Threads)
	endif()
	LIST(APPEND CivetWeb_PROCESS_LIBS civetweb_LIBRARY)
endif()

if(NOT TARGET CivetWeb::Library-CPP)
	FIND_LIBRARY(civetweb_cpp_LIBRARY
		         NAMES civetweb-cpp
				 PATHS ${CMAKE_PREFIX_PATH}
				 PATH_SUFFIXES lib lib64 lib/${CMAKE_LIBRARY_ARCHITECTURE}
				 NO_DEFAULT_PATH
				)
			if (NOT civetweb_cpp_LIBRARY STREQUAL "civetweb_cpp_LIBRARY-NOTFOUND")
		add_library(CivetWeb::Library-CPP UNKNOWN IMPORTED)
		set_target_properties(CivetWeb::Library-CPP PROPERTIES IMPORTED_LOCATION "${civetweb_cpp_LIBRARY}" )
		target_link_libraries(CivetWeb::Library-CPP INTERFACE CivetWeb::Library)
	endif()
	LIST(APPEND CivetWeb_PROCESS_LIBS civetweb_cpp_LIBRARY)
endif()

LIBFIND_PROCESS(CivetWeb)

FOREACH(component ${CivetWeb_PROCESS_INCLUDES})
    message(STATUS "  ${component} = ${${component}}")
ENDFOREACH()
FOREACH(component ${CivetWeb_PROCESS_LIBS})
    message(STATUS "  ${component} = ${${component}}")
ENDFOREACH()
