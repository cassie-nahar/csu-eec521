INCLUDE(LibFindMacros)

if(NOT TARGET SimpleAmqp::Headers)
	FIND_PATH(SimpleAmqp_INCLUDE_DIR
		      NAMES SimpleAmqpClient/SimpleAmqpClient.h
			  PATHS ${CMAKE_PREFIX_PATH}
			  PATH_SUFFIXES include
			  NO_DEFAULT_PATH
			 )
		if (NOT SimpleAmqp_INCLUDE_DIR STREQUAL "SimpleAmqp_INCLUDE_DIR-NOTFOUND")
		add_library(SimpleAmqp::Headers INTERFACE IMPORTED)
		set_target_properties(SimpleAmqp::Headers PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${SimpleAmqp_INCLUDE_DIR}" )
	endif()
	SET(SimpleAmqp_PROCESS_INCLUDES SimpleAmqp_INCLUDE_DIR)
endif()

if(NOT TARGET SimpleAmqp::Library)
	FIND_LIBRARY(SimpleAmqp_LIBRARY
		         NAMES SimpleAmqpClient
				 PATHS ${CMAKE_PREFIX_PATH}
				 PATH_SUFFIXES lib lib64 lib/${CMAKE_LIBRARY_ARCHITECTURE}
				 NO_DEFAULT_PATH
				)
			if (NOT SimpleAmqp_LIBRARY STREQUAL "SimpleAmqp_LIBRARY-NOTFOUND")
		add_library(SimpleAmqp::Library UNKNOWN IMPORTED)
		set_target_properties(SimpleAmqp::Library PROPERTIES IMPORTED_LOCATION "${SimpleAmqp_LIBRARY}" )
		target_link_libraries(SimpleAmqp::Library INTERFACE SimpleAmqp::Headers)

		find_package(Rabbitmqc REQUIRED)
		target_link_libraries(SimpleAmqp::Library INTERFACE Rabbitmqc::Library)

		if (NOT CMAKE_CROSSCOMPILING)
			find_library(rt_LIBRARY rt)
			if (NOT LIBRT STREQUAL "rt_LIBRARY-NOTFOUND")
				add_library(System::rt UNKNOWN IMPORTED)
				set_target_properties(System::rt PROPERTIES IMPORTED_LOCATION "${rt_LIBRARY}" )
				target_link_libraries(SimpleAmqp::Library INTERFACE System::rt)
			endif()
			LIST(APPEND SimpleAmqp_PROCESS_LIBS rt_LIBRARY)
		endif()

		find_package(Boost COMPONENTS chrono)
		if (TARGET Boost::chrono)
			target_link_libraries(SimpleAmqp::Library INTERFACE Boost::chrono)
		endif()
	endif()
	LIST(APPEND SimpleAmqp_PROCESS_LIBS SimpleAmqp_LIBRARY)
endif()

LIBFIND_PROCESS(SimpleAmqp)

FOREACH(component ${SimpleAmqp_PROCESS_INCLUDES})
    message(STATUS "  ${component} = ${${component}}")
ENDFOREACH()
FOREACH(component ${SimpleAmqp_PROCESS_LIBS})
    message(STATUS "  ${component} = ${${component}}")
ENDFOREACH()
