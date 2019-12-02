#include <iostream>
#include <unistd.h> // std::sleep
#include <utilities/SensorIO/SensorIO.h>

int main()
{
    auto IO = DRESS::SensorIO::CreateSensorIO();

    for(int i=0;i<10;i++)
    {
        float t = IO->GetTemp();
        float h = IO->GetHum();
        std::cout << i << ": Temp = " << t << ", Humid = " << h << "\n";
        sleep(1);
    }

    std::cout << "\n";


    return 0;
}
