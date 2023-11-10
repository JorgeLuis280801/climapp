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

}

class Coord {
    double? lat;
    double? lon;

    Coord({
        this.lat,
        this.lon,
    });

}

class ListElement {
    int? dt;
    Temp? temp;
    List<Weather>? weather;
    Clouds? clouds;
    Wind? wind;
    int? visibility;
    double? pop;
    Rain? rain;
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
        this.rain,
        this.sys,
        this.dtTxt,
    });

}

class Clouds {
    int? all;

    Clouds({
        this.all,
    });

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

    factory Temp.fromMap(Map<String, dynamic> map){
      return Temp(
        temp: map['temp'],
        feelsLike: map['feelsLike'],
        tempMin: map['temp_min'],
        tempMax: map['temp_max'],
        pressure: map['pressure'],
        seaLevel: map['seaLevel'],
        grndLevel: map['grndLevel'],
        humidity: map['humidity'],
        tempKf: map['tempKF']
      );
    }
}

class Rain {
    double? the3H;

    Rain({
        this.the3H,
    });

}

class Sys {
    String? pod;

    Sys({
        this.pod,
    });

}

class Weather {
    int? id;
    String? Temp;
    String? description;
    String? icon;

    Weather({
        this.id,
        this.Temp,
        this.description,
        this.icon,
    });

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

}
