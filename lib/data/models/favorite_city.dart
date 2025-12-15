// favorite_city.dart

// Favorite city stored locally using Hive

class FavoriteCity {
  final String id;
  final String city;
  final String note;
  final double lat;
  final double lon;

  FavoriteCity({
    required this.id,
    required this.city,
    required this.note,
    required this.lat,
    required this.lon,
  });

  // Convert model to Map (for Hive storage)

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'city': city,
      'note': note,
      'lat': lat,
      'lon': lon,
    };
  }

  // Convert Map to model

  factory FavoriteCity.fromMap(Map<String, dynamic> map) {
    return FavoriteCity(
      id: map['id'],
      city: map['city'],
      note: map['note'],
      lat: map['lat'],
      lon: map['lon'],
    );
  }
}
