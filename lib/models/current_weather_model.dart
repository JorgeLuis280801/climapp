class Welcome {
    Coord? coord;
    List<Weather>? weather;
    String? base;
    CTemp? cTemp;
    int? visibility;
    Wind? wind;
    Clouds? clouds;
    int? dt;
    Sys? sys;
    int? timezone;
    int? id;
    String? name;
    int? cod;

    Welcome({
        this.coord,
        this.weather,
        this.base,
        this.cTemp,
        this.visibility,
        this.wind,
        this.clouds,
        this.dt,
        this.sys,
        this.timezone,
        this.id,
        this.name,
        this.cod,
    });

}

class Clouds {
    int? all;

    Clouds({
        this.all,
    });

}

class Coord {
    double? lon;
    double? lat;

    Coord({
        this.lon,
        this.lat,
    });

}

class CTemp {
    double temp;
    double feelsLike;
    double tempMin;
    double tempMax;
    int pressure;
    int humidity;

    CTemp({
        required this.temp,
        required this.feelsLike,
        required this.tempMin,
        required this.tempMax,
        required this.pressure,
        required this.humidity,
    });

    factory CTemp.fromMap(Map<String, dynamic> map){
      return CTemp(
        temp: map['temp'],
        feelsLike: map['feels_like'],
        tempMin: map['temp_min'],
        tempMax: map['temp_max'],
        pressure: map['pressure'],
        humidity: map['humidity'],
      );
    }


}

class Sys {
    int? type;
    int? id;
    String? country;
    int? sunrise;
    int? sunset;

    Sys({
        this.type,
        this.id,
        this.country,
        this.sunrise,
        this.sunset,
    });

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

    factory Weather.fromMap(Map<String, dynamic> map){
      return Weather(
        id: map['id'],
        main: map['main'],
        description: map['description'],
        icon: map['icon']
      );
    }

}

class Wind {
    double? speed;
    int? deg;

    Wind({
        this.speed,
        this.deg,
    });

}
