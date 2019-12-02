#ifndef CIVETWEBSERVER_H
#define CIVETWEBSERVER_H

#include <CivetServer.h>
#include <utilities/WebServer/WebServer.h>

namespace DRESS {

	class CivetWebServer : public WebServer {
	public:
		CivetWebServer(int Port, std::string DocumentRoot);  // DRESS_WWW_DIR is defined in utilities/CMakeLists.txt

		/*!
		 * \brief RegisterGetFileHandler
		 * \param URI
		 * \param FilePath
		 */
		void RegisterGetFileHandler(std::string URI, std::string FilePath) override;

		/*!
		 * \brief RegisterGetJsonHandler
		 * \param URI
		 */
		void RegisterGetJsonHandler(std::string URI, std::string(*GetJsonObject)()) override;

		/*!
		 * \brief RegisterPostJsonHandler
		 * \param URI
		 */
		void RegisterPostJsonHandler(std::string URI, void(*PostJsonObject)(const std::string & JsonObject)) override;

	private:
		CivetServer _Server;

		using HandlerPtr_t = std::shared_ptr<CivetHandler>;

		/*!
		 * \brief CreateGetFileHandler
		 * \param URI
		 * \param FilePath
		 * \return
		 */
		static HandlerPtr_t CreateGetFileHandler(std::string URI, std::string FilePath);

		/*!
		 * \brief CreateGetJsonHandler
		 * \param URI
		 * \return
		 */
		static HandlerPtr_t CreateGetJsonHandler(std::string URI, std::string(*GetJsonObject)());

		/*!
		 * \brief CreatePostJsonHandler
		 * \param URI
		 * \return
		 */
		static HandlerPtr_t CreatePostJsonHandler(std::string URI, void(*PostJsonObject)(const std::string & JsonObject));
	};

	/*!
	 * \brief The GetFileHandler class
	 */
	class GetFileHandler : public CivetHandler {
	public:
		GetFileHandler(std::string FilePath);
		bool handleGet(CivetServer *server, struct mg_connection *conn) override;
	private:
		std::string _FilePath;
	};

	/*!
	 * \brief The GetJsonHandler class
	 */
	class GetJsonHandler : public CivetHandler {
	public:
		GetJsonHandler(std::string(*GetJsonObject)());
		bool handleGet(CivetServer *server, struct mg_connection *conn) override;
	private:
		std::string(*_GetJsonObject)();
	};

	/*!
	 * \brief The PostJsonHandler class
	 */
	class PostJsonHandler : public CivetHandler {
	public:
		PostJsonHandler(void(*PostJsonObject)(const std::string & JsonObject));
		bool handlePost(CivetServer *server, struct mg_connection *conn) override;
	private:
		void(*_PostJsonObject)(const std::string & JsonObject);
	};

}

#endif // CIVETWEBSERVER_H
