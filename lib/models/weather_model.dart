class Welcome {
  String? cod;
  int? message;
  int? cnt;
  List<ListElement>? list;
  City? city;

  Welcome({
    this.cod,
    this.message,
    this.cnt,
    this.list,
    this.city,
  });

  factory Welcome.fromMap(Map<String, dynamic> map) {
    return Welcome(
      cod: map['cod'],
      message: map['message'],
      cnt: map['cnt'],
      list: (map['list'] as List).map((element) => ListElement.fromMap(element)).toList(),
      city: City.fromMap(map['city']),
    );
  }
}

class City {
  int? id;
  String? name;
  Coord? coord;
  String? country;
  int? population;
  int? timezone;
  int? sunrise;
  int? sunset;

  City({
    this.id,
    this.name,
    this.coord,
    this.country,
    this.population,
    this.timezone,
    this.sunrise,
    this.sunset,
  });

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      id: map['id'],
      name: map['name'],
      coord: Coord.fromMap(map['coord']),
      country: map['country'],
      population: map['population'],
      timezone: map['timezone'],
      sunrise: map['sunrise'],
      sunset: map['sunset'],
    );
  }
}

class Coord {
  double? lat;
  double? lon;

  Coord({
    this.lat,
    this.lon,
  });

  factory Coord.fromMap(Map<String, dynamic> map) {
    return Coord(
      lat: map['lat'],
      lon: map['lon'],
    );
  }
}

class ListElement {
  int? dt;
  Temp? temp;
  List<Weather>? weather;
  Clouds? clouds;
  Wind? wind;
  int? visibility;
  double? pop;
  Sys? sys;
  DateTime? dtTxt;

  ListElement({
    this.dt,
    this.temp,
    this.weather,
    this.clouds,
    this.wind,
    this.visibility,
    this.pop,
    this.sys,
    this.dtTxt,
  });

  factory ListElement.fromMap(Map<String, dynamic> map) {
    return ListElement(
      dt: map['dt'],
      temp: Temp.fromMap(map['main']),
      weather: (map['weather'] as List).map((element) => Weather.fromMap(element)).toList(),
      clouds: Clouds.fromMap(map['clouds']),
      wind: Wind.fromMap(map['wind']),
      visibility: map['visibility'],
      pop: map['pop'].toDouble(),
      sys: Sys.fromMap(map['sys']),
      dtTxt: DateTime.parse(map['dt_txt']),
    );
  }
}

class Clouds {
  int? all;

  Clouds({
    this.all,
  });

  factory Clouds.fromMap(Map<String, dynamic> map) {
    return Clouds(
      all: map['all'],
    );
  }
}

class Temp {
  double? temp;
  double? feelsLike;
  double? tempMin;
  double? tempMax;
  int? pressure;
  int? seaLevel;
  int? grndLevel;
  int? humidity;
  double? tempKf;

  Temp({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.seaLevel,
    this.grndLevel,
    this.humidity,
    this.tempKf,
  });

  factory Temp.fromMap(Map<String, dynamic> map) {
    return Temp(
      temp: map['temp'].toDouble(),
      feelsLike: map['feels_like'].toDouble(),
      tempMin: map['temp_min'].toDouble(),
      tempMax: map['temp_max'].toDouble(),
      pressure: map['pressure'],
      seaLevel: map['sea_level'],
      grndLevel: map['grnd_level'],
      humidity: map['humidity'],
      tempKf: map['temp_kf'].toDouble(),
    );
  }
}

class Rain {
  double? the3H;

  Rain({
    this.the3H,
  });

  factory Rain.fromMap(Map<String, dynamic> map) {
    return Rain(
      the3H: map['3h'].toDouble(),
    );
  }
}

class Sys {
  String? pod;

  Sys({
    this.pod,
  });

  factory Sys.fromMap(Map<String, dynamic> map) {
    return Sys(
      pod: map['pod'],
    );
  }
}

class Weather {
  int? id;
  String? main;
  String? description;
  String? icon;

  Weather({
    this.id,
    this.main,
    this.description,
    this.icon,
  });

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      id: map['id'],
      main: map['main'],
      description: map['description'],
      icon: map['icon'],
    );
  }
}

class Wind {
  double? speed;
  int? deg;
  double? gust;

  Wind({
    this.speed,
    this.deg,
    this.gust,
  });

  factory Wind.fromMap(Map<String, dynamic> map) {
    return Wind(
      speed: map['speed'].toDouble(),
      deg: map['deg'],
      gust: map['gust'].toDouble(),
    );
  }
}
