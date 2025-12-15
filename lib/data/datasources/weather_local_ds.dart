// weather_local_ds.dart

// Handles local storage for favorites using Hive

import 'package:hive/hive.dart';
import '../models/favorite_city.dart';

class WeatherLocalDataSource {
  final Box box;

  WeatherLocalDataSource(this.box);

  // Get all saved favorite cities
  List<FavoriteCity> getFavorites() {
    return box.values
        .map((e) => FavoriteCity.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  // Save a favorite city

  Future<void> addFavorite(FavoriteCity city) async {
    await box.put(city.id, city.toMap());
  }

  // Delete a favorite city

  Future<void> deleteFavorite(String id) async {
    await box.delete(id);
  }
}
