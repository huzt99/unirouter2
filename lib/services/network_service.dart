import '../models/tower_device.dart';

class NetworkService {
  static Future<List<TowerDevice>> scanTowerDevices(
      List<TowerDevice> devices) async {
    await Future.delayed(const Duration(seconds: 1));
    return devices;
  }
}
