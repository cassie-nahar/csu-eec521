#ifndef SYSTEM_H
#define SYSTEM_H

#include <string>

namespace DRESS {

	class System {
	public:
		static std::string GetCurrentTimeString();
		static bool GetNewValue();
	private:
		static bool _value;
	};

}

#endif // SYSTEM_H
