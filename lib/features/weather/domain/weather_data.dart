class WeatherData {
  WeatherData({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
    required this.dailyForecast,
    required this.timestamp,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final weather =
        (json['weather'] as List<dynamic>)[0] as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>;
    final sys = json['sys'] as Map<String, dynamic>;

    return WeatherData(
      cityName: json['name'] as String,
      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      description: weather['description'] as String,
      iconCode: weather['icon'] as String,
      humidity: main['humidity'] as int,
      windSpeed: (wind['speed'] as num).toDouble(),
      sunrise: DateTime.fromMillisecondsSinceEpoch(
        (sys['sunrise'] as int) * 1000,
      ),
      sunset: DateTime.fromMillisecondsSinceEpoch(
        (sys['sunset'] as int) * 1000,
      ),
      dailyForecast: [],
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'temperature': temperature,
      'feelsLike': feelsLike,
      'description': description,
      'iconCode': iconCode,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'sunrise': sunrise.millisecondsSinceEpoch,
      'sunset': sunset.millisecondsSinceEpoch,
      'dailyForecast': dailyForecast.map((day) => day.toJson()).toList(),
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory WeatherData.fromCache(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['cityName'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      description: json['description'] as String,
      iconCode: json['iconCode'] as String,
      humidity: json['humidity'] as int,
      windSpeed: (json['windSpeed'] as num).toDouble(),
      sunrise: DateTime.fromMillisecondsSinceEpoch(json['sunrise'] as int),
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sunset'] as int),
      dailyForecast: (json['dailyForecast'] as List)
          .map((day) => DailyForecast.fromCache(day as Map<String, dynamic>))
          .toList(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
    );
  }

  final String cityName;
  final double temperature;
  final double feelsLike;
  final String description;
  final String iconCode;
  final int humidity;
  final double windSpeed;
  final DateTime sunrise;
  final DateTime sunset;
  final List<DailyForecast> dailyForecast;
  final DateTime timestamp;
}

class DailyForecast {
  DailyForecast({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.description,
    required this.iconCode,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    final temp = json['temp'] as Map<String, dynamic>;
    final weather =
        (json['weather'] as List<dynamic>)[0] as Map<String, dynamic>;

    return DailyForecast(
      date: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      tempMin: (temp['min'] as num).toDouble(),
      tempMax: (temp['max'] as num).toDouble(),
      description: weather['description'] as String,
      iconCode: weather['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.millisecondsSinceEpoch,
      'tempMin': tempMin,
      'tempMax': tempMax,
      'description': description,
      'iconCode': iconCode,
    };
  }

  factory DailyForecast.fromCache(Map<String, dynamic> json) {
    return DailyForecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      tempMin: (json['tempMin'] as num).toDouble(),
      tempMax: (json['tempMax'] as num).toDouble(),
      description: json['description'] as String,
      iconCode: json['iconCode'] as String,
    );
  }

  final DateTime date;
  final double tempMin;
  final double tempMax;
  final String description;
  final String iconCode;
}
