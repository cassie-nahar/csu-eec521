cmake_minimum_required(VERSION 3.15)
project(DRESS)

# Simplify target creation
include(${CMAKE_SOURCE_DIR}/cmake/make_target.cmake)

# Non-Building target which contains other types of project files
add_custom_target(_files SOURCES
	.gitignore
	Doxyfile
	cmake/Toolchain-RaspberryPi.cmake
	cmake/get_dependency.cmake)

# Subdirectory containing utility classes for database, webserver, messaging, etc.
# NOTE: any external dependencies should be fully encapsulated in targets within the utilities directory
add_subdirectory(${CMAKE_SOURCE_DIR}/utilities)

make_target(EXECUTABLE GUI)
target_link_libraries(GUI PRIVATE WebServer)

project(DRESS) # Just to restore the top-level project name.
