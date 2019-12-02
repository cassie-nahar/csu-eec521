include_guard(GLOBAL)

include(ProcessorCount)
ProcessorCount(N)
if(N EQUAL 0) # Error, could not determine processor count
	set(N 4)
endif()

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
	# Add a preprocessor define indicating we're in debug mode for use with ifdef or ifndef directives
	add_compile_definitions(DRESS_DEBUG)
endif()

# Tell QtCreator where to deploy binaries on the Raspberry Pi
if (CMAKE_CROSSCOMPILING)
	# From https://doc-snapshots.qt.io/qtcreator-4.0/creator-project-cmake.html
	file(WRITE "${CMAKE_SOURCE_DIR}/QtCreatorDeployment.txt" "/home/pi\n")
endif()

# Binary and Library files are to be put in ${CMAKE_SOURCE_DIR}/bin
get_filename_component(DRESS_BIN_PATH ${CMAKE_SOURCE_DIR}/bin ABSOLUTE)
if (CMAKE_CROSSCOMPILING)
	set(DRESS_BIN_PATH ${DRESS_BIN_PATH}/${CMAKE_SYSTEM_PROCESSOR})
endif()
message(STATUS "Binary outputs will be placed in: ${DRESS_BIN_PATH}")

SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${DRESS_BIN_PATH}") # Shared libraries
SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${DRESS_BIN_PATH}") # Static libraries
SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${DRESS_BIN_PATH}") # Executables

# Ensure any libraries are built with position independent code (fPIC)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

macro(make_target TARGET_TYPE TARGET_PATH)
	project(${TARGET_PATH})

	if(${ARGC} LESS 3)
		get_filename_component(TARGET_NAME "${TARGET_PATH}" NAME)
	else()
		# Optionally, a third parameter can be passed to override the target name
		set(TARGET_NAME "${ARGV2}")
	endif()

	if("${TARGET_TYPE}" STREQUAL "SHARED_LIBRARY")
		add_library(${TARGET_NAME} SHARED "")
	elseif("${TARGET_TYPE}" STREQUAL "STATIC_LIBRARY")
		add_library(${TARGET_NAME} STATIC "")
	elseif("${TARGET_TYPE}" STREQUAL "EXECUTABLE")
		add_executable(${TARGET_NAME} "")
		if (CMAKE_CROSSCOMPILING)
			target_link_libraries(${TARGET_NAME} PUBLIC -static) # TODO: This works, but might cause some problems if library versions mismatch
		endif()
	else()
		message(FATAL_ERROR "This module requires TARGET_TYPE to be defined as either SHARED_LIBRARY, STATIC_LIBRARY, or EXECUTABLE. [${TARGET_TYPE}]")
	endif()

	if(CMAKE_COMPILER_IS_GNUCXX)
		target_compile_options(${TARGET_NAME} PRIVATE -Wall -Wextra)
		set_property(TARGET ${TARGET_NAME} PROPERTY C_STANDARD 11)
		set_property(TARGET ${TARGET_NAME} PROPERTY CXX_STANDARD 17)
	endif()

	target_include_directories(${TARGET_NAME} PRIVATE ${CMAKE_SOURCE_DIR}) # location of the main CMakeLists.txt
	target_include_directories(${TARGET_NAME} PRIVATE ${TARGET_PATH})
	target_include_directories(${TARGET_NAME} PRIVATE ${TARGET_PATH}/include)

	# Find source and header files
	file(GLOB_RECURSE CPP_FILES ${TARGET_PATH}/*.cpp)
	file(GLOB_RECURSE HPP_FILES ${TARGET_PATH}/*.hpp)
	file(GLOB_RECURSE C_FILES ${TARGET_PATH}/*.c)
	file(GLOB_RECURSE H_FILES ${TARGET_PATH}/*.h)
	target_sources(${TARGET_NAME} PRIVATE ${CPP_FILES} ${C_FILES})
	target_sources(${TARGET_NAME} PRIVATE ${HPP_FILES} ${H_FILES})

	# Find Python files
	file(GLOB_RECURSE PY_FILES ${TARGET_PATH}/*.py)
	target_sources(${TARGET_NAME} PRIVATE ${PY_FILES})

	# Find resource files for web pages
	file(GLOB_RECURSE HTML_FILES ${TARGET_PATH}/*.html)
	file(GLOB_RECURSE CSS_FILES ${TARGET_PATH}/*.css)
	file(GLOB_RECURSE JS_FILES ${TARGET_PATH}/*.js)
	file(GLOB_RECURSE PNG_FILES ${TARGET_PATH}/*.png)
	target_sources(${TARGET_NAME} PRIVATE ${HTML_FILES} ${CSS_FILES} ${JS_FILES} ${PNG_FILES})

	if(CMAKE_CROSSCOMPILING)
		# Since all of our dependencies are compiled with the same ABI, we don't need to see all of these warnings.
		target_compile_options(${TARGET_NAME} PRIVATE -Wno-psabi)
		if("${TARGET_TYPE}" STREQUAL "EXECUTABLE")
			# Tell QtCreator to deploy this executable to the Raspberry Pi
			# From https://doc-snapshots.qt.io/qtcreator-4.0/creator-project-cmake.html
			file(APPEND "${CMAKE_SOURCE_DIR}/QtCreatorDeployment.txt" "${DRESS_BIN_PATH}/${TARGET_NAME}:\n")
		endif()
	endif()
endmacro()
