INCLUDE(LibFindMacros)

if(NOT TARGET MySQL::Headers)
    FIND_PATH(MySQL_INCLUDE_DIR
        NAMES mysql.h
		PATHS ${CMAKE_INCLUDE_PATH} ${CMAKE_PREFIX_PATH}
		PATH_SUFFIXES mysql
    )
    if (NOT MySQL_INCLUDE_DIR STREQUAL "MySQL_INCLUDE_DIR-NOTFOUND")
        add_library(MySQL::Headers INTERFACE IMPORTED)
        set_target_properties(MySQL::Headers PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${MySQL_INCLUDE_DIR}" )
    endif()
    SET(MySQL_PROCESS_INCLUDES MySQL_INCLUDE_DIR)
endif()

# libz is required for mysqlclient's compression functions
if(NOT TARGET System::z)
	FIND_LIBRARY(z_LIBRARY
		         NAMES libz.a z
				 PATHS ${CMAKE_PREFIX_PATH}
				 PATH_SUFFIXES lib lib64 lib/${CMAKE_LIBRARY_ARCHITECTURE}
				)
	if (NOT z_LIBRARY STREQUAL "z_LIBRARY-NOTFOUND")
		add_library(System::z UNKNOWN IMPORTED)
		set_target_properties(System::z PROPERTIES IMPORTED_LOCATION "${z_LIBRARY}" )
	endif()
	LIST(APPEND MySQL_PROCESS_LIBS z_LIBRARY)
endif()

if(NOT TARGET System::ssl)
	FIND_LIBRARY(ssl_LIBRARY
		         NAMES libssl.a ssl
				 PATHS ${CMAKE_PREFIX_PATH}
				 PATH_SUFFIXES lib lib64 lib/${CMAKE_LIBRARY_ARCHITECTURE}
				)
	if (NOT ssl_LIBRARY STREQUAL "ssl_LIBRARY-NOTFOUND")
		add_library(System::ssl UNKNOWN IMPORTED)
		set_target_properties(System::ssl PROPERTIES IMPORTED_LOCATION "${ssl_LIBRARY}" )
	endif()
	LIST(APPEND MySQL_PROCESS_LIBS ssl_LIBRARY)
endif()

if(NOT TARGET System::crypto)
	FIND_LIBRARY(crypto_LIBRARY
		         NAMES libcrypto.a crypto
				 PATHS ${CMAKE_PREFIX_PATH}
				 PATH_SUFFIXES lib lib64 lib/${CMAKE_LIBRARY_ARCHITECTURE}
				)
	if (NOT crypto_LIBRARY STREQUAL "crypto_LIBRARY-NOTFOUND")
		add_library(System::crypto UNKNOWN IMPORTED)
		set_target_properties(System::crypto PROPERTIES IMPORTED_LOCATION "${crypto_LIBRARY}" )
	endif()
	LIST(APPEND MySQL_PROCESS_LIBS crypto_LIBRARY)
endif()

if(NOT TARGET MySQL::Library)
    FIND_LIBRARY(MySQL_LIBRARY
		         NAMES mysqlclient mariadbclient
                 PATHS ${CMAKE_PREFIX_PATH}
				 PATH_SUFFIXES lib lib/mysql lib64 lib64/mysql lib/${CMAKE_LIBRARY_ARCHITECTURE} lib/${CMAKE_LIBRARY_ARCHITECTURE}/mysql
                )
    if (NOT MySQL_LIBRARY STREQUAL "MySQL_LIBRARY-NOTFOUND")
        add_library(MySQL::Library UNKNOWN IMPORTED)
        set_target_properties(MySQL::Library PROPERTIES IMPORTED_LOCATION "${MySQL_LIBRARY}" )
		target_link_libraries(MySQL::Library INTERFACE MySQL::Headers)
		target_link_libraries(MySQL::Library INTERFACE System::z)
		target_link_libraries(MySQL::Library INTERFACE System::ssl)
		target_link_libraries(MySQL::Library INTERFACE System::crypto)
		target_link_libraries(MySQL::Library INTERFACE ${CMAKE_DL_LIBS})
    endif()
    LIST(APPEND MySQL_PROCESS_LIBS MySQL_LIBRARY)
endif()

LIBFIND_PROCESS(MySQL)

FOREACH(component ${MySQL_PROCESS_INCLUDES})
    message(STATUS "  ${component} = ${${component}}")
ENDFOREACH()
FOREACH(component ${MySQL_PROCESS_LIBS})
    message(STATUS "  ${component} = ${${component}}")
ENDFOREACH()
