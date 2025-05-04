# traffic_light_system
This is a final project for the class CS410 Intro to Software Engineering at UMass Boston

To run and connect everything to the server:
- The arduino, device running the server, and the device running the flutter app have to be on the same network
- Run the server via the command "node ./server" in the project directory. You have to have node js installed
- After running the server, it should display its ip address and port in the terminal

- Open the file Arduino/traffic_light.ino
    - Change the wifi ssid and password to your wifi's name and password
    - Change the IP and port to the one displayed in the terminal from earlier

- Open the file lib.main.dart
    - Under the initState function, change the ip address and port to the one displayed in the terminal by the server

- Compile and upload the arduino code. This should display it's ip in the serial monitor. 
- On the device hosting the server, ping this ip by running the command "ping {ip}"
