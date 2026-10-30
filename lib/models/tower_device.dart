enum DeviceType {
  mikrotik,
  ubiquiti,
  olt,
  generic,
}

class TowerDevice {
  final String id;
  final String name;
  final String ipAddress;
  final DeviceType type;
  final int port;
  bool isOnline;

  TowerDevice({
    required this.id,
    required this.name,
    required this.ipAddress,
    required this.type,
    this.port = 80,
    this.isOnline = false,
  });
}
