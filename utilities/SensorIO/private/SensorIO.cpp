#include <utilities/SensorIO/private/AdaPlaceholder.h>
#include <utilities/SensorIO/SensorIO.h>

namespace DRESS {

    SensorIO::ptr_t SensorIO::CreateSensorIO(int pin) {
        (void)pin; // Disable unused-variable warning
        return ptr_t(new AdaPlaceholder(pin));
    }

}
