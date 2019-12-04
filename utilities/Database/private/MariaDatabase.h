// File:        DRESS/utilities/Database/private/MariaDatabase.h
// Authors:     Kevin Rak
// Description: This is the MariaDatabase definition file. It is responsible for
//              defining the behaviors for Getting and Putting information in the database

#ifndef MARIADATABASE_H
#define MARIADATABASE_H

#include <mariadb++/account.hpp>
#include <mariadb++/connection.hpp>

#include <utilities/Database/Database.h>

namespace DRESS {

	class MariaDatabase : public Database {
	public:
		MariaDatabase(std::string database, std::string server);

		// Database interface
		std::string Get(std::string QueryString) override;
		uint64_t Put(std::string InsertString) override;

	private:
		mariadb::account_ref _account;
		mariadb::connection_ref _connection;
	};

}

#endif // MARIADATABASE_H
