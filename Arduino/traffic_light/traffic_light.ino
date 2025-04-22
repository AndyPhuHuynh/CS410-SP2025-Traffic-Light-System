#include "Devices.h" // include header like
#include "Intersection.h" // include header file

// Line sensor pins (car sensors)
uint8_t line_pin_1 = 22;
uint8_t line_pin_2 = 23;

// Pir sensor pins (people sensors)
uint8_t pir_pin_1 = 27;
uint8_t pir_pin_2 = 26;

// Light 1 pins (for one side of intersection)
uint8_t green_pin_1 = 17;
uint8_t yellow_pin_1 = 16;
uint8_t red_pin_1 = 4;

// Light 2 pins (for another side of intersection)
uint8_t green_pin_2 = 21;
uint8_t yellow_pin_2 = 19;
uint8_t red_pin_2 = 18;

Intersection *intersection;

void setup() {
    Serial.begin(9600);
    TrafficLight light1 = TrafficLight(green_pin_1, yellow_pin_1, red_pin_1);
    TrafficLight light2 = TrafficLight(green_pin_2, yellow_pin_2, red_pin_2);

    Sensor line1 = Sensor(line_pin_1);
    Sensor line2 = Sensor(line_pin_2);

    Sensor pir1 = Sensor(pir_pin_1);
    Sensor pir2 = Sensor(pir_pin_2);

    intersection = new Intersection(light1, light2, line1, line2, pir1, pir2); 
}

void loop() {
    webSocket.loop(); // WebSocket communication

    intersection->update();

    // get the state of the lights and send to the server
    String stateColor = intersection->getStateJSON();
    webSocket.sendTXT(stateColor);

    delay(100); // small delay
}
