#ifndef WEBSERVER_H
#define WEBSERVER_H

#include <cstdint>
#include <memory>

namespace DRESS {

	/*!
	 * \brief The WebServer class
	 * \startuml
	 * class WebServer {
	 *   +bool Start()
	 *   +bool Stop()
	 *   +Status GetStatus()
	 * }
	 * enum Status {
	 *   UNKNOWN
	 *   STOPPED
	 *   RUNNING
	 *   STARTING
	 *   STOPPING
	 *   ERROR
	 * }
	 * WebServer +-- Status
	 * \enduml
	 */
	class WebServer {
	public:
		using ptr_t = std::shared_ptr<WebServer>;

		/*!
		 * \brief The Status enum Lists the possible states the WebServer may take.
		 */
		enum Status : uint8_t {
			UNKNOWN = 0,
			STOPPED = 1,
			RUNNING = 2,
			STARTING = 3,
			STOPPING = 4,
			ERROR = 5
		};

		/*!
		 * \brief CreateWebServer creates a concrete implementation
		 * \param port Optional parameter to specify a non-standard port for the server
		 * \return A shared pointer to the new concrete WebServer
		 */
		static ptr_t CreateWebServer(int port = 80);

		virtual ~WebServer() = default;

		/*!
		 * \brief Start
		 * \return True if the server was successfully started. Otherwise false.
		 */
		virtual bool Start() = 0;

		/*!
		 * \brief Stop
		 * \return True if the server was successfully stopped. Otherwise false.
		 */
		virtual bool Stop() = 0;

		/*!
		 * \brief GetStatus
		 * \return A Status value which indicates the \c WebServer's current status.
		 */
		virtual Status GetStatus() = 0;

	};

}

#endif // WEBSERVER_H
