include(${CMAKE_SOURCE_DIR}/cmake/get_dependency.cmake)

set(BOOST_ROOT ${DRESS_DEPS_PATH}/boost)
set(Boost_NO_SYSTEM_PATHS ON)

if (BUILD_BOOST)
	message (WARNING "Building Boost. NOTE: The Boost targets will not be available until you re-run CMake.")
	include(ExternalProject)

	####### Boost #######
	SET(B2_CMD ./b2
		-j${N}          # Use all your cores to build
		link=static     # Make static libraries so we don't have to distribute boost alongside our binaries
		cflags=-fPIC    # Force position-independent code (C)
		cxxflags=-fPIC  # Force position-independent code (C++)
		)
	if (CMAKE_CROSSCOMPILING)
		# B2 looks for a user-config.jam file to figure out how to cross compile.
		file(MAKE_DIRECTORY ${BOOST_ROOT})
		file(WRITE ${BOOST_ROOT}/user-config.jam "using gcc : ${CMAKE_SYSTEM_PROCESSOR} : ${CMAKE_CXX_COMPILER} ;")

		SET(B2_CMD ${B2_CMD}
			--user-config=${BOOST_ROOT}/user-config.jam
			toolset=gcc-${CMAKE_SYSTEM_PROCESSOR}
			abi=aapcs
			)
	endif()

	# There is a bug which affects every version of Boost after 1.68 when cross-compiling for arm. (See https://github.com/boostorg/build/issues/385 )
	# This is why we have the boost_1.70.0_xc.patch patch step below. If a later version of boost fixes that, then we can remove that step.
	ExternalProject_Add(  boost
		URL				  /home/krak/repos/boost # https://downloads.sourceforge.net/project/boost/boost/1.70.0/boost_1_70_0.tar.gz
		BUILD_IN_SOURCE   1
		PATCH_COMMAND     git apply ${CMAKE_SOURCE_DIR}/cmake/boost_1.70.0_xc.patch
		CONFIGURE_COMMAND ./bootstrap.sh --prefix=${DRESS_DEPS_PATH}/boost # bootstrap creates the b2 executable
		BUILD_COMMAND     ${B2_CMD} --with-python --with-system --with-chrono install
		INSTALL_COMMAND   ""
		)
else()
	find_package(Boost 1.70 EXACT)
	if (NOT Boost_FOUND)
		message(FATAL_ERROR "Could not find Boost installation. Try running with -DBUILD_BOOST=ON")
	endif()
endif()

unset(BUILD_BOOST CACHE)
