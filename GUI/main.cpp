#include <unistd.h> // std::sleep
#include <utilities/WebServer/WebServer.h>

int main()
{
	auto server = DRESS::WebServer::CreateWebServer(8081);
	server->Start();
	while(true) {
		// TODO: Use boost/signal2 to bind a signal emitted from DRESS::CivetWebServer's handler to break out of this loop
		sleep(1);
	}

}
