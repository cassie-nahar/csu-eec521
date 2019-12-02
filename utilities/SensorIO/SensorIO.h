#ifndef SENSORIO_H
#define SENSORIO_H

#include <cstdint>
#include <memory>

namespace DRESS {

    /*!
     * \brief The SensorIO
     * \startuml
     * class SensorIO {
     *   +float GetTemp()
     *   +float GetHum()
     * }
     * \enduml
     */
    class SensorIO {
    public:
        using ptr_t = std::shared_ptr<SensorIO>;

        /*!
         * \brief CreateSensorIO creates a concrete implementation
         * \param port Optional parameter to specify a non-standard pin for the DHT (default is 4)
         * \return A shared pointer to the new concrete WebServer
         */
        static ptr_t CreateSensorIO(int pin = 4);

        virtual ~SensorIO() = default;

        /*!
         * \brief GetTemp
         * \return temperature value of the attached sensor
         */
        virtual float GetTemp() = 0;

        /*!
         * \brief GetHum
         * \return humidity value of the attached sensor
         */
        virtual float GetHum() = 0;

    };

}

#endif // SENSORIO_H
