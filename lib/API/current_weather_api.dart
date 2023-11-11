import 'dart:convert';

import 'package:climapp/models/current_weather_model.dart';
import 'package:http/http.dart' as http;

class CurrentWAPI {
  Uri link = Uri.parse('https://api.openweathermap.org/data/2.5/weather?units=metric&lat=19.4326296&lon=-99.1331785&appid=5108ff74cd677c638147f2c6f053e7ae');

  Future<Map<String, dynamic>?> getCurrentWeatherData() async {
    try {
      var response = await http.get(link);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }

    return null;
  }

}