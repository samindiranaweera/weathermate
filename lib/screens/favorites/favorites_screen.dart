// favorites_screen.dart

// list and delete favorite cities

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/favorites_provider.dart';
import '../../providers/weather_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProv = Provider.of<FavoritesProvider>(context);
    final weatherProv =
    Provider.of<WeatherProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: favoritesProv.favorites.isEmpty
            ? const Center(
          child: Text('No favorites added yet'),
        )
            : ListView.builder(
          itemCount: favoritesProv.favorites.length,
          itemBuilder: (context, index) {
            final fav = favoritesProv.favorites[index];

            return Card(
              child: ListTile(
                title: Text(fav.city),
                subtitle: Text(fav.note),
                leading: const Icon(Icons.location_city),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await favoritesProv
                        .deleteFavorite(fav.id);
                  },
                ),
                onTap: () {
                  weatherProv.loadByCoords(
                    fav.lat,
                    fav.lon,
                  );
                  Navigator.pop(context);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
