import 'package:climapp/screens/gps.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getRoutes(){
  return {
    '/map' : (BuildContext context) => GPS_Screen()
  };
}