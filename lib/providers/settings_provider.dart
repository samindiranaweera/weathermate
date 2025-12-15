// settings_provider.dart

// Manages temperature unit and temperature adjustment (notifier)

import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  // Temperature unit

  String _units = 'metric';

  // Temperature adjustment value

  double _tempOffset = 0.0;

  String get units => _units;
  double get tempOffset => _tempOffset;

  // Change temperature unit

  void setUnits(String value) {
    _units = value;
    notifyListeners();
  }

  // Increase temperature offset

  void increaseTemp() {
    _tempOffset += 1;
    notifyListeners();
  }

  // Decrease temperature offset

  void decreaseTemp() {
    _tempOffset -= 1;
    notifyListeners();
  }

  // Reset temperature offset

  void resetTemp() {
    _tempOffset = 0;
    notifyListeners();
  }
}
