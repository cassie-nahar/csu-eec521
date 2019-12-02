#ifndef DATABASE_H
#define DATABASE_H

#include <memory>
#include <vector>
#include <typeindex>

namespace DRESS {

	class Database {
	public:
		using ptr_t=std::shared_ptr<Database>;
		static ptr_t Create(std::string database = DRESS_DB_NAME, std::string server = "localhost");
		virtual ~Database() = default;

		virtual std::string Get(std::string QueryString) = 0;
		virtual uint64_t Put(std::string InsertString) = 0;

	protected:
		Database() = default;
	};

}

#endif // DATABASE_H
