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
      body: FutureBuilder<List<Temp>?>(
        future: weatherAPI.getTemp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los datos'));
          } else if (snapshot.hasData) {
            List<Temp>? temperatures = snapshot.data;
            return _buildWeatherList(temperatures);
          } else {
            return Center(child: Text('No hay datos disponibles'));
          }
        },
      ),
    );
  }

  Widget _buildWeatherList(List<Temp>? temperatures) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: temperatures?.length ?? 0,
      itemBuilder: (context, index) {
        Temp? temperature = temperatures![index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Temperatura: ${temperature?.temp.toString()}°C',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                // Otros detalles de temperatura que desees mostrar
              ],
            ),
          ),
        );
      },
    );
  }
}
