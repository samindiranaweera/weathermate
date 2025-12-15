// utils.dart

// Format temperature with unit and adjustment
String formatTemperature(
    double temp,
    String units, {
      double offset = 0,
    }) {
  final adjustedTemp = temp + offset;

  if (units == 'imperial') {
    return '${adjustedTemp.toStringAsFixed(1)} °F';
  }
  return '${adjustedTemp.toStringAsFixed(1)} °C';
}

//readable date
String formatDate(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
