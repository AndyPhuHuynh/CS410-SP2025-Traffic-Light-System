#include "Devices.h" // include header like
#include "Intersection.h" // include header file

#include <WiFi.h>
#include <WebSocketsClient.h>

#include <string>

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

// Websocket connections

const char* ssid = "iPhone (122)";
const char* password = "password";

const char* websocket_host = "172.56.219.137";
const uint16_t websocket_port = 8080;             
const char* websocket_path = "";             

WebSocketsClient webSocket;

void setup() {
    Serial.begin(115200);

    // Connect to Wi-Fi
    WiFi.begin(ssid, password);
    Serial.print("Connecting to WiFi");
    while (WiFi.status() != WL_CONNECTED) {
      delay(500);
      Serial.print(".");
    }
    Serial.println(" Connected!");
    Serial.print("IP Address:" );
    Serial.println(WiFi.localIP());
    // WebSocket setup
    webSocket.begin(websocket_host, websocket_port, websocket_path);
    // webSocket.onEvent(webSocketEvent);  // optional: handle incoming messages
    webSocket.setReconnectInterval(5000); // try reconnecting every 5s

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
    std::string stateColor = intersection->getStateJSON();
    webSocket.sendTXT(stateColor.c_str());

    delay(100); // small delay
}
