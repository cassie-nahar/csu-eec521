include(${CMAKE_SOURCE_DIR}/cmake/get_dependency.cmake)

if (BUILD_MYSQL)
	message (WARNING "Building MySQL. NOTE: The MySQL targets will not be available until you re-run CMake.")
	include(ExternalProject)

	####### mysqlcppconn7 #######
	ExternalProject_Add(    mysqlcppconn7
		URL                 https://dev.mysql.com/get/Downloads/Connector-C++/libmysqlcppconn7_8.0.18-1ubuntu18.04_amd64.deb
		DOWNLOAD_NO_EXTRACT 1
		CONFIGURE_COMMAND   ""
		BUILD_COMMAND       dpkg -x libmysqlcppconn7_8.0.18-1ubuntu18.04_amd64.deb ${DRESS_DEPS_PATH}/MySQL
		BUILD_IN_SOURCE     1
		INSTALL_COMMAND     ""
	)

    ####### libmysqlcppconn8-2 #######
	ExternalProject_Add(    libmysqlcppconn8-2
		URL                 https://dev.mysql.com/get/Downloads/Connector-C++/libmysqlcppconn8-2_8.0.18-1ubuntu18.04_amd64.deb
		DOWNLOAD_NO_EXTRACT 1
		CONFIGURE_COMMAND   ""
		BUILD_COMMAND       dpkg -x libmysqlcppconn8-2_8.0.18-1ubuntu18.04_amd64.deb ${DRESS_DEPS_PATH}/MySQL
		BUILD_IN_SOURCE     1
		INSTALL_COMMAND     ""
	)

    ####### libmysqlcppconn-dev #######
	ExternalProject_Add(    libmysqlcppconn-dev
		URL                 https://dev.mysql.com/get/Downloads/Connector-C++/libmysqlcppconn-dev_8.0.18-1ubuntu18.04_amd64.deb
		DOWNLOAD_NO_EXTRACT 1
		CONFIGURE_COMMAND   ""
		BUILD_COMMAND       dpkg -x libmysqlcppconn-dev_8.0.18-1ubuntu18.04_amd64.deb ${DRESS_DEPS_PATH}/MySQL
		BUILD_IN_SOURCE     1
		INSTALL_COMMAND     ""
	)

else()
	find_package(MySQL)
	if (NOT MySQL_FOUND)
		message(FATAL_ERROR "Could not find MySQL installation. Try running with -DBUILD_MYSQL=ON")
	endif()
endif()

unset(BUILD_MYSQL CACHE)
