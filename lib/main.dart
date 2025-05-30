/// \file
/// \brief A Flutter application that displays two traffic light modules based on server information.
/// \author Nicoly, Andy, Ken, Yonathan, Zhaomei
/// \date 2025

import 'package:flutter/material.dart'; ///< For user interface
import 'package:web_socket_channel/web_socket_channel.dart'; ///< For WebSocket communication
import 'dart:convert'; ///< For JSON decoding
import 'package:logger/logger.dart'; ///< For logging
import 'dart:async'; ///< For timers

/// \fn void main()
/// \brief Main entry point of the application.
void main() {
  runApp(const TrafficLightApp());
}

/// \class TrafficLightApp
/// \brief Stateless widget that builds the main app structure.
class TrafficLightApp extends StatelessWidget {
  /// \brief Constructor.
  const TrafficLightApp({super.key});

  /// \fn Widget build(BuildContext context)
  /// \brief Builds the main MaterialApp widget.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Traffic Lights',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      ),
      home: const TrafficModule(title: 'Traffic Lights'),
    );
  }
}

/// \class TrafficModule
/// \brief Main screen widget that hosts two traffic light modules.
class TrafficModule extends StatefulWidget {
  /// \brief App title.
  final String title;

  /// \brief Constructor.
  const TrafficModule({super.key, required this.title});

  /// \fn State<TrafficModule> createState()
  /// \brief Creates the mutable state for this widget.
  @override
  State<TrafficModule> createState() => _TrafficModuleState();
}

/// \class _TrafficModuleState
/// \brief Manages the state and UI of the TrafficModule.
class _TrafficModuleState extends State<TrafficModule> {
  late WebSocketChannel _channel; ///< WebSocket channel for server communication.
  final Logger logger = Logger(); ///< Logger instance.

  int _remainingTime1 = 10; ///< Time left for light 1.
  int _remainingTime2 = 0; ///< Time left for light 2.

  int _currentLight = 1; ///< 1 = red, 2 = yellow, 3 = green for light 1.
  int _currentLight2 = 3; ///< 1 = red, 2 = yellow, 3 = green for light 2.

  /// \fn void showConnectionError()
  /// \brief Displays a red error message when the connection fails.
  void showConnectionError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connection error: Unable to reach server.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// \fn void showConnectionClosed()
  /// \brief Displays an orange message when the server connection is closed.
  void showConnectionClosed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connection closed by server.'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  /// \fn void initState()
  /// \brief Initializes WebSocket connection and listens for traffic data.
  @override
  void initState() {
    super.initState();

    _channel = WebSocketChannel.connect(
      Uri.parse('ws://172.20.10.9:5000'),
    );

    // Timeout if no server response
    Timer timeoutTimer = Timer(const Duration(seconds: 5), () {
      logger.e('Connection timeout: No response from server.');
      showConnectionError();
      _channel.sink.close();
    });

    _channel.stream.listen(
          (data) {
        if (timeoutTimer.isActive) {
          timeoutTimer.cancel();
        }

        try {
          Map<String, dynamic> decoded = jsonDecode(data);
          String light1 = decoded["light1"]["color"];
          int time1 = decoded["light1"]["timer"];
          String light2 = decoded["light2"]["color"];
          int time2 = decoded["light2"]["timer"];

          setState(() {
            _remainingTime1 = time1;
            _remainingTime2 = time2;
            _currentLight = lightColorNum(light1);
            _currentLight2 = lightColorNum(light2);
          });
        } catch (e) {
          logger.e('JSON decode error: $e');
        }
      },
      onError: (error) {
        logger.e('WebSocket error: $error');
        showConnectionError();
      },
      onDone: () {
        logger.w('WebSocket connection closed.');
        showConnectionClosed();
      },
    );
  }

  /// \fn int lightColorNum(String color)
  /// \brief Converts a color name to an integer value.
  /// \param color A string representing the light color ("red", "yellow", "green").
  /// \return Corresponding integer: 1 for red, 2 for yellow, 3 for green.
  int lightColorNum(String color) {
    switch (color) {
      case "red":
        return 1;
      case "yellow":
        return 2;
      case "green":
        return 3;
      default:
        return 1;
    }
  }

  /// \fn void dispose()
  /// \brief Closes the WebSocket channel and performs cleanup.
  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  /// \fn Widget lightCircle(Color dimColor, Color brightColor, bool isActive)
  /// \brief Builds a single colored traffic light circle.
  Widget lightCircle(Color dimColor, Color brightColor, bool isActive) {
    return Container(
      width: 100.0,
      height: 100.0,
      margin: const EdgeInsets.symmetric(vertical: 15.0),
      decoration: BoxDecoration(
        color: isActive ? brightColor : dimColor,
        shape: BoxShape.circle,
      ),
    );
  }

  /// \fn Widget lightedCircle()
  /// \brief Builds the first traffic light.
  Widget lightedCircle() {
    return trafficLightWidget(_currentLight);
  }

  /// \fn Widget lightedCircle2()
  /// \brief Builds the second traffic light.
  Widget lightedCircle2() {
    return trafficLightWidget(_currentLight2);
  }

  /// \fn Widget trafficLightWidget(int currentLight)
  /// \brief Builds a horizontal traffic light widget.
  /// \param currentLight The current active light (1 = red, 2 = yellow, 3 = green).
  Widget trafficLightWidget(int currentLight) {
    return Container(
      width: 400,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          lightCircle(const Color(0xFF5A0000), Colors.red, currentLight == 1),
          const SizedBox(width: 15),
          lightCircle(const Color(0xFFA68B00), Colors.yellow, currentLight == 2),
          const SizedBox(width: 15),
          lightCircle(const Color(0xFF1B5E20), Colors.green, currentLight == 3),
        ],
      ),
    );
  }

  /// \fn String getRemainingTime(int time)
  /// \brief Formats the remaining time for display.
  /// \param time Remaining time in seconds.
  /// \return A formatted string for display.
  String getRemainingTime(int time) {
    return time == -1 ? 'N/A' : '$time seconds';
  }

  /// \fn Widget build(BuildContext context)
  /// \brief Builds the entire application UI.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              'Time 1 Remaining: ${getRemainingTime(_remainingTime1)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
            Text(
              'Time 2 Remaining: ${getRemainingTime(_remainingTime2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(height: 20),
            lightedCircle(),
            const SizedBox(height: 20),
            lightedCircle2(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
