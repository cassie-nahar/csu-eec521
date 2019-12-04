// File:        DRESS/utilities/Database/private/MariaDatabase.cpp
// Authors:     Kevin Rak
// Description: This is the MariaDatabase implementation file. It is responsible for
//              implenting the behaviors for Getting and Putting information in the database

#include <utilities/Database/private/MariaDatabase.h>

namespace DRESS {

	MariaDatabase::MariaDatabase(std::string database, std::string server) :
		Database(),
		_account(mariadb::account::create(server, DRESS_DB_USER, DRESS_DB_PASS, database)),
		_connection(mariadb::connection::create(_account)) {}


	std::string MariaDatabase::Get(std::string QueryString) {
		try {
			mariadb::result_set_ref result = _connection->query(QueryString);
			std::string JsonObject;

			JsonObject += "{\"result\":[";
			bool first_row = true;
			while (result->next()) {
				if (!first_row) {
					JsonObject += ",";
				}
				first_row = false;
				JsonObject += "{";
				for (uint32_t column_index = 0; column_index < result->column_count(); column_index++) {
					if (column_index > 0) {
						JsonObject += ",";
					}
					JsonObject += "\"" + result->column_name(column_index) + "\":\"";
					switch (result->column_type(column_index)) {
					case mariadb::value::data:
						JsonObject += result->get_data(column_index)->string();
						break;
					case mariadb::value::date:
						JsonObject += result->get_date(column_index).str_date();
						break;
					case mariadb::value::date_time:
						JsonObject += result->get_date_time(column_index).str_time() + " " + result->get_date_time(column_index).str_date();
						break;
					case mariadb::value::time:
						JsonObject += result->get_time(column_index).str_time();
						break;
					case mariadb::value::string:
					case mariadb::value::blob:
						JsonObject += result->get_string(column_index);
						break;
					case mariadb::value::boolean:
						JsonObject += (result->get_boolean(column_index) ? "TRUE" : "FALSE");
						break;
					case mariadb::value::decimal:
						JsonObject += result->get_decimal(column_index).str();
						break;
					case mariadb::value::unsigned8:
						JsonObject += std::to_string(result->get_unsigned8(column_index));
						break;
					case mariadb::value::signed8:
						JsonObject += std::to_string(result->get_signed8(column_index));
						break;
					case mariadb::value::unsigned16:
						JsonObject += std::to_string(result->get_unsigned16(column_index));
						break;
					case mariadb::value::signed16:
						JsonObject += std::to_string(result->get_signed16(column_index));
						break;
					case mariadb::value::unsigned32:
						JsonObject += std::to_string(result->get_unsigned32(column_index));
						break;
					case mariadb::value::signed32:
						JsonObject += std::to_string(result->get_signed32(column_index));
						break;
					case mariadb::value::unsigned64:
						JsonObject += std::to_string(result->get_unsigned64(column_index));
						break;
					case mariadb::value::signed64:
						JsonObject += std::to_string(result->get_signed64(column_index));
						break;
					case mariadb::value::float32:
						JsonObject += std::to_string(result->get_signed32(column_index));
						break;
					case mariadb::value::double64:
						JsonObject += std::to_string(result->get_double(column_index));
						break;
					case mariadb::value::null:
					case mariadb::value::enumeration:
						std::string message = "ERROR: Cannot display a value of type NULL or ENUMERATION.";
						std::cerr << message << std::endl << std::flush;
						throw(std::runtime_error(message));
					}
					JsonObject += "\"";
				}
				JsonObject += "}";
			}
			JsonObject += "]}";
			return JsonObject;
		} catch (...) {
			std::string message = "ERROR: Could not process MariaDB Connection.";
			std::cerr << message << std::endl << std::flush;
			return message;
		}
	}

	uint64_t MariaDatabase::Put(std::string InsertString) {
		return _connection->insert(InsertString);
	}

}
