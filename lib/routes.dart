import 'package:climapp/screens/weather.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getRoutes(){
  return {
    '/weather' : (BuildContext context) => WeatherScreen()
  };
}