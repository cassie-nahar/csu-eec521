include(${CMAKE_SOURCE_DIR}/cmake/get_dependency.cmake)

find_package(CivetWeb)

if(NOT TARGET CivetWeb::Headers)
	message(STATUS "Could not find CivetWeb. Acquiring it now. CMake will have to be re-run . . .")

	include(ExternalProject)

	####### CivetWeb #######
	ExternalProject_Add( civet
		GIT_REPOSITORY   https://github.com/civetweb/civetweb.git
		GIT_TAG          ceda698 # This is when Link-time optimization became optional. No release since then yet (10/31/2019)
		CMAKE_GENERATOR  ${CMAKE_GENERATOR}
		CMAKE_ARGS       -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
		                 -DCMAKE_FIND_ROOT_PATH=${CMAKE_FIND_ROOT_PATH}
						 -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
						 -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
						 -DCMAKE_CXX_STANDARD_REQUIRED=${CMAKE_CXX_STANDARD_REQUIRED}
						 -DCMAKE_C_STANDARD_REQUIRED=${CMAKE_C_STANDARD_REQUIRED}
						 -DCMAKE_BUILD_TYPE=RELEASE
						 -DBUILD_TESTING=OFF
						 -DCIVETWEB_BUILD_TESTING=OFF
						 -DCIVETWEB_ENABLE_LTO=OFF
						 -DCIVETWEB_CXX_ENABLE_LTO=OFF
						 -DCIVETWEB_ENABLE_CXX=ON
						 -DCIVETWEB_ENABLE_SSL=OFF
						 -DCIVETWEB_ENABLE_WEBSOCKETS=ON
						 -DCMAKE_CXX_FLAGS=-fPIC
						 -DCMAKE_C_FLAGS=-fPIC
						 -DCMAKE_INSTALL_PREFIX=${DRESS_DEPS_PATH}/civetweb
	)

    message(STATUS "CivetWeb has been acquired. Please re-run CMake.")

endif()
