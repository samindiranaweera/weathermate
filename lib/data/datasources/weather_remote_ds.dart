// weather_remote_ds.dart

// Handles all OpenWeatherMap API calls (current + 7-day forecast)

import 'package:dio/dio.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherRemoteDataSource {
  final Dio dio;

  final String apiKey = '933a547a344bc978bf44d2825580cd29';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  WeatherRemoteDataSource(this.dio);

  // Current Weather

  Future<WeatherModel> fetchCurrentWeather(
      String city, String units) async {
    final response = await dio.get(
      '$baseUrl/weather',
      queryParameters: {
        'q': city,
        'appid': apiKey,
        'units': units,
      },
    );

    return WeatherModel.fromJson(response.data);
  }

  // 7-Day Forecast

  Future<ForecastModel> fetchForecast(
      double lat, double lon, String units) async {
    final response = await dio.get(
      '$baseUrl/forecast',
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': apiKey,
        'units': units,
      },
    );

    final Map<String, DayForecast> dailyForecastMap = {};

    for (final item in response.data['list']) {
      final dateTime =
      DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);

      final dayKey =
          '${dateTime.year}-${dateTime.month}-${dateTime.day}';

      // Store one forecast per day

      if (!dailyForecastMap.containsKey(dayKey)) {
        dailyForecastMap[dayKey] = DayForecast(
          date: item['dt'],
          temperature: item['main']['temp'].toDouble(),
          weather: item['weather'][0]['main'],
        );
      }
    }

    // Take first 7 days

    final days = dailyForecastMap.values.take(7).toList();

    return ForecastModel(days: days);
  }
}
