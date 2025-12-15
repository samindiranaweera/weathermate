// weather_model.dart

// Current weather data from OpenWeatherMap

class WeatherModel {
  final String cityName;
  final String description;
  final double temperature;
  final double lat;
  final double lon;

  WeatherModel({
    required this.cityName,
    required this.description,
    required this.temperature,
    required this.lat,
    required this.lon,
  });

  // Convert API to WeatherModel

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      description: json['weather'][0]['main'],
      temperature: json['main']['temp'].toDouble(),
      lat: json['coord']['lat'].toDouble(),
      lon: json['coord']['lon'].toDouble(),
    );
  }
}
