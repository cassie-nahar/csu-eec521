// File:        DRESS/utilities/Database/Database.h
// Authors:     Kevin Rak
// Description: This is the Database definition file. It is responsible for
//              defining the abstract Database class and a static Create method.

#ifndef DATABASE_H
#define DATABASE_H

#include <memory>
#include <vector>
#include <typeindex>

namespace DRESS {

	class Database {
	public:
		using ptr_t=std::shared_ptr<Database>;
		/*!
		 * \brief Create
		 * \param database
		 * \param server
		 * \return
		 */
		static ptr_t Create(std::string database = DRESS_DB_NAME, std::string server = "localhost");
		virtual ~Database() = default;

		/*!
		 * \brief Get
		 * \param QueryString
		 * \return
		 */
		virtual std::string Get(std::string QueryString) = 0;

		/*!
		 * \brief Put
		 * \param InsertString
		 * \return
		 */
		virtual uint64_t Put(std::string InsertString) = 0;

	protected:
		Database() = default;
	};

}

#endif // DATABASE_H
