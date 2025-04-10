import 'package:flutter/material.dart'; // import for user interface
import 'dart:async'; // import for timer

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
  int _remainingTime = 10; // Initial time in seconds
  // declare Timer class which can be null or active timer
  Timer? _timer;


  // the track which light is turned on
  int _currentLight = 1; // 1 is red, 2 yellow, 3 green

  int _remainingTime2 = 15; // Initial time in seconds
  // declare Timer class which can be null or active timer
  Timer? _timer2;

  int _currentLight2 = 1; // 1 is red, 2 yellow, 3 green

  // the sensors
  // false: no detection, default lights
  // bool lineSensor = false; // no detection, (if detection + red) -> yellow
  // bool pirSensor = false; // no detection, (if detection + green) -> red

  // add functions if active
  // add functions to send to output

  @override
  void initState() {
    // the initial state
    super.initState(); // calls the parent class's initState()
    startTimer(); // call the timer start function
    startTimer2();
  }

  void startTimer() {
    // start the timer and change the color
    // timer period of 1 second (constantly 1 second periods)
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // the state of the lights depending on the time
      setState(() {
        if (_remainingTime > 0) { // time greater than 0
          _remainingTime--; // decrement by 1
        } else {
          // when 0 change the light
          changeLight(); // call the function to change the light
        }
      });
    });
  }

    void startTimer2() {
      // start the timer and change the color
      // timer period of 1 second (constantly 1 second periods)
      _timer2 = Timer.periodic(const Duration(seconds: 1), (timer2) {
        // the state of the lights depending on the time
        setState(() {
          if (_remainingTime2 > 0) { // time greater than 0
            _remainingTime2--; // decrement by 1
          } else {
            // when 0 change the light
            changeLight2(); // call the function to change the light
          }
        });
      });
  }

    void yellowTimer(int yORn) {
      // for the case of the yellow timer
      _timer?.cancel(); // cancel current time
      _remainingTime = yORn; // set the new time depending on previous color
      startTimer(); // call the timer function again
    }

    void yellowTimer2(int yORn) {
      // for the case of the yellow timer
      _timer2?.cancel(); // cancel current time
      _remainingTime2 = yORn; // set the new time depending on previous color
      startTimer2(); // call the timer function again
    }

    // Function to change light color
    void changeLight() {
      setState(() { // the state
        _currentLight =
            (_currentLight % 3) + 1; // runs from 1 > 2 > 3 > 1 > etc
        if (_currentLight == 2) { // yellow then 5 seconds
          yellowTimer(5); // yes then 5
        } else { // if red or green the 10 seconds
          yellowTimer(10); // not yellow then
        }
      });
    }

    void changeLight2() {
      setState(() { // the state
        _currentLight2 =
            (_currentLight2 % 3) + 1; // runs from 1 > 2 > 3 > 1 > etc
        if (_currentLight2 == 2) { // yellow then 5 seconds
          yellowTimer2(5); // yes then 5
        } else { // if red or green the 10 seconds
          yellowTimer2(10); // not yellow then
        }
      });
    }

    @override
    void dispose() {
      // function to clean up the widget
      _timer?.cancel(); // Cancel the timer to prevent memory leaks
      _timer2?.cancel();
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

  Widget lightCircle2(Color dimColor, Color brightColor, bool isActive) {
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
              ),
              child: Row( // place the three lights in a row (next to each other)
                mainAxisAlignment: MainAxisAlignment.center,
                // center the three lights
                children: [
                  // Red
                  lightCircle2( // call the previously made widget
                    Color(0xFF5A0000), // dull red (off)
                    Colors.red, // brighter red (on)
                    _currentLight2 == 1, // which index that would signal on
                  ),
                  const SizedBox(width: 15),
                  // Yellow
                  lightCircle2(
                    Color(0xFFA68B00),
                    Colors.yellow,
                    _currentLight2 == 2,
                  ),
                  const SizedBox(width: 15),
                  // Green
                  lightCircle2(
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
              const SizedBox(height: 20), // display the time
              Text(
                'Time Remaining: $_remainingTime seconds', // text
                style: const TextStyle(fontSize: 20), // font
              ),
              const SizedBox(height: 20), // prevent overlapping

              // the traffic light module
              Container(
                width: 400, // rectangle width
                height: 120.0, // rectangle height
                color: Colors.grey, // grey rectangle
                child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          lightedCircle(),
                        ],
                      ),
                    ]
                ),
              ),
              Text(
                'Time Remaining: $_remainingTime2 seconds', // text
                style: const TextStyle(fontSize: 20), // font
              ),
              const SizedBox(height: 20), // prevent overlapping

              // the traffic light module
              Container(
                width: 400, // rectangle width
                height: 120.0, // rectangle height
                color: Colors.grey, // grey rectangle
                child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          lightedCircle2(),
                        ],
                      ),
                    ]
                ),
              ),
              const SizedBox(height: 20), // prevent overlapping

            ],
          ),
        ),
      );
    }
  }
