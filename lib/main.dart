import 'package:flutter/material.dart';

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