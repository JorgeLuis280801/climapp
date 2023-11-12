import 'dart:convert';

import 'package:climapp/models/weather_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherAPI {
  late Uri link;

  Future<Position> obt_Posicion() async{
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<List<ListElement>?> getTemp() async {
  try {
    Position position = await obt_Posicion();
    
    link = Uri.parse('https://api.openweathermap.org/data/2.5/forecast?cnt=8&units=metric&lat=${position.latitude}&lon=${position.longitude}&appid=5108ff74cd677c638147f2c6f053e7ae');

    print(link);

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