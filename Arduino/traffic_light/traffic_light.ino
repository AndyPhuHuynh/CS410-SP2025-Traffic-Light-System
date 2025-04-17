#include "Devices.h"

uint8_t input_pin = 22;
uint8_t pir_pin = 30;

// Light 1 pins
uint8_t green_pin_1 = 17;
uint8_t yellow_pin_1 = 16;
uint8_t red_pin_1 = 4;

// Light 2 pins
uint8_t green_pin_2 = 21;
uint8_t yellow_pin_2 = 19;
uint8_t red_pin_2 = 18;

TrafficLight *light1;
TrafficLight *light2;

Sensor *pir1;

void setup() {
    Serial.begin(9600);
    light1 = new TrafficLight(green_pin_1, yellow_pin_1, red_pin_1, State::ConstantGreen);
    light2 = new TrafficLight(green_pin_2, yellow_pin_2, red_pin_2, State::GreenToRed);
}

void loop() {
    light1->update();
    light2->update();
}
