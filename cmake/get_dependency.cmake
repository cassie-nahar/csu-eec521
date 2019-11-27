include_guard(GLOBAL)

# Tell CMake how to find dependencies
list(PREPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/Modules)

# Add dependency search locations
get_filename_component(DRESS_DEPS_PATH ${CMAKE_SOURCE_DIR}/deps ABSOLUTE)
if (CMAKE_CROSSCOMPILING)
	string(APPEND DRESS_DEPS_PATH "/${CMAKE_SYSTEM_PROCESSOR}")
	list(APPEND CMAKE_FIND_ROOT_PATH ${DRESS_DEPS_PATH})
endif()

file(GLOB DEPENDENCY_DIRS ${DRESS_DEPS_PATH}/*/)
list(PREPEND CMAKE_PREFIX_PATH ${DEPENDENCY_DIRS})
