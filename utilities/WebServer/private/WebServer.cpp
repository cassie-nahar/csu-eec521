#include <utilities/WebServer/private/CivetWebServer.h>
#include <utilities/WebServer/WebServer.h>

namespace DRESS {

	WebServer::ptr_t WebServer::CreateWebServer(int Port, std::string DocumentRoot) {
		return ptr_t(new CivetWebServer(Port, DocumentRoot));
	}

}
