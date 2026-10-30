import 'package:flutter/material.dart';
import 'models/tower_device.dart';
import 'models/tower_location_model.dart';
import 'services/network_service.dart';
import 'services/gps_service.dart';

void main() {
  runApp(const UniRouterApp());
}

class UniRouterApp extends StatelessWidget {
  const UniRouterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniRouter & Towers',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TowerDashboardScreen(),
    );
  }
}

class TowerDashboardScreen extends StatefulWidget {
  const TowerDashboardScreen({super.key});

  @override
  State<TowerDashboardScreen> createState() => _TowerDashboardScreenState();
}

class _TowerDashboardScreenState extends State<TowerDashboardScreen> {
  List<TowerDevice> towerDevices = [
    TowerDevice(
        id: '1',
        name: 'MikroTik Core Router',
        ipAddress: '192.168.88.1',
        type: DeviceType.mikrotik,
        port: 80),
    TowerDevice(
        id: '2',
        name: 'Ubiquiti Main Link',
        ipAddress: '192.168.1.20',
        type: DeviceType.ubiquiti,
        port: 443),
  ];

  final List<TowerLocationModel> towerLocations = const [
    TowerLocationModel(
        id: 't1',
        towerName: 'برج السادة الرئيسي',
        latitude: 31.3156,
        longitude: 45.2758,
        address: 'الحيشان'),
    TowerLocationModel(
        id: 't2',
        towerName: 'برج البساتين',
        latitude: 31.3200,
        longitude: 45.2800,
        address: 'البساتين الشرقية'),
  ];

  bool isLoading = false;
  Map<String, String?> networkInfo = {};

  Future<void> refreshData() async {
    setState(() => isLoading = true);
    var updatedList = await NetworkService.scanTowerDevices(towerDevices);
    var info = await NetworkService.getNetworkInfo();
    await GpsService.getCurrentTowerCoordinates();
    setState(() {
      towerDevices = updatedList;
      networkInfo = info;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الأبراج - UniRouter'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : refreshData,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('الشبكة الحالية',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.wifi, color: Colors.blue),
                    title: Text('الشبكة: ${networkInfo['name'] ?? 'غير معروف'}'),
                    subtitle: Text(
                        'IP التلفون: ${networkInfo['ip'] ?? '-'}\nالراوتر (Gateway): ${networkInfo['gateway'] ?? '-'}'),
                    isThreeLine: true,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('أجهزة ومعدات البرج',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                ...towerDevices.map((device) => Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.router, color: Colors.blue),
                        title: Text(device.name),
                        subtitle:
                            Text('IP: ${device.ipAddress}  المنفذ: ${device.port}'),
                        trailing: Text(
                          device.isOnline ? 'متصل' : 'غير متصل',
                          style: TextStyle(
                              color: device.isOnline
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                const Divider(height: 30),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('مواقع الأبراج GPS',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                ...towerLocations.map((loc) => Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.location_on,
                            color: Colors.green),
                        title: Text(loc.towerName),
                        subtitle: Text(
                            '${loc.address}\nإحداثيات: ${loc.latitude}, ${loc.longitude}'),
                        isThreeLine: true,
                      ),
                    )),
              ],
            ),
    );
  }
}
