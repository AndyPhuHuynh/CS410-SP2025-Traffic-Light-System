#include "Devices.h"
#include "Intersection.h"

uint8_t pir_pin_1 = 22;
uint8_t pir_pin_2 = 23;

// Light 1 pins
uint8_t green_pin_1 = 17;
uint8_t yellow_pin_1 = 16;
uint8_t red_pin_1 = 4;

// Light 2 pins
uint8_t green_pin_2 = 21;
uint8_t yellow_pin_2 = 19;
uint8_t red_pin_2 = 18;

Intersection *intersection;

void setup() {
    Serial.begin(9600);
    TrafficLight light1 = TrafficLight(green_pin_1, yellow_pin_1, red_pin_1);
    TrafficLight light2 = TrafficLight(green_pin_2, yellow_pin_2, red_pin_2);

    Sensor pir1 = Sensor(pir_pin_1);
    Sensor pir2 = Sensor(pir_pin_2);
    intersection = new Intersection(light1, light2, pir1, pir2); 
}

void loop() {
    intersection->update();
}
