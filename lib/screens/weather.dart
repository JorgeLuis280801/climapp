import 'package:climapp/API/weather_api.dart';
import 'package:climapp/models/weather_model.dart';
import 'package:flutter/material.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherAPI? weatherAPI;

  @override
  void initState() {
    super.initState();
    weatherAPI = WeatherAPI();
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
          future: weatherAPI!.getTemp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data != null) {
              // Extraer datos del clima del primer elemento de la lista
              final List<Temp>? tempData = snapshot.data as List<Temp>?;

              if (tempData != null && tempData.isNotEmpty) {
                final temp = tempData[0];
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
                            child: Text('Temperatura Actual: ${temp.temp}°C', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Mín: ${temp.tempMin}°C', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Máx: ${temp.tempMax}°C', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            } else {
              return const Text('No hay datos disponibles');
            }
          },
        ),
      ),
    );
  }
}