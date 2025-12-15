// search_screen.dart

// enter city name and fetch weather

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/weather_provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final weatherProv =
    Provider.of<WeatherProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search City'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // City name input

            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'City name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Search button

            ElevatedButton(
              onPressed: () async {
                final city = controller.text.trim();
                if (city.isNotEmpty) {
                  await weatherProv.searchCity(city);
                  Navigator.pop(context);  // return to Home
                }
              },
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
