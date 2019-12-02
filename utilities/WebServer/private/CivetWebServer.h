#ifndef CIVETWEBSERVER_H
#define CIVETWEBSERVER_H

#include <CivetServer.h>
#include <utilities/WebServer/WebServer.h>

namespace DRESS {

	class CivetWebServer : public WebServer {
	public:
		CivetWebServer(int Port, std::string DocumentRoot);  // DRESS_WWW_DIR is defined in utilities/CMakeLists.txt
		void RegisterGetFileHandler(std::string URI, std::string FilePath) override;
		void RegisterGetJsonHandler(std::string URI, std::string(*GetJsonObject)()) override;
		void RegisterPostJsonHandler(std::string URI, void(*PostJsonObject)(const std::string & JsonObject)) override;

	private:
		CivetServer _Server;

		using HandlerPtr_t = std::shared_ptr<CivetHandler>;
		static HandlerPtr_t CreateGetFileHandler(std::string URI, std::string FilePath);
		static HandlerPtr_t CreateGetJsonHandler(std::string URI, std::string(*GetJsonObject)());
		static HandlerPtr_t CreatePostJsonHandler(std::string URI, void(*PostJsonObject)(const std::string & JsonObject));
	};

	class GetFileHandler : public CivetHandler {
	public:
		GetFileHandler(std::string FilePath);
		bool handleGet(CivetServer *server, struct mg_connection *conn) override;
	private:
		std::string _FilePath;
	};

	class GetJsonHandler : public CivetHandler {
	public:
		GetJsonHandler(std::string(*GetJsonObject)());
		bool handleGet(CivetServer *server, struct mg_connection *conn) override;
	private:
		std::string(*_GetJsonObject)();
	};

	class PostJsonHandler : public CivetHandler {
	public:
		PostJsonHandler(void(*PostJsonObject)(const std::string & JsonObject));
		bool handlePost(CivetServer *server, struct mg_connection *conn) override;
	private:
		void(*_PostJsonObject)(const std::string & JsonObject);
	};

}

#endif // CIVETWEBSERVER_H
