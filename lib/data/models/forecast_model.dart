// forecast_model.dart

// Forecast data for multiple days

class DayForecast {
  final int date;
  final double temperature;
  final String weather;

  DayForecast({
    required this.date,
    required this.temperature,
    required this.weather,
  });
}

class ForecastModel {
  final List<DayForecast> days;

  ForecastModel({required this.days});
}
