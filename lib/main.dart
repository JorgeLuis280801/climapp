import 'package:climapp/routes.dart';
import 'package:climapp/screens/weather.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: getRoutes(),
      home: WeatherScreen(),
    );
  }
}