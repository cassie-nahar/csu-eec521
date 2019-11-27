#include <utilities/WebServer/private/CivetWebServer.h>
#include <utilities/WebServer/WebServer.h>

namespace DRESS {

	WebServer::ptr_t WebServer::CreateWebServer(int port) {
		(void)port; // Disable unused-variable warning
		return ptr_t(new CivetWebServer(port));
	}

}
