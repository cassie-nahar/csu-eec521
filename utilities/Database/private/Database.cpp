#include <utilities/Database/Database.h>
#include <utilities/Database/private/MariaDatabase.h>

namespace DRESS {

	Database::ptr_t Database::Create(std::string database, std::string server) {
		return ptr_t(new MariaDatabase(database, server));
	}

}
