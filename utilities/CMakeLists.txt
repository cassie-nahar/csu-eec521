cmake_minimum_required(VERSION 3.5)
project(DRESS_UTILITIES)

# Simplify target creation
include(${CMAKE_SOURCE_DIR}/cmake/make_target.cmake)

# System utilities such as getting the system clock time or reading directories
make_target(STATIC_LIBRARY System)

# WebServer utility which encapsulates the CivetWeb library
include(${CMAKE_SOURCE_DIR}/cmake/get_CivetWeb.cmake)
if(TARGET CivetWeb::Headers)
	make_target(STATIC_LIBRARY WebServer)
	target_compile_definitions(WebServer PRIVATE DRESS_WWW_DIR="${CMAKE_CURRENT_SOURCE_DIR}/WebServer/www")
	target_link_libraries(WebServer PRIVATE CivetWeb::Library-CPP)
	target_link_libraries(WebServer PUBLIC System)
endif()

# Database utility which encapsulates the MariaDb and MySQL libraries
include(${CMAKE_SOURCE_DIR}/cmake/get_MariaDbCpp.cmake)
if(TARGET MariaDbCpp::Library)
	make_target(STATIC_LIBRARY Database)
	target_compile_definitions(Database PUBLIC DRESS_DB_USER="monitor")
	target_compile_definitions(Database PUBLIC DRESS_DB_PASS="monitor")
	target_compile_definitions(Database PUBLIC DRESS_DB_NAME="DRESS_ATMOSPHERIC")
	target_link_libraries(Database PRIVATE MariaDbCpp::Library)
endif()

