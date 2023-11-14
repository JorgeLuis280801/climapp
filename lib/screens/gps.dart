import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:climapp/API/weather_api.dart';
import 'package:climapp/database/database_helper.dart';
import 'package:climapp/models/location.dart';
import 'package:climapp/models/weather_model.dart';
import 'package:climapp/screens/weather.dart';
import 'package:climapp/widgets/dialog_widget.dart';
import 'package:climapp/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GPS_Screen extends StatefulWidget {
  const GPS_Screen({super.key});

  @override
  State<GPS_Screen> createState() => _GPS_ScreenState();
}

class _GPS_ScreenState extends State<GPS_Screen> {
  final WeatherAPI weatherAPI = WeatherAPI();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Location location = Location();
  late CameraPosition cameraPosition;
  List<Marker> markers = List.empty(growable: true);
  List<LocationModel> locations = List.empty(growable: true);
  List<List<ListElement>> dataLocations = List.empty(growable: true);
  double lat = 37.42796133580664;
  double lon = -122.085749655962;
  DatabaseHelper database = DatabaseHelper();
  late TextFieldWidget locationName;
  bool isMapView = true;

  List<String> opciones = ['normal', 'terreno', 'satelital', 'hibrida'];
  String seleccion = 'normal';

  Map<String, MapType> mapType = {
    'normal': MapType.normal,
    'terreno': MapType.terrain,
    'satelital': MapType.satellite,
    'hibrida': MapType.hybrid
  };

