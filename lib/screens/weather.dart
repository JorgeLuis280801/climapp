import 'package:climapp/API/current_weather_api.dart';
import 'package:flutter/material.dart';

import '../models/current_weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  CurrentWAPI? currentWAPI;

  @override
  void initState() {
    super.initState();
    currentWAPI = CurrentWAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima para hoy'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage('assets/images/fondo.jpg'))),
        child: FutureBuilder(
          future: currentWAPI!.getCurrentWeatherData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data != null) {
              // Extraer datos del clima del primer elemento de la lista
              final Map<String, dynamic>? weatherData = snapshot.data;

              if (weatherData != null) {
                final tempData = CTemp.fromMap(weatherData['main']);
                final weather = weatherData['weather'];
                if (tempData != null && weather != null && weather.isNotEmpty) {
                  final mainDescription = weather[0]['description'] ?? 'Descripción no disponible';
                  return Center(
                    child: ListView(
                      padding: EdgeInsets.all(8),
                      children: <Widget>[
                        Container(
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
                                padding: const EdgeInsets.all(8.0),
                                child: Text('$mainDescription', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Temperatura Actual: ${tempData.temp}°C', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Mín: ${tempData.tempMin}°C', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Máx: ${tempData.tempMax}°C', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ) 
                            ],
                          ),
                        ),
                      ]
                    ),
                  );
                }else {
                return const Text('No se encontraron datos de clima');
                }
              }else {
                return const Text('No se encontraron datos de clima');
              }
            } else {
              return const Text('No hay datos disponibles');
            }
          },
        ),
      ),
    );
  }
}