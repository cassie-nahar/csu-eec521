#include <chrono>	// GetCurrentTimeString -> std::chrono
#include <iomanip>	// GetCurrentTimeString -> std::put_time
#include <sstream>

#include <utilities/System/System.h>

namespace DRESS {

	std::string System::GetCurrentTimeString() {
		std::chrono::system_clock::time_point now = std::chrono::system_clock::now();
		std::time_t now_c = std::chrono::system_clock::to_time_t(now - std::chrono::hours(24));

		std::stringstream is;
		is << std::put_time(std::localtime(&now_c), "%F %T");
		return is.str();
	}

	bool System::_value;

	bool System::GetNewValue() {
		_value = !_value;
		return _value;
	}

}