  Future<void> checkLocationStatus() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        cameraPosition = const CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 14.4746,
        );
      }
    } else {
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          cameraPosition = const CameraPosition(
            target: LatLng(37.42796133580664, -122.085749655962),
            zoom: 14.4746,
          );
        } else {
          LocationData locationData = await location.getLocation();
          cameraPosition = CameraPosition(
            target:
                LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0),
            zoom: 14.4746,
          );
          lat = locationData.latitude ?? 0;
          lon = locationData.longitude ?? 0;
        }
      } else {
        LocationData locationData = await location.getLocation();
        cameraPosition = CameraPosition(
          target:
              LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0),
          zoom: 14.4746,
        );
        lat = locationData.latitude ?? 0;
        lon = locationData.longitude ?? 0;
      }
    }
  }

  Future<void> _getLocation() async {
    List<ListElement>? elements = await weatherAPI.getTemp(lat: lat, lon: lon);
    ListElement? current = elements![0];
    //WeatherData? weatherData = await getWeatherData(lat: lat, lon: lon);

    markers.add(Marker(
        markerId: const MarkerId('currentLocation'),
        position: cameraPosition.target, // Posición actual
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
            title: 'Posición actual',
            snippet: 'Temperatura actual ${current.temp!.temp}°C',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeatherListScreen(data: elements),
                ),
              );
            }) // Icono rojo
        ));

    await setLocationsInMap();
  }

  Future<List<LocationModel>> getLocations() async {
    return await database.GETALLLOCATIONS();
  }

  Future<void> setLocationsInMap() async {
    locations = await getLocations();
    dataLocations.clear();
    for (LocationModel element in locations) {
      List<ListElement>? elements =
          await weatherAPI.getTemp(lat: element.lat!, lon: element.lon!);
      ListElement? current = elements![0];
      String? weatherDescription = current.weather?[0].description;

      dataLocations.add(elements);
      print("s: " + dataLocations.length.toString());

      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(element.lat!, element.lon!),
        zoom: 14.4746,
      );

      final Uint8List markerIcon = await getBytesFromAsset(
          getWeatherImage(weatherDescription.toString()), 100);
      markers.add(Marker(
          markerId: MarkerId(element.name!),
          position: cameraPosition.target, // Posición actual
          icon: BitmapDescriptor.fromBytes(markerIcon),
          infoWindow: InfoWindow(
              title: element.name,
              snippet: 'Temperatura actual ${current.temp!.temp}°C',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeatherListScreen(data: elements),
                  ),
                );
              })));
    }
  }

  @override
  void initState() {
    super.initState();
    checkLocationStatus().then((value) => _getLocation()
        .then((value) => setLocationsInMap().then((value) => setState(() {}))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _getLocation(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return SafeArea(
                    child: Scaffold(
                        body: isMapView
                            ? GoogleMap(
                                mapType: mapType[seleccion]!,
                                initialCameraPosition: cameraPosition,
                                onMapCreated: (GoogleMapController controller) {
                                  if (!_controller.isCompleted) {
                                    _controller.complete(controller);
                                  }
                                },
                                markers: Set<Marker>.of(markers),
                                //circles: circles,
                                onTap: (LatLng latLng) {
                                  _dialogBuilder(context, latLng.latitude,
                                          latLng.longitude)
                                      .then((value) => setState(() {}));
                                },
                              )
                            : SizedBox(
                                width: double.infinity,
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(
                                        locations[index].name!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                          '${dataLocations[index][0].temp!.temp} °C'),
                                      leading: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(getWeatherImage(
                                                  '${dataLocations[index][0].weather?[0].description}')),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                WeatherListScreen(
                                                    data: dataLocations[index]),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  itemCount: dataLocations.length,
                                ),
                              ),
                        floatingActionButtonLocation:
                            FloatingActionButtonLocation.startFloat,
                        floatingActionButton: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: FloatingActionButton(
                                  heroTag: "btn1",
                                  onPressed: () {
                                    setState(() {
                                      isMapView = !isMapView;
                                    });
                                  },
                                  child:
                                      Icon(!isMapView ? Icons.map : Icons.list),
                                ),
                              ),
                              isMapView
                                  ? Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        color: Colors.white,
                                        child: DropdownButton<String>(
                                          value: seleccion,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              seleccion = newValue!;
                                            });
                                          },
                                          items: opciones.map((String opcion) {
                                            return DropdownMenuItem<String>(
                                              value: opcion,
                                              child: Text(opcion),
                                            );
                                          }).toList(),
                                        ),
                                      ))
                                  : Container(),
                            ],
                          ),
                        )));
              });
            }
          }),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, double lat, double lon) {
    locationName = TextFieldWidget(
      label: "Nombre de la localización",
      hint: "Ingresa el nombre",
      msgError: "",
      inputType: 1,
      lenght: 50,
      icono: Icons.place,
    );

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        DialogWidget dialogWidget = DialogWidget(context: context);
        return AlertDialog(
          title: const Text('Agregar ubicación'),
          content: locationName,
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Aceptar'),
              onPressed: () {
                if (locationName.formkey.currentState!.validate()) {
                  insertLocation(
                          lat: lat,
                          lon: lon,
                          name: locationName.controlador,
                          dialogWidget: dialogWidget)
                      .then((value) => {
                            if (value) {Navigator.of(context).pop()}
                          });
                }
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> insertLocation(
      {required String name,
      required double lat,
      required double lon,
      DialogWidget? dialogWidget}) async {
    late String msg;
    int error = 0;
    try {
      dialogWidget!.showProgress();
      List<ListElement>? elements =
          await weatherAPI.getTemp(lat: lat, lon: lon);
      ListElement? current = elements![0];
      String? weatherDescription = current.weather?[0].description;

      dialogWidget.closeProgress();
      error = await database
          .INSERT('tblLocations', {'name': name, 'lat': lat, 'lon': lon});
      msg = error > 0 ? 'Registro insertado' : 'Error inesperado';
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(lat, lon),
        zoom: 14.4746,
      );
      locations.add(LocationModel(
          id: Random().nextInt(100), lat: lat, lon: lon, name: name));
      dataLocations.add(elements);

      final Uint8List markerIcon = await getBytesFromAsset(
          getWeatherImage(weatherDescription.toString()), 100);
      markers.add(Marker(
          markerId: MarkerId(name),
          position: cameraPosition.target, // Posición actual
          icon: BitmapDescriptor.fromBytes(markerIcon),
          infoWindow: InfoWindow(
              title: name,
              snippet: 'Temperatura actual ${current.temp!.temp}°C',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeatherListScreen(data: elements),
                  ),
                );
              }) // Icono rojo
          ));
    } catch (e) {
      dialogWidget!.closeProgress();
      msg = "Error inesperado";
    } finally {
      Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT, // Duración del toast
        gravity: ToastGravity
            .TOP, // Posición del toast (puedes usar BOTTOM, TOP, CENTER)
        timeInSecForIosWeb:
            1, // Duración en segundos para iOS (se ignora en Android)
        backgroundColor: const Color.fromARGB(125, 0, 0, 0),
        // Color del texto del toast
        fontSize: 16.0, // Tamaño de fuente del texto del toast
      );
      // ignore: control_flow_in_finally
      if (error > 0) {
        return true;
      }
      return false;
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
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
