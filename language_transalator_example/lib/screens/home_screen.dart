import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:language_transalator_example/components/drawar.dart';
import 'package:language_transalator_example/screens/device_screen.dart';
import 'package:language_transalator_example/screens/login_screen.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';

import 'package:language_transalator_example/utils/session_manager.dart';

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
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool isAudioEnabled = false;
  bool isVisualEnabled = false;
  final String deviceType = "ESP32";

  @override
  void initState() {
    super.initState();
    initBle();
    scan();
    checkLoginStatus();
    initializeNotifications();
  }

  @override
  void dispose() {
    scanResultsSubscription?.cancel(); // Cancel the scan results subscription
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
    // Create a reference to the subscription
    StreamSubscription<bool> isScanningSubscription;

    // Listen to the isScanning stream and update the _isScanning variable
    isScanningSubscription = flutterBlue.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      if (mounted) {
        setState(() {});
      }
    });

    // Cancel the subscription during dispose()
    // to break the reference to the State object
    // and avoid memory leaks
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
      isScanningSubscription.cancel();
    });
  }

  Future<void> scan() async {
    if (!_isScanning) {
      scanResultList.clear();
      flutterBlue.startScan(timeout: Duration(seconds: 4));

      scanResultsSubscription = flutterBlue.scanResults.listen((results) async {
        scanResultList = results;
        if (mounted) {
          setState(() {});
        }

        // Check if previously connected device is available
        String? connectedDeviceId = await SessionManager.getConnectedDeviceId();
        if (connectedDeviceId != null) {
          debugPrint(connectedDeviceId.toString());
          ScanResult? connectedDevice = scanResultList.firstWhereOrNull(
            (result) => result.device.id.id == connectedDeviceId,
          );

          if (connectedDevice != null) {
            // Connect to the device
            await flutterBlue.stopScan();
            await connectedDevice.device.connect(autoConnect: true);
            showNotification('Connected to ${connectedDevice.device.name}');
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DeviceScreen(device: connectedDevice.device)),
            );
          }
        }
      });
    } else {
      flutterBlue.stopScan();
    }
  }

  void initializeNotifications() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> showNotification(String message) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'test_channel_id',
      'Test Channel',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Bluetooth Notification Testig',
      message,
      platformChannelSpecifics,
      payload: 'notification_payload',
    );
  }

  Widget deviceSignal(ScanResult r) {
    debugPrint(r.toString());
    debugPrint("=============Signal of device=======================");
    return Text(r.rssi.toString());
  }

  Widget deviceMacAddress(ScanResult r) {
    return Text(r.device.id.id);
  }

  Widget deviceName(ScanResult r) {
    String name = '';

    if (r.device.name.isNotEmpty) {
      name = r.device.name;
    } else if (r.advertisementData.localName.isNotEmpty) {
      name = r.advertisementData.localName;
    } else {
      name = 'N/A';
    }
    return Text(name);
  }

  Widget leading(ScanResult r) {
    return const CircleAvatar(
      child: Icon(
        Icons.bluetooth,
        color: Colors.white,
      ),
      backgroundColor: Colors.cyan,
    );
  }

  void onTap(ScanResult r) {
    print('${r.device.name}');
    showNotification('Connected to ${r.device.name}');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DeviceScreen(device: r.device)),
    );
  }

  Widget listItem(ScanResult r) {
    return ListTile(
      onTap: () => onTap(r),
      leading: leading(r),
      title: deviceName(r),
      subtitle: deviceMacAddress(r),
      trailing: deviceSignal(r),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.home),
      ),
      drawer: MyDrawer(),
      body: Center(
        child: ListView.separated(
          itemCount: scanResultList.length,
          itemBuilder: (context, index) {
            return listItem(scanResultList[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scan,
        child: Icon(_isScanning ? Icons.stop : Icons.search),
      ),
    );
  }
}
