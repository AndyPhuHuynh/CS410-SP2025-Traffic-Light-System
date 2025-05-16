import 'package:flutter/material.dart'; // import for user interface
import 'package:web_socket_channel/web_socket_channel.dart'; // to connect to server
import 'dart:convert'; // for json decoding
import 'package:logger/logger.dart'; // to use logging
import 'dart:async'; // for timer


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
  int _remainingTime1 = 10; // Initial time in seconds
  int _remainingTime2 = 0; // Initial time in seconds

  // the track which light is turned on
  int _currentLight = 1; // 1 is red, 2 yellow, 3 green
  int _currentLight2 = 3; // 1 is red, 2 yellow, 3 green

  // the sensors
  // false: no detection, default lights
  // bool lineSensor = false; // no detection, (if detection + red) -> yellow
  // bool pirSensor = false; // no detection, (if detection + green) -> red

  // server will handle which light is which color and the timings will

  var logger = Logger(); // create for debugging

  // if any error in connection then display a message
  void showConnectionError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connection error: Unable to reach server.'), // message
        backgroundColor: Colors.red, // color of background
      ),
    );
  }

  // if any the connection is ended then display a message
  // displaying in similar manner to error message
  void showConnectionClosed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connection closed by server.'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override // good practice
  void initState() { // first state
    // the initial state
    super.initState(); // calls the parent class's initState()
    // communication with server
    _channel = WebSocketChannel.connect( // WebSocket communication
      Uri.parse('ws://172.20.10.9:5000'), // ip address, port
    );

    // timeout timer (if the program is taking too long)
    Timer timeoutTimer = Timer(const Duration(seconds: 5), () {
      logger.e('Connection timeout: No response from server.'); // debugging
      showConnectionError(); // print message
      _channel.sink.close(); // close connection
    });

    _channel.stream.listen( // in the connection listen to data coming in
            (data) { // read add data

              // cancel the timer is receiving data
              if (timeoutTimer.isActive) {
                timeoutTimer.cancel();
              }

              try { // decode the data and hold
                // start by parsing all the data
                Map<String, dynamic> decoded = jsonDecode(data);
                String light1 = decoded["light1"]["color"]; // take section from data
                int time1 = decoded["light1"]["timer"]; // get the first time
                String light2 = decoded["light2"]["color"]; // again
                int time2 = decoded["light2"]["timer"]; // get the second time

                // have both lights and matching times at the end

                setState(() { // make updates to the user interface
                  _remainingTime1 = time1;
                  _remainingTime2 = time2;
                  _currentLight = lightColorNum(light1);
                  _currentLight2 = lightColorNum(light2);
                });
              } catch (e) {
                logger.e('JSON decode error: $e'); // if errors then send message
              }
            },
      onError: (error) { // if errors then send message
        logger.e('WebSocket error: $error');
        showConnectionError();
      },
      // when done close connection (app will always be prepared to read new changes
      // such as when pir or line sensors are triggered
      onDone: () {
        logger.w('WebSocket connection closed.');
        showConnectionClosed();
      },
    );
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

    String getRemainingTime(int time) {
      return time == -1 ? 'N/A' : '$time seconds';
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
                'Time 1 Remaining: ${getRemainingTime(_remainingTime1)}', // text
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                ),
              ),
              Text(
                'Time 2 Remaining: ${getRemainingTime(_remainingTime2)}', // text
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
