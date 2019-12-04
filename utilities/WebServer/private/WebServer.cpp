// File:        DRESS/utilities/WebServer/private/WebServer.cpp
// Authors:     Kevin Rak
// Description: This is the WebServer implementation file. It is responsible for
//              creating a concrete instance of the abstract WebServer class.

#include <utilities/WebServer/private/CivetWebServer.h>
#include <utilities/WebServer/WebServer.h>

namespace DRESS {

	WebServer::ptr_t WebServer::CreateWebServer(int Port, std::string DocumentRoot) {
		return ptr_t(new CivetWebServer(Port, DocumentRoot));
	}

}
