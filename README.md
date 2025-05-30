# Traffic Light System
This is the final project for the class CS410 Intro to Software Engineering at UMass Boston

It simulates a traffic light algorithm at a two way intersection using an esp32 and traffic light modules. The current status of the traffic lights can be tracked on a mobile app.

The esp32 and related hardware are run using the arduino ide, the mobile app is built using the Flutter framework, and the two communicate with each via websockets hosted on Node.js server.

# 1. Prerequisites

1. Have [Flutter](https://docs.flutter.dev/get-started/install) installed 
2. Have [Node.js](https://nodejs.org/en) installed
3. Have the [Arduino IDE](https://www.arduino.cc/en/software/) installed along with the ESP32 plugin
4. Have the required hardware:
    - ESP32
    - Two [Keyestudio Traffic Light Modules](https://wiki.keyestudio.com/KS0310_Keyestudio_Traffic_Light_Module_(Black_and_Eco-friendly))
    - Two [Keyestudio Line Tracking Sensors](https://wiki.keyestudio.com/Ks0050_keyestudio_Line_Tracking_Sensor)
    - Two [Keyestudio PIR Motion Sensors](https://wiki.keyestudio.com/Ks0052_keyestudio_PIR_Motion_Sensor)

# 2. Setting up the Hardware
Connect your esp32 to the breadboard. The pins for each of the devices should be set up like so:

Traffic Light 1:
- Green pin = 17
- Yellow pin = 16
- Red pin = 4

Traffic Light 2:
- Green pin = 21
- Yellow pin = 19
- Red pin = 18

Line Sensors:
- Sensor 1 = 22
- Sensor 2 = 23

Pir Sensors:
- Sensor 1 = 27
- Sensor 2 = 26

The layout for the intersection is shown below:

![Intersection layout](/3D%20Road%20Layout.png)

# 3. Setting up the Network
In order for the arduino, server, and mobile app to all communicate with each other, the devices hosting each service should be on the same wifi network.

Open the file Arduino/traffic_light.ino and change the wifi ssid and password to your wifi's name and password.

# 4. Setting up the Server
To start up the server, go to the root directory of the project and run the command:

> node ./server

After the server starts up, it should log its Websocket URL in the terminal.

Open the file Arduino/traffic_light.ino change values of the ip and port variables at the top of the file to the one displayed in the terminal from earlier.

Open the file lib.main.dart. Under the initState function, change the url to the one displayed in the terminal earlier by the server.

Using the Arduino IDE, compile and upload the arduino code. This should display it's ip in the serial monitor. On the device hosting the server, ping this ip by running the command:

> ping {ip}

# 5. Running the mobile App
In the root directory of the project, run the command:

> flutter run

This should start up the mobile app. After this, everything should be working and connected together. Changes in the traffic lights will be reflected on the mobile app in real-time.

For related code documentation [click here](/documentation.md)