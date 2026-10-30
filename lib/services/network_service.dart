import 'dart:io';
import 'package:network_info_plus/network_info_plus.dart';
import '../models/tower_device.dart';

class NetworkService {
  // فحص اتصال حقيقي بمنفذ الجهاز
  static Future<bool> checkDevice(String ip, int port) async {
    try {
      final socket = await Socket.connect(
        ip,
        port,
        timeout: const Duration(seconds: 2),
      );
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  // فحص كل الأجهزة بنفس الوقت
  static Future<List<TowerDevice>> scanTowerDevices(
      List<TowerDevice> devices) async {
    await Future.wait(devices.map((d) async {
      d.isOnline = await checkDevice(d.ipAddress, d.port);
    }));
    return devices;
  }

  // قراءة معلومات الشبكة الحالية (الواي فاي)
  static Future<Map<String, String?>> getNetworkInfo() async {
    final info = NetworkInfo();
    return {
      'ip': await info.getWifiIP(),
      'gateway': await info.getWifiGatewayIP(),
      'name': await info.getWifiName(),
    };
  }
}
