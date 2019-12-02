#ifndef DATABASE_H
#define DATABASE_H

#include <memory>
#include <vector>
#include <map>
#include <variant>

namespace DRESS {

	class Database {
	public:
		using ptr_t=std::shared_ptr<Database>;
		static ptr_t Create(std::string DatabaseName, std::string ServerName = std::string());
		virtual ~Database() = default;

		using Field_t = std::variant<std::string, float>;
		using Row_t = std::map<std::string, Field_t>;

		std::string GetServerName();
		std::string GetDatabaseName();
		virtual std::vector<std::string> GetTablesNames() = 0;
		virtual std::vector<std::string> GetColumnNames(std::string TableName) = 0;
		virtual std::vector<Row_t> GetRows(std::string TableName, std::vector<std::string> Fields, std::string Filter);

	protected:
		Database() = default;
	};

}

#endif // DATABASE_H
