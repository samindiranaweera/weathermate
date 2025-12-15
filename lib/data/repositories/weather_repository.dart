// weather_repository.dart

// weather & favorites

import '../datasources/weather_remote_ds.dart';
import '../datasources/weather_local_ds.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../models/favorite_city.dart';

class WeatherRepository {
  final WeatherRemoteDataSource remote;
  final WeatherLocalDataSource local;

  WeatherRepository({
    required this.remote,
    required this.local,
  });

  // weather

  // Get current weather by city name

  Future<WeatherModel> getCurrentWeather(
      String city, String units) {
    return remote.fetchCurrentWeather(city, units);
  }

  // Get 7day forecast by coordinates

  Future<ForecastModel> getForecast(
      double lat, double lon, String units) {
    return remote.fetchForecast(lat, lon, units);
  }

  // favorites

  // Read favorites

  List<FavoriteCity> getFavorites() {
    return local.getFavorites();
  }

  // Add favorite

  Future<void> addFavorite(FavoriteCity city) {
    return local.addFavorite(city);
  }

  // Delete favorite

  Future<void> deleteFavorite(String id) {
    return local.deleteFavorite(id);
  }
}
