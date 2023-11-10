import 'dart:convert';

import 'package:climapp/models/current_weather_model.dart';
import 'package:http/http.dart' as http;

class Current_W_API {
  Uri link = Uri.parse('https://api.openweathermap.org/data/2.5/weather?units=metric&lang=es&lat=19.4326296&lon=-99.1331785&appid=5108ff74cd677c638147f2c6f053e7ae');

  Future<List<CTemp>?> getTemp() async {
  try {
    var response = await http.get(link);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      
      final List<dynamic>? tempData = jsonResponse['list'];
      if (tempData != null) {
        return tempData.map((ctemp) => CTemp.fromMap(ctemp['main'])).toList();
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }

  return null;
  }
}