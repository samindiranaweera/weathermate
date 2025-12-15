// favorites_provider.dart

// manages favorite cities

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../data/models/favorite_city.dart';
import '../data/repositories/weather_repository.dart';

class FavoritesProvider extends ChangeNotifier {
  final WeatherRepository repository;
  final List<FavoriteCity> favorites = [];

  FavoritesProvider({required this.repository});

  // Load favorites from local storage

  void loadFavorites() {
    favorites.clear();
    favorites.addAll(repository.getFavorites());
    notifyListeners();
  }

  // Add a favorite city

  Future<void> addFavorite(
      String city, String note, double lat, double lon) async {
    final favorite = FavoriteCity(
      id: const Uuid().v4(),
      city: city,
      note: note,
      lat: lat,
      lon: lon,
    );

    await repository.addFavorite(favorite);
    favorites.add(favorite);
    notifyListeners();
  }

  // Delete a favorite city

  Future<void> deleteFavorite(String id) async {
    await repository.deleteFavorite(id);
    favorites.removeWhere((f) => f.id == id);
    notifyListeners();
  }
}
