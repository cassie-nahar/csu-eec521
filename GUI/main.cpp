#include <unistd.h> // std::sleep
#include <iostream>
#include <sstream>
#include <utilities/System/System.h>
#include <utilities/Database/Database.h>
#include <utilities/WebServer/WebServer.h>

int main()
{
	auto server = DRESS::WebServer::CreateWebServer(8081, DRESS_WWW_DIR);

	server->RegisterGetFileHandler("/index", "/index.html");

	server->RegisterGetJsonHandler("/status", []() -> std::string {
									   std::ostringstream out;
									   out << "{ \"timestamp\":\"" << DRESS::System::GetCurrentTimeString().c_str() << "\", "
									   << "\"state\":\"" << (DRESS::System::GetNewValue() ? "ON" : "OFF") << "\" }";
									   return out.str();
								   });

	server->RegisterGetJsonHandler("/db", []() -> std::string {
									   auto db = DRESS::Database::Create();
									   return db->Get("SELECT * FROM DHT11");
								   });

	server->RegisterPostJsonHandler("/command", [](const std::string & JsonObject) {
		std::cout << "received: " << JsonObject << std::endl;

		std::string strBuf = JsonObject;
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
	});

	while(true) {
		// TODO: Use boost/signal2 to bind a signal emitted from DRESS::CivetWebServer's handler to break out of this loop
		sleep(1);
	}

}
