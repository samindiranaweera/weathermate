// home_screen.dart

// search, current weather, favorites preview

// temperature alert notification (17°C–25°C)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/weather_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/loading_widget.dart';
import '../../core/utils.dart';
import '../search/search_screen.dart';
import '../settings/settings_screen.dart';
import '../favorites/favorites_screen.dart';
import '../details/city_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProv = Provider.of<WeatherProvider>(context);
    final favProv = Provider.of<FavoritesProvider>(context);
    final settingsProv = Provider.of<SettingsProvider>(context);

    final TextEditingController searchController =
    TextEditingController();

    // Temperature Alert Notification

    if (weatherProv.tempAlert.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(weatherProv.tempAlert),
            duration: const Duration(seconds: 3),
          ),
        );
        weatherProv.clearTempAlert();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('WeatherMate'),
        actions: [

          // Search icon

          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SearchScreen(),
                ),
              );
            },
          ),

          // Settings icon

          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Search Bar

            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search city',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: (value) async {
                final city = value.trim();
                if (city.isNotEmpty) {
                  await weatherProv.searchCity(city);
                }
              },
            ),

            const SizedBox(height: 20),

            // Current Weather

            const Text(
              'Current Weather',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            if (weatherProv.isLoading)
              const LoadingWidget()
            else if (weatherProv.currentWeather != null)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const CityDetailsScreen(),
                    ),
                  );
                },
                child: Card(
                  child: ListTile(
                    title: Text(
                      weatherProv.currentWeather!.cityName,
                    ),
                    subtitle: Text(
                      weatherProv.currentWeather!.description,
                    ),
                    trailing: Text(
                      formatTemperature(
                        weatherProv
                            .currentWeather!.temperature,
                        settingsProv.units,
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            else
              const Text(
                'Search for a city to see weather',
              ),

            const SizedBox(height: 24),

            //  Favorites

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Favorites',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    favProv.loadFavorites();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const FavoritesScreen(),
                      ),
                    );
                  },
                  child: const Text('Manage'),
                ),
              ],
            ),

            if (favProv.favorites.isEmpty)
              const Text('No favorites added')
            else
              ListView.builder(
                shrinkWrap: true,
                physics:
                const NeverScrollableScrollPhysics(),
                itemCount: favProv.favorites.length,
                itemBuilder: (_, index) {
                  final fav = favProv.favorites[index];
                  return ListTile(
                    title: Text(fav.city),
                    subtitle: Text(fav.note),
                    onTap: () {
                      weatherProv.loadByCoords(
                        fav.lat,
                        fav.lon,
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
