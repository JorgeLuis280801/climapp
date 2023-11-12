import 'dart:math';

import 'package:climapp/API/weather_api.dart';
import 'package:climapp/models/weather_model.dart';
import 'package:flutter/material.dart';

class WeatherListScreen extends StatelessWidget {
  final WeatherAPI weatherAPI = WeatherAPI();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Temperaturas'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage('assets/images/fondo.jpg'))),
        child: FutureBuilder<List<ListElement>?>(
          future: weatherAPI.getTemp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error al cargar los datos'));
            } else if (snapshot.hasData) {
              List<ListElement>? temperatures = snapshot.data;
              return Center(
                child: 
                    ListView(
                      children: [
                        _currentWeather(temperatures),
                        _buildWeatherList(temperatures)
                      ],
                    )
                );
            } else {
              return Center(child: Text('No hay datos disponibles'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildWeatherList(List<ListElement>? temperatures) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: temperatures?.map((temperature) {
          String? weatherDescription = temperature.weather?[0].description;
          return Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(getWeatherImage(weatherDescription.toString())),
                ),
                Text(
                  '${temperature.temp?.temp}°C',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${extractHour(temperature.dtTxt.toString())}',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        })?.toList() ?? [],
      ),
    );
  }

  Widget _currentWeather(List<ListElement>? temperatures){
    ListElement? current = temperatures![0];
    String? weatherDescription = current.weather?[0].description;
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image(
              image: AssetImage(getWeatherImage(weatherDescription.toString())),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${weatherDescription ?? 'Descripción no disponible'}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Temperatura Actual: ${current.temp!.temp}°C', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Mín: ${current.temp!.tempMin}°C', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Máx: ${current.temp!.tempMax}°C', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ), 
        ],
      ),
    );
  }

  String? extractHour(String? dateTimeString) {
    if (dateTimeString != null) {
      // Separar la fecha y la hora
      List<String> dateTimeParts = dateTimeString.split(" ");
      // Tomar la parte de la hora (el segundo elemento)
      String time = dateTimeParts.length > 1 ? dateTimeParts[1] : '';
      // Separar la hora en horas y minutos
      List<String> timeParts = time.split(":");
      // Tomar solo las horas y minutos
      String hourAndMinute = timeParts.length > 1 ? "${timeParts[0]}:${timeParts[1]}" : '';
      return hourAndMinute;
    }
    return null;
  }

  String getWeatherImage(String weatherDescription) {
    if (weatherDescription == 'clear sky') {
      return 'assets/images/clear.png';
    } else if (weatherDescription == 'few clouds') {
      return 'assets/images/few.png';
    } else if (weatherDescription == 'scattered clouds') {
      return 'assets/images/scattered.png';
    } else if (weatherDescription == 'broken clouds') {
      return 'assets/images/broken.png';
    } else if (weatherDescription == 'shower rain') {
      return 'assets/images/shower.png';
    } else if (weatherDescription == 'rain') {
      return 'assets/images/rain.png';
    } else if (weatherDescription == 'thunderstorm') {
      return 'assets/images/thunder.png';
    } else if (weatherDescription == 'snow') {
      return 'assets/images/snow.png';
    } else if (weatherDescription == 'mist') {
      return 'assets/images/mist.png';
    } else {
      return 'assets/images/clear.png'; // Imagen predeterminada
    }
  }

}
