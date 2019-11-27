cmake_minimum_required(VERSION 3.5)
project(DRESS_UTILITIES)

# Simplify target creation
include(${CMAKE_SOURCE_DIR}/cmake/make_target.cmake)

# Find dependencies
include(${CMAKE_SOURCE_DIR}/cmake/get_CivetWeb.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/get_SimpleAmqp.cmake)

make_target(STATIC_LIBRARY System)

make_target(STATIC_LIBRARY WebServer)
target_compile_definitions(WebServer PRIVATE DRESS_WWW_DIR="${CMAKE_CURRENT_SOURCE_DIR}/WebServer/www")
target_link_libraries(WebServer PRIVATE CivetWeb::Library-CPP)
target_link_libraries(WebServer PUBLIC System)
