import 'package:flutter/material.dart'; // import for user interface
import 'dart:async'; // import for timer

// the main() is the start of everything
void main() {
  runApp(const TrafficLightApp()); // call the application
}

// the root of the application
class TrafficLightApp extends StatelessWidget { // TrafficLightApp class
  const TrafficLightApp({super.key}); // TrafficLightApp constructor

  @override // good practice to make sure method overrides superclass
    // Widget will structure and layout to the visual elements
    Widget build(BuildContext context) { // building block
    return MaterialApp(
      debugShowCheckedModeBanner: false, // to remove the debug banner
      title: 'Traffic Lights', // title of the application
      theme: ThemeData( // theme of application
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey), // color
      ),
      home: TrafficModule(title: 'Traffic Lights'),
    );
  }
}

// the homepage of application
class TrafficModule extends StatefulWidget {
  final String title;

  const TrafficModule({super.key, required this.title}); // constructor

  @override // good practice
  // create a state
  State<TrafficModule> createState() => _TrafficModuleState();
}


// the state of the homepage
class _TrafficModuleState extends State<TrafficModule> {
  int _remainingTime = 10; // Initial time in seconds
  Timer? _timer;

  // the track which light is turned on
  int _currentLight = 1; // 1 is red, 2 yellow, 3 green

  @override
  void initState() { // the initial state
    super.initState();
    startTimer();
  }

  void startTimer() { // start the timer and change the color
    // timer period
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) { // time greater than 0
          _remainingTime--; // decrement by 1
        } else {
          changeLight(); // call the function to change the light
        }
      });
    });
    }

  void yellowTimer(int yORn) { // for the case of the yellow timer
    _timer?.cancel(); // cancel current time
    _remainingTime = yORn;
    startTimer();
  }

  // Function to change light color
  void changeLight() {
    setState(() { // the state
      _currentLight = (_currentLight % 3) + 1; // runs from 1 > 2 > 3 > 1 > etc
      if (_currentLight == 2) { // yellow then 5 seconds
        yellowTimer(5); // yes then 5
      } else { // if red or green the 10 seconds
        yellowTimer(10); // not yellow then
      }
    });
  }

  @override
  void dispose() { // function to clean up the widget
    _timer?.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  // the build the traffic light circles
  Widget lightCircle(Color dimColor, Color brightColor, bool isActive) {
    return Container(
      width: 50.0,
      height: 50.0,
      // margin adds space outside the widget's boundary (for neatness)
      margin: const EdgeInsets.symmetric(vertical: 15.0),
      decoration: BoxDecoration(
        // if is Active then brightColor else dimColor
        color: isActive ? brightColor : dimColor, // bright or dull color
        shape: BoxShape.circle,
      ),
    );
  }

  Widget lightedCircle() {
    // basic structure for design
    return Container(
      width: 300,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row (
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Red
          lightCircle(
            Color(0xFF5A0000),
            Colors.red,
            _currentLight == 1,
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
            _currentLight == 3
            ),
          const SizedBox(width: 15),
        ],
    ),
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
              'Time Remaining: $_remainingTime seconds',
                style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),

            // the traffic light module
            Container(
              width: 400, // rectangle width
              height: 220.0, // rectangle height
              color: Colors.grey, // grey rectangle
              child: Row( // to place the traffic lights in a row
                mainAxisAlignment: MainAxisAlignment.center, // alignment
                children: [ // more than one widget
                lightedCircle(), // three lights
                ],
              ),
            ),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}

