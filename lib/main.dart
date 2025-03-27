import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const TrafficLightApp());
}

class TrafficLightApp extends StatelessWidget {
  const TrafficLightApp({super.key});

  @override
    Widget build(BuildContext context) {
      Widget lightRectangle = Container(
        width: 400.0,
        height: 200.0,
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
        ),
      );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.grey,
        home: Scaffold(
          body: Center(
              child: Stack(
                  children: <Widget>[
                    lightRectangle,
                    Positioned(
                      left: 40.0,
                      top: 50.0,
                      child: Container (
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Color(0xFF5A0000),
                            shape: BoxShape.circle,
                          )
                      ),
                    ),
                    Positioned(
                      left: 150.0,
                      top: 50.0,
                      child: Container (
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Color(0xFF8B6A00),
                            shape: BoxShape.circle,
                          )
                      ),
                    ),
                    Positioned(
                      left: 260.0,
                      top: 50.0,
                      child: Container (
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Color(0xFF00FF00),
                            shape: BoxShape.circle,
                          )
                      ),
                    ),
                  ]
              )
          )
      )
    );
  }
}

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  int _remainingTime = 10; // Initial time in seconds
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          timer.cancel(); // Stop the timer when it reaches 0
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Light Change Time:')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Time remaining: $_remainingTime seconds',
              style: const TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _remainingTime = 10; // Reset timer
                });
                startTimer();
              },
              child: const Text('Restart'),
            ),
          ],
        ),
      ),
    );
  }
}