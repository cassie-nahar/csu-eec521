#ifndef DATABASE_H
#define DATABASE_H

#include <memory>
#include <vector>
#include <typeindex>

namespace DRESS {

	class Database {
	public:
		using ptr_t=std::shared_ptr<Database>;
		static ptr_t Create(std::string database, std::string server = std::string());

		enum DataType {
			UNKNOWN,
			BIT,
			TINYINT,
			SMALLINT,
			MEDIUMINT,
			INTEGER,
			BIGINT,
			REAL,
			DOUBLE,
			DECIMAL,
			NUMERIC,
			CHAR,
			BINARY,
			VARCHAR,
			VARBINARY,
			LONGVARCHAR,
			LONGVARBINARY,
			TIMESTAMP,
			DATE,
			TIME,
			GEOMETRY,
			ENUM,
			SET,
			SQLNULL
		};

		template<typename T>
		static AsType(std::var);

		struct Column {
			std::string Name;
			DataType Type;
		};

		std::vector<Column> GetColumns();


	protected:
		Database() = default;
	};

}

#endif // DATABASE_H
