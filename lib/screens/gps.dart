import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GPS_Screen extends StatefulWidget {
  const GPS_Screen({super.key});

  @override
  State<GPS_Screen> createState() => _GPS_ScreenState();
}

class _GPS_ScreenState extends State<GPS_Screen> {

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

  void get_Location() async{
    Position position = await obt_Posicion();
    print(position.latitude);
    print(position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPS'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            get_Location();
          }, 
          child: Text('Dar coordenadas')
        ),
      ),
    );
  }
}