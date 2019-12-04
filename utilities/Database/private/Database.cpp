// File:        DRESS/utilities/Database/private/Database.cpp
// Authors:     Kevin Rak
// Description: This is the Database implementation file. It is responsible for
//              creating a concrete instance of the abstract Database class.

#include <utilities/Database/Database.h>
#include <utilities/Database/private/MariaDatabase.h>

namespace DRESS {

	Database::ptr_t Database::Create(std::string database, std::string server) {
		return ptr_t(new MariaDatabase(database, server));
	}

}
