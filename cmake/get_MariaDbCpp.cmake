include(${CMAKE_SOURCE_DIR}/cmake/get_dependency.cmake)

if (BUILD_MARIADBCPP)
	message (WARNING "Building MariaDbCpp. NOTE: The MariaDbCpp::Library target will not be available until you re-run CMake.")
	include(ExternalProject)

	####### MariaDbCpp #######
	ExternalProject_Add( MariaDbCpp
		GIT_REPOSITORY   https://github.com/viaduck/mariadbpp.git
		CMAKE_GENERATOR  ${CMAKE_GENERATOR}
		CMAKE_ARGS       -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
		                 -DCMAKE_FIND_ROOT_PATH=${CMAKE_FIND_ROOT_PATH}
						 -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
						 -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
						 -DCMAKE_CXX_STANDARD_REQUIRED=${CMAKE_CXX_STANDARD_REQUIRED}
						 -DCMAKE_C_STANDARD_REQUIRED=${CMAKE_C_STANDARD_REQUIRED}
						 -DCMAKE_BUILD_TYPE=RELEASE
						 -DCMAKE_CXX_FLAGS=-fPIC
						 -DCMAKE_C_FLAGS=-fPIC
						 -DCMAKE_INSTALL_PREFIX=${DRESS_DEPS_PATH}/MariaDbCpp
	)
else()
	find_package(MariaDbCpp)
	if (NOT MariaDbCpp_FOUND)
		message(FATAL_ERROR "Could not find MariaDbCpp installation. Try running with -DBUILD_MARIADBCPP=ON")
	endif()
endif()

unset(BUILD_MARIADBCPP CACHE)
