#include <string.h> // memset
#include <iostream> // std::cout
#include <unistd.h> // std::sleep

#include <utilities/WebServer/private/CivetWebServer.h>

namespace DRESS {

	CivetWebServer::CivetWebServer(int Port, std::string DocumentRoot) : _Server({
													   "document_root", DocumentRoot,
													   "listening_ports", std::to_string(Port) }) {
		std::cout << "Running on http://localhost:" << Port << std::endl << std::flush;
	}

	void CivetWebServer::RegisterGetFileHandler(std::string URI, std::string FilePath) {
		_Server.addHandler(URI, new GetFileHandler(FilePath)); // TODO: Fix this memory leak
	}

	GetFileHandler::GetFileHandler(std::string FilePath) : _FilePath(FilePath) {}

	bool GetFileHandler::handleGet(CivetServer *server, mg_connection *conn) {
		(void)server; // Unused variable. Silence compiler warning.
		mg_send_file(conn, _FilePath.c_str());
		return true;
	}

	void CivetWebServer::RegisterGetJsonHandler(std::string URI, std::string (*GetJsonObject)()) {
		_Server.addHandler(URI, new GetJsonHandler(GetJsonObject)); // TODO: Fix this memory leak
	}

	GetJsonHandler::GetJsonHandler(std::string (*GetJsonObject)()) : _GetJsonObject(GetJsonObject) {}

	bool GetJsonHandler::handleGet(CivetServer *server, mg_connection *conn) {
		(void)server; // Unused variable. Silence compiler warning.
		mg_printf(conn,
				  "HTTP/1.1 200 OK\r\n"
				  "Cache: no-cache\r\n"
				  "Content-Type: application/json\r\n"
				  "\r\n"
				  "%s", _GetJsonObject().c_str());
		return true;
	}

	void CivetWebServer::RegisterPostJsonHandler(std::string URI, void (*PostJsonObject)(const std::string &)) {
		_Server.addHandler(URI, new PostJsonHandler(PostJsonObject)); // TODO: Fix this memory leak
	}

	PostJsonHandler::PostJsonHandler(void (*PostJsonObject)(const std::string &)) : _PostJsonObject(PostJsonObject) {}

	bool PostJsonHandler::handlePost(CivetServer *server, mg_connection *conn) {
		(void)server; // Unused variable. Silence compiler warning.

		/* Handler may access the request info using mg_get_request_info */
		const struct mg_request_info *req_info = mg_get_request_info(conn);
		size_t rlen, wlen;
		size_t nlen = 0;
		size_t tlen = static_cast<size_t>(req_info->content_length);
		char buf[1024];

		memset(buf, 0x00, sizeof(buf));

		mg_printf(conn,
				  "HTTP/1.1 200 OK\r\n"
				  "Content-Type: "
				  "text/html\r\n"
				  "Connection: close\r\n"
				  "\r\n"
				  "<html><body>\n"
				  "<pre>\n");

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

		_PostJsonObject(buf);

		return true;
	}

}
