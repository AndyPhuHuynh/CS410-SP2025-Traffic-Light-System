import 'package:flutter/material.dart'; // import for user interface
import 'package:web_socket_channel/web_socket_channel.dart'; // to connect to server
import 'dart:convert'; // for json decoding
import 'package:logger/logger.dart';


void main() { // the main() is the start of everything
  runApp(const TrafficLightApp()); // call the application
}

// the root of the application
class TrafficLightApp extends StatelessWidget { // TrafficLightApp class
  const TrafficLightApp({super.key}); // TrafficLightApp constructor

  @override // good practice to make sure method overrides superclass
    // Widget will structure and layout to the visual elements
    Widget build(BuildContext context) { // building block
    // MaterialApp sets up the application's structure
     return MaterialApp( // the root widget for the application
      debugShowCheckedModeBanner: false, // to remove the debug banner
      title: 'Traffic Lights', // title of the application
      theme: ThemeData( // theme of application
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey), // color
      ),
      // home property defines the application's home page
      home: TrafficModule(title: 'Traffic Lights'),
    );
  }
}

// the homepage of application
class TrafficModule extends StatefulWidget {
  final String title; // the title of application

  const TrafficModule({super.key, required this.title}); // constructor

  @override // good practice
  // create a state
  State<TrafficModule> createState() => _TrafficModuleState();
}

// the state of the homepage
class _TrafficModuleState extends State<TrafficModule> {
  // variable _channel (type: WebSocketChannel)
  late WebSocketChannel _channel; // initialized later
  int _remainingTime = 10; // Initial time in seconds

  // the track which light is turned on
  int _currentLight = 1; // 1 is red, 2 yellow, 3 green

  int _currentLight2 = 3; // 1 is red, 2 yellow, 3 green

  // the sensors
  // false: no detection, default lights
  // bool lineSensor = false; // no detection, (if detection + red) -> yellow
  // bool pirSensor = false; // no detection, (if detection + green) -> red

  // add functions if active
  // add functions to send to output

  var logger = Logger();

  @override
  void initState() {
    // the initial state
    super.initState(); // calls the parent class's initState()
    // communication with server
    _channel = WebSocketChannel.connect( // WebSocket communication
      Uri.parse('ws://172.22.144.99:3000'), // ip address, port
    );
    _channel.stream.listen((data) { // read add data
      try {
        final decoded = jsonDecode(data); // decode the data and hold
        String light1 = decoded["light1"]; // take section from data
        String light2 = decoded["light2"]; // again
        int time = decoded["countdown"]; // get the countdown

        setState(() {
          _remainingTime = time;
          _currentLight = lightColorNum(light1);
          _currentLight2 = lightColorNum(light2);
        });
      } catch (e) {
        logger.e("Error parsing data: $e");
      }
    });
  }

  int lightColorNum(String color) {
      switch (color) {
        case "red": return 1;
        case "yellow": return 2;
        case "green": return 3;
        default: return 1;
      }
    }

    @override
    void dispose() {
      // function to clean up the widget
      _channel.sink.close();
      super.dispose(); // used to clean up, cancel timer
    }

    // the build the traffic light circles
    Widget lightCircle(Color dimColor, Color brightColor, bool isActive) {
      return Container(
        width: 100.0, // width
        height: 100.0, // height
        // margin adds space outside the widget's boundary (for neatness)
        margin: const EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
          // if is Active then brightColor else dimColor
          color: isActive ? brightColor : dimColor, // bright or dull color
          shape: BoxShape.circle, // circle lights
        ),
      );
    }

    Widget lightedCircle() {
      // basic structure for design
      return Stack(
          children: [
            Container( // hold the three lights together
              width: 400,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey, // color
                borderRadius: BorderRadius.circular(12), // border
                // to add dept
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row( // place the three lights in a row (next to each other)
                mainAxisAlignment: MainAxisAlignment.center,
                // center the three lights
                children: [
                  // Red
                  lightCircle( // call the previously made widget
                    Color(0xFF5A0000), // dull red (off)
                    Colors.red, // brighter red (on)
                    _currentLight == 1, // which index that would signal on
                  ),
                  const SizedBox(width: 15),
                  // Yellow
                  lightCircle(
                    Color(0xFFA68B00),
                    Colors.yellow,
                    _currentLight == 2,
                  ),
                  const SizedBox(width: 15),
                  // Green
                  lightCircle(
                    Color(0xFF1B5E20),
                    Colors.green,
                    _currentLight == 3,
                  ),
                  const SizedBox(width: 15), // to prevent overlapping of lights
                ],
              ),
            ),
          ]
      );
    }

    Widget lightedCircle2() {
      // basic structure for design
      return Stack(
          children: [
            Container( // hold the three lights together
              width: 400,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey, // color
                borderRadius: BorderRadius.circular(12), // border
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row( // place the three lights in a row (next to each other)
                mainAxisAlignment: MainAxisAlignment.center,
                // center the three lights
                children: [
                  // Red
                  lightCircle( // call the previously made widget
                    Color(0xFF5A0000), // dull red (off)
                    Colors.red, // brighter red (on)
                    _currentLight2 == 1, // which index that would signal on
                  ),
                  const SizedBox(width: 15),
                  // Yellow
                  lightCircle(
                    Color(0xFFA68B00),
                    Colors.yellow,
                    _currentLight2 == 2,
                  ),
                  const SizedBox(width: 15),
                  // Green
                  lightCircle(
                    Color(0xFF1B5E20),
                    Colors.green,
                    _currentLight2 == 3,
                  ),
                  const SizedBox(width: 15), // to prevent overlapping of lights
                ],
              ),
            ),
          ]
      );
    }

    @override
    Widget build(BuildContext context) {
      // basic structure
      return Scaffold( // gives structural elements such as appBar, body, more...
        appBar: AppBar(title: Text(widget.title)), // title of application
        body: Center( // center everything
          child: Column( // place one on top of another
            mainAxisAlignment: MainAxisAlignment.start, // alignment
            children: [ // more than one widget
              const SizedBox(height: 30), // display the time
              Text(
                'Time Remaining: $_remainingTime seconds', // text
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                ),
              ),
              const SizedBox(height: 20),
              // Traffic light 1
              lightedCircle(),
              const SizedBox(height: 20),
              // Traffic light 2
              lightedCircle2(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    }
  }
