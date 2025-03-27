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
      color: Colors.green,
      home: Scaffold(
          body: Center(
              child: Stack(
                  children: <Widget>[
                    lightRectangle,
                    Positioned(
                      top: 10.0,
                      left: 10.0,
                      child: Container (
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          )
                      ),
                    ),
                    Positioned(
                      top: 10.0,
                      left: 60.0,
                      child: Container (
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          )
                      ),
                    ),
                    Positioned(
                      top: 10.0,
                      right: 110.0,
                      child: Container (
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Colors.grey,
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