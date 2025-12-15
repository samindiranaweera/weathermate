// weather_provider.dart

// Manages weather data, forecast, unit changes, and temperature alerts

import 'package:flutter/material.dart';
import '../data/repositories/weather_repository.dart';
import '../data/models/weather_model.dart';
import '../data/models/forecast_model.dart';
import 'settings_provider.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherRepository repository;
  late SettingsProvider settings;

  WeatherModel? currentWeather;
  ForecastModel? forecast;

  bool isLoading = false;
  String? error;

  // Temperature alert message

  String _tempAlert = '';
  String get tempAlert => _tempAlert;

  WeatherProvider({required this.repository});

  // Attach settingsprovider to read units

  void attachSettings(SettingsProvider settingsProvider) {
    settings = settingsProvider;
  }

  // Temperature normal range check (17–25 °C)

  void _checkTemperature(double temp) {
    if (temp < 17) {
      _tempAlert = 'Temperature is lower than normal';
    } else if (temp > 25) {
      _tempAlert = 'Temperature is higher than normal';
    } else {
      _tempAlert = '';
    }
  }

  // Clear alert after showing notification

  void clearTempAlert() {
    _tempAlert = '';
  }

  // Search weather by city

  Future<void> searchCity(String city) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      currentWeather =
      await repository.getCurrentWeather(city, settings.units);

      _checkTemperature(currentWeather!.temperature);

      forecast = await repository.getForecast(
        currentWeather!.lat,
        currentWeather!.lon,
        settings.units,
      );
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // Load weather from favorites

  Future<void> loadByCoords(double lat, double lon) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // Forecast by coordinates

      forecast = await repository.getForecast(
        lat,
        lon,
        settings.units,
      );
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // Reload data when unit changes

  Future<void> reloadWithNewUnits() async {
    if (currentWeather == null) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // Refetch current weather with new unit

      currentWeather = await repository.getCurrentWeather(
        currentWeather!.cityName,
        settings.units,
      );

      _checkTemperature(currentWeather!.temperature);

      // Refetch forecast with new unit

      forecast = await repository.getForecast(
        currentWeather!.lat,
        currentWeather!.lon,
        settings.units,
      );
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
