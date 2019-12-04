// File:        DRESS/GUI/main.cpp
// Authors:     Kevin Rak
// Description: This is the GUI application entrypoint. It is responsible for defining
//              the server's GET and POST handlers and their behavior.

#include <unistd.h> // std::sleep
#include <iostream>
#include <sstream>

#include <utilities/Database/Database.h>
#include <utilities/WebServer/WebServer.h>

int main()
{
	auto server = DRESS::WebServer::CreateWebServer(8081, DRESS_WWW_DIR);

	server->RegisterGetFileHandler("/index", "/index.html");

	server->RegisterGetJsonHandler("/db", []() -> std::string {
									   auto db = DRESS::Database::Create("DRESS_ATMOSPHERIC", "10.254.254.100");
									   return db->Get("SELECT sensor_number, datetime, temperature, humidity FROM DHT11 WHERE DATE(datetime) = CURDATE() AND TIME(datetime) > DATE_SUB(CURTIME(), INTERVAL 30 MINUTE) ORDER BY datetime ASC");
								   });

	while(true) {
		// TODO: Use boost/signal2 or similar to bind a signal emitted from DRESS::WebServer's handler to break out of this loop
		sleep(1);
	}

}
