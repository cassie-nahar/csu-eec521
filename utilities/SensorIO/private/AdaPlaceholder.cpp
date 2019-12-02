#include <string.h> // memset
#include <iostream> // std::cout
#include <unistd.h> // std::sleep

#include <utilities/System/System.h>
#include <utilities/SensorIO/private/AdaPlaceholder.h>

using namespace DRESS;

AdaPlaceholder::AdaPlaceholder(int pin) : _pin(pin) {}

float AdaPlaceholder::GetHum() {

    Hum = rand() % 100;
    return Hum;
}

float AdaPlaceholder::GetTemp() {
    Temp = rand() % 120;
    return Temp;
}
