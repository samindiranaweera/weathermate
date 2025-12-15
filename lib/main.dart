// main.dart

// initializes Hive, Dio, Repository, and Providers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';
import 'screens/home/home_screen.dart';

import 'core/theme.dart';
import 'data/datasources/weather_remote_ds.dart';
import 'data/datasources/weather_local_ds.dart';
import 'data/repositories/weather_repository.dart';
import 'providers/weather_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/settings_provider.dart';

class AppStart extends StatelessWidget {
  const AppStart({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'WeatherMate starting...',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage

  await Hive.initFlutter();
  final favoritesBox = await Hive.openBox('favoritesBox');

  // Initialize Dio for API calls

  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // Create data sources

  final remoteDS = WeatherRemoteDataSource(dio);
  final localDS = WeatherLocalDataSource(favoritesBox);

  // Create repository

  final repository = WeatherRepository(
    remote: remoteDS,
    local: localDS,
  );

  runApp(WeatherMateApp(repository: repository));
}

class WeatherMateApp extends StatelessWidget {
  final WeatherRepository repository;

  const WeatherMateApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        // Settings provider (Metric / Imperial)

        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),

        // Weather provider (depends on repository & settings)

        ChangeNotifierProvider(
          create: (context) {
            final provider =
            WeatherProvider(repository: repository);

            provider.attachSettings(
              Provider.of<SettingsProvider>(context, listen: false),
            );

            return provider;
          },
        ),

        // Favorites provider (depends on repository)

        ChangeNotifierProvider(
          create: (_) =>
              FavoritesProvider(repository: repository),
        ),
      ],
      child: MaterialApp(
        title: 'WeatherMate',
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
