import 'dart:convert';

import 'package:climapp/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherAPI {
  Uri link = Uri.parse('https://api.openweathermap.org/data/2.5/forecast?cnt=8&units=metric&lat=19.4326296&lon=-99.1331785&appid=5108ff74cd677c638147f2c6f053e7ae');

  Future<List<ListElement>?> getTemp() async {
  try {
    var response = await http.get(link);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      final List<dynamic>? tempData = jsonResponse['list'];

      if (tempData != null) {
        List<ListElement> processedData = tempData
            .map((temp) => ListElement.fromMap(temp as Map<String, dynamic>))
            .toList();
        
        print('Datos procesados: $processedData');

        return processedData;
      } else {
        print('Datos nulos');
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