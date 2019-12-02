include(${CMAKE_SOURCE_DIR}/cmake/get_dependency.cmake)

if (BUILD_SIMPLEAMQP)
	message (STATUS "Building SimpleAmqp. NOTE: The SimpleAmqp::Library target will not be available until you re-run CMake.")
	include(ExternalProject)

	####### SimpleAmqp #######
	# The SimpleAmqpClient library cannot be built as a static library on Win32.
	set(SIMPLEAMQP_BUILD_SHARED_LIBS OFF)
	if (WIN32)
		set(SIMPLEAMQP_BUILD_SHARED_LIBS ON)
	endif ()

	# The SimpleAmqpClient repo has compile bugs in version 2.3 and 2.4.0, but 2.5 is good. Unfortunately 2.5 isn't tagged yet (10/02/2019).
	# Options are roll back to 2.2 (which has annoying compiler warnings), or to use a commit SHA for 2.5 which is what I do here.
	# Unfortunately, using a SHA means we can't use GIT_SHALLOW.
	ExternalProject_Add( SimpleAmqp
		DEPENDS          boost rabbitmqc
		GIT_REPOSITORY   https://github.com/alanxz/SimpleAmqpClient.git
		GIT_TAG          eefabcd
		CMAKE_GENERATOR  ${CMAKE_GENERATOR}
		CMAKE_ARGS       -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
		                 -DCMAKE_FIND_ROOT_PATH=${CMAKE_FIND_ROOT_PATH}
						 -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
						 -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
						 -DCMAKE_CXX_STANDARD_REQUIRED=${CMAKE_CXX_STANDARD_REQUIRED}
						 -DCMAKE_C_STANDARD_REQUIRED=${CMAKE_C_STANDARD_REQUIRED}
						 -DCMAKE_BUILD_TYPE=RELEASE
						 -DBUILD_SHARED_LIBS=${SIMPLEAMQP_BUILD_SHARED_LIBS}
						 -DRabbitmqc_DIR=${DEPS_PATH}/rabbitmq-c
						 -DCMAKE_PREFIX_PATH=${DEPS_PATH}/rabbitmq-c/lib/${CMAKE_LIBRARY_ARCHITECTURE}
						 -DBOOST_ROOT=${BOOST_ROOT}
						 -DBoost_NO_SYSTEM_PATHS=ON
						 -DCMAKE_CXX_FLAGS=-fPIC -Wall -Wextra
						 -DCMAKE_C_FLAGS=-fPIC
						 -DCMAKE_INSTALL_PREFIX=${DEPS_PATH}/SimpleAmqp
	)
else()
	find_package(SimpleAmqp)
	if (NOT SimpleAmqp_FOUND)
		message(FATAL_ERROR "Could not find SimpleAmqp installation. Try running with -DBUILD_SIMPLEAMQP=ON")
	endif()
endif()

unset(BUILD_SIMPLEAMQP CACHE)
