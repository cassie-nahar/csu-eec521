#include <string.h> // memset
#include <iostream> // std::cout
#include <unistd.h> // std::sleep

#include <utilities/System/System.h>
#include <utilities/WebServer/private/CivetWebServer.h>

using namespace DRESS;

CivetWebServer::CivetWebServer(int port) : _port(port) {}

bool CivetWebServer::Start() {
	_StopNow = false;
	_Server = std::thread([&]() {

		std::vector<std::string> cpp_options = {
			"document_root",
			DRESS_WWW_DIR, // Defined in utilities/CMakeLists.txt
			"listening_ports",
			std::to_string(_port)
		};

		CivetServer server(cpp_options);

		GetIndexHandler h_get_index(this);
		server.addHandler("/index", h_get_index);

		GetStatusHandler h_get_status(this);
		server.addHandler("/status", h_get_status);

		PostDataHandler h_post_command(this);
		server.addHandler("/command", h_post_command);

		while (!_StopNow) {
			sleep(1);
		}

	});

	std::cout << "Run index at http://localhost:" << _port << "/index" << std::endl;

	_status = Status::RUNNING;
	return true;
}

bool CivetWebServer::Stop() {
	_StopNow = true;
	_Server.join();
	_status = Status::STOPPED;
	return false; // TODO: Implement this function
}

WebServer::Status CivetWebServer::GetStatus() {
	return _status;
}

bool CivetWebServer::GetNewValue()
{
	_value = !_value;
	return _value;
}

bool GetIndexHandler::handleGet(CivetServer *server, mg_connection *conn) {
	(void)server; // Unused variable. Silence compiler warning.

	mg_send_file(conn, (DRESS_WWW_DIR + std::string("/index.html")).c_str());
	return true;
}

bool GetStatusHandler::handleGet(CivetServer *server, mg_connection *conn) {
	(void)server; // Unused variable. Silence compiler warning.

	mg_printf(conn,
			  "HTTP/1.1 200 OK\r\n"
			  "Cache: no-cache\r\n"
			  "Content-Type: application/x-javascript\r\n\r\n");
	mg_printf(conn, "{ \"timestamp\":\"%s\", \"state\":\"%s\" }",
			  System::GetCurrentTimeString().c_str(),
			  _server->GetNewValue()
				? "ON"
				: "OFF");

	return true;
}

bool PostDataHandler::handlePost(CivetServer *server, mg_connection *conn) {
	(void)server; // Unused variable. Silence compiler warning.

	/* Handler may access the request info using mg_get_request_info */
	const struct mg_request_info *req_info = mg_get_request_info(conn);
	size_t rlen, wlen;
	size_t nlen = 0;
	size_t tlen = static_cast<size_t>(req_info->content_length);
	char buf[1024];

	memset(buf, 0x00, sizeof(buf));

	mg_printf(conn,
			  "HTTP/1.1 200 OK\r\nContent-Type: "
			  "text/html\r\nConnection: close\r\n\r\n");

	mg_printf(conn, "<html><body>\n");
//                mg_printf(conn, "<h2>This is the Foo POST handler!!!</h2>\n");
//                mg_printf(conn,
//                          "<p>The request was:<br><pre>%s %s HTTP/%s</pre></p>\n",
//                          req_info->request_method,
//                          req_info->request_uri,
//                          req_info->http_version);
//                mg_printf(conn, "<p>Content Length: %li</p>\n", (long)tlen);
	mg_printf(conn, "<pre>\n");

	while (nlen < tlen) {
		rlen = tlen - nlen;
		if (rlen > sizeof(buf)) {
			rlen = sizeof(buf);
		}
		rlen = static_cast<size_t>(mg_read(conn, buf, rlen));
		if (rlen <= 0) {
			break;
		}
		wlen = static_cast<size_t>(mg_write(conn, buf, rlen));
		if (wlen != rlen) {
			break;
		}
		nlen += wlen;
	}

	mg_printf(conn, "\n</pre>\n");
	mg_printf(conn, "</body></html>\n");

	std::cout << "received: " << buf << std::endl;

	std::string strBuf = buf;
	strBuf = strBuf.substr(strBuf.find("=") + 1);
//	bool cmd_state;
	if(strBuf == "ON") {
//		cmd_state = true;
		std::cout << "Sending ON command" << std::endl;
	}
	else {
//		cmd_state = false;
		std::cout << "Sending OFF command" << std::endl;
	}
//	std::shared_ptr<command> test(new command);
//	test->m_cmd = CMD::STATE;
//	test->m_val = cmd_state;
//	publisher.Publish(test->Serialize());
	return true;
}

CivetWebHandler::CivetWebHandler(CivetWebServer * server) :
	CivetHandler(),
	_server(server) {}
