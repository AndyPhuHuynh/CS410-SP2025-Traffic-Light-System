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

const char* ssid = "UMB-Guest";
const char* password = "UMBIT@YourServiceDesk";

const char* websocket_host = "158.121.180.60";
const uint16_t websocket_port = 3000;             
const char* websocket_path = "ws";             

WebSocketsClient webSocket;

void webSocketEvent(WStype_t type, uint8_t *payload, size_t length) {
    switch(type) {
        case WStype_DISCONNECTED:
            Serial.println("Disconnected from WebSocket.");
            break;
        case WStype_CONNECTED:
            Serial.println("Connected to WebSocket.");
            break;
        case WStype_TEXT:
            Serial.printf("Received message: %s\n", payload);
            break;
        case WStype_ERROR:
            Serial.println("WebSocket error.");
            break;
        default:
            break;
    }
};

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
    webSocket.onEvent(webSocketEvent);  // optional: handle incoming messages
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
    webSocket.loop();
    intersection->update();

    if (webSocket.isConnected()) {
        std::string state = intersection->getStateJSON();
        webSocket.sendTXT(state.c_str());
    } else {
        // Serial.println("WebSocket not connected. Attempting to reconnect...");
    }

    delay(100); // small delay (100ms)
}
