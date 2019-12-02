#ifndef SYSTEM_H
#define SYSTEM_H

#include <string>

namespace DRESS {

	class System {
	public:
		/*!
		 * \brief GetCurrentTimeString
		 * \return
		 */
		static std::string GetCurrentTimeString();

		/*!
		 * \brief GetNewValue -- Toggles an internal Boolean value and returns the new state.
		 * \return The nely updated value
		 */
		static bool GetNewValue();
	private:
		static bool _value;
	};

}

#endif // SYSTEM_H
