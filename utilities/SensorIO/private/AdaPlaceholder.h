#ifndef ADAPLACEHOLDER_H
#define ADAPLACEHOLDER_H

#include <thread>
#include <utilities/SensorIO/SensorIO.h>

namespace DRESS {

    class AdaPlaceholder : public SensorIO {
    public:
        AdaPlaceholder(int pin);

        // sensor interface
        float GetHum() override;
        float GetTemp() override;


    private:
        const int _pin;
        float Temp;
        float Hum;

    };

    /*!
     * \brief The <deleted> abstract class ensures that our concrete handlers have a reference to our DHT11
     */


}


#endif // ADAPLACEHOLDER_H
