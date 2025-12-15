// settings_screen.dart


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProv = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Units

            const Text(
              'Temperature Units',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            RadioListTile<String>(
              title: const Text('Metric (°C)'),
              value: 'metric',
              groupValue: settingsProv.units,
              onChanged: (value) {
                if (value != null) {
                  settingsProv.setUnits(value);
                }
              },
            ),

            RadioListTile<String>(
              title: const Text('Imperial (°F)'),
              value: 'imperial',
              groupValue: settingsProv.units,
              onChanged: (value) {
                if (value != null) {
                  settingsProv.setUnits(value);
                }
              },
            ),
            const Divider(height: 32),
          ],
        ),
      ),
    );
  }
}
