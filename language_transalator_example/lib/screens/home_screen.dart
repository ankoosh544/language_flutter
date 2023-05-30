import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:language_transalator_example/components/drawar.dart';
import 'package:language_transalator_example/screens/device_screen.dart';
import 'package:language_transalator_example/screens/login_screen.dart';
import 'package:language_transalator_example/utils/session_manager.dart';
import 'package:collection/collection.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart' as gen;
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<ScanResult> scanResultList = [];
  bool _isScanning = false;
  StreamSubscription<List<ScanResult>>? scanResultsSubscription;

  final String DeviceType = "ESP32";
  @override
  void initState() {
    super.initState();
    initBle();
    scan();
    checkLoginStatus();
    connectToBondedDevice();
  }

  @override
  void dispose() {
    scanResultsSubscription?.cancel();
    super.dispose();
  }

  void checkLoginStatus() async {
    bool isLoggedIn = await SessionManager.isLoggedIn();

    if (!isLoggedIn) {
      _navigateToLoginScreen();
    }
  }

  void _navigateToLoginScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void initBle() {
    StreamSubscription<bool>? isScanningSubscription;

    isScanningSubscription = flutterBlue.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      if (mounted) {
        setState(() {});
      }
    });

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
      isScanningSubscription?.cancel();
    });
  }

  Future<void> scan() async {
    if (!_isScanning) {
      scanResultList.clear();
      flutterBlue.startScan(timeout: Duration(seconds: 4));

      scanResultsSubscription = flutterBlue.scanResults.listen((results) {
        for (ScanResult result in results) {
          if (result.device.name == DeviceType &&
              result.device.state != BluetoothDeviceState.connecting &&
              result.device.state != BluetoothDeviceState.connected) {
            _connectToDevice(result.device);
            break;
          }
        }

        if (mounted) {
          setState(() {});
        }
      });
    } else {
      flutterBlue.stopScan();
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    if (device.state != BluetoothDeviceState.connected) {
      await device.connect(autoConnect: true);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeviceScreen(device: device),
        ),
      );
    } else {
      // Device is already connected, handle accordingly (e.g., show a message)
      print('Device is already connected.');
    }
  }

  Future<void> connectToBondedDevice() async {
    String? connectedDeviceId = await SessionManager.getConnectedDeviceId();
    if (connectedDeviceId != null) {
      print(connectedDeviceId);
      print("Connected Device ID====================================");
      ScanResult? connectedDevice = scanResultList.firstWhereOrNull(
        (result) => result.device.id.id == connectedDeviceId,
      );
      if (connectedDevice != null) {
        if (connectedDevice.device.state == BluetoothDeviceState.connected) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DeviceScreen(device: connectedDevice.device),
            ),
          );
        } else {
          await connectToDevice(connectedDevice.device);
        }
      }
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect(autoConnect: true);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeviceScreen(device: device),
        ),
      );
    } catch (e) {
      print('Error connecting to device: $e');
      // Handle the connection error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gen.AppLocalizations.of(context)!.home),
      ),
      drawer: MyDrawer(),
      body: Center(
        child: _isScanning
            ? CircularProgressIndicator() // Show a loading indicator while scanning
            : scanResultList.isEmpty
                ? Text(
                    'No devices found near you.') // Show a message if no devices are found
                : ListView.separated(
                    itemCount: scanResultList.length,
                    itemBuilder: (context, index) {
                      ScanResult result = scanResultList[index];
                      return ListTile(
                        title: Text(result.device.name),
                        subtitle: Text(result.device.id.id),
                        onTap: () => _connectToDevice(result.device),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                  ),
      ),
    );
  }
}
