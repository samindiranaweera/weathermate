// city_details_screen.dart

// weather details, save favorite, forecast with scrolling

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/weather_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/settings_provider.dart';
import '../../core/utils.dart';
import 'forecast_widget.dart';

class CityDetailsScreen extends StatelessWidget {
  const CityDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProv = Provider.of<WeatherProvider>(context);
    final favoritesProv =
    Provider.of<FavoritesProvider>(context, listen: false);
    final settingsProv = Provider.of<SettingsProvider>(context);

    final weather = weatherProv.currentWeather;
    final forecast = weatherProv.forecast;

    if (weather == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('City Details'),
        ),
        body: const Center(
          child: Text('No weather data available'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(weather.cityName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Current Weather

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weather.cityName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(weather.description),
                      ],
                    ),
                    Text(
                      formatTemperature(
                        weather.temperature,
                        settingsProv.units,
                        offset: settingsProv.tempOffset,
                      ),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            //  Save to Favorites

            ElevatedButton(
              onPressed: () async {
                await favoritesProv.addFavorite(
                  weather.cityName,
                  'Saved from details',
                  weather.lat,
                  weather.lon,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Added to favorites'),
                  ),
                );
              },
              child: const Text('Save to Favorites'),
            ),

            const SizedBox(height: 24),

            // Forecast

            const Text(
              '7 Day Forecast',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            if (forecast != null)
              ForecastWidget(forecast: forecast)
            else
              const Text('No forecast data available'),
          ],
        ),
      ),
    );
  }
}
