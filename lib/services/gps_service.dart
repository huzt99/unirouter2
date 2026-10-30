import 'package:flutter/foundation.dart';

class GpsService {
  static Future<Map<String, double>> getCurrentTowerCoordinates() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return {
        'latitude': 31.3156,
        'longitude': 45.2758,
      };
    } catch (e) {
      debugPrint('Error getting GPS: $e');
      return {'latitude': 0.0, 'longitude': 0.0};
    }
  }

  static bool isWithinCoverage(
      double userLat, double userLng, double towerLat, double towerLng) {
    return true;
  }
}
