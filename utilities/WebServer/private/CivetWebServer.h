#ifndef CIVETWEBSERVER_H
#define CIVETWEBSERVER_H

#include <thread>
#include <CivetServer.h>
#include <utilities/WebServer/WebServer.h>

namespace DRESS {

	class CivetWebServer : public WebServer {
	public:
		CivetWebServer(int port);

		// WebServer interface
		bool Start() override;
		bool Stop() override;
		Status GetStatus() override;

		bool GetNewValue();

	private:
		const int _port;
		Status _status;
		bool _value;

		std::thread _Server;
		bool _StopNow;
	};

	/*!
	 * \brief The CivetWebHandler abstract class ensures that our concrete handlers have a reference to our server instance
	 */
	class CivetWebHandler : public CivetHandler {
	public:
		CivetWebHandler() = delete;
		CivetWebHandler(CivetWebServer*);
	protected:
		CivetWebServer* _server;
	};

	class GetIndexHandler : public CivetWebHandler {
	public:
		using CivetWebHandler::CivetWebHandler;
		bool handleGet(CivetServer *server, struct mg_connection *conn) override;
	};

	class GetStatusHandler : public CivetWebHandler {
	public:
		using CivetWebHandler::CivetWebHandler;
		bool handleGet(CivetServer *server, struct mg_connection *conn) override;
	};

	class PostDataHandler : public CivetWebHandler {
	public:
		using CivetWebHandler::CivetWebHandler;
		bool handlePost(CivetServer *server, struct mg_connection *conn) override;
	};

}


#endif // CIVETWEBSERVER_H
