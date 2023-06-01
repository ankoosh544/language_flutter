import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:language_transalator_example/components/welcome_widget.dart';
import 'package:language_transalator_example/utils/session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/connection_status_widget.dart';

bool isConnected = false; // Global state for connection status

class DeviceScreen extends StatefulWidget {
  DeviceScreen({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  FlutterTts flutterTts = FlutterTts();

  String stateText = 'Connecting';
  String connectButtonText = 'Connect';
  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;
  StreamSubscription<BluetoothDeviceState>? _stateListener;
  List<BluetoothService> bluetoothService = [];

  BluetoothCharacteristic? sensorCharacteristic;
  StreamSubscription<List<int>>? _dataSubscription;

  int? _floorNumber; // New variable for floor number

  @override
  void initState() {
    super.initState();
    _stateListener = widget.device.state.listen((event) {
      debugPrint('event: $event');
      if (deviceState == event) {
        return;
      }

      setBleConnectionState(event);
      loadSessionValues();
    });
  }

  Future<void> loadSessionValues() async {
    isConnected = await SessionManager.getIsConnected();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      bool? isConnectedPref = prefs.getBool('isConnected');
      if (isConnectedPref != null) {
        isConnected = isConnectedPref;
      }
    });
    print(isConnected);
    print("==============LoadSessionValues============================");
  }

  @override
  void dispose() {
    _stateListener?.cancel();
    _dataSubscription?.cancel(); // Cancel data subscription
    disconnect();
    super.dispose();
  }

  setBleConnectionState(BluetoothDeviceState event) async {
    if (mounted) {
      setState(() {
        deviceState = event;
      });
    }

    switch (event) {
      case BluetoothDeviceState.disconnected:
        setState(() {
          stateText = 'Disconnected';
          isConnected = false;
          connectButtonText = 'Connect';
        });
        Map<String, dynamic> settings = await SessionManager.getSettings();
        if (settings['isAudioEnabled'] &&
            !isConnected &&
            !settings['isVisualEnabled']) {
          flutterTts.speak(AppLocalizations.of(context)!.bledisc);
        } else if (settings['isVisualEnabled'] &&
            !isConnected &&
            !settings['isAudioEnabled']) {
          showSuccessWindowBox(AppLocalizations.of(context)!.bledisc);
        } else if (settings['isAudioEnabled'] &&
            settings['isVisualEnabled'] &&
            !isConnected) {
          flutterTts.speak(AppLocalizations.of(context)!.bledisc);
          showSuccessWindowBox(AppLocalizations.of(context)!.bledisc);
        }
        break;
      case BluetoothDeviceState.disconnecting:
        setState(() {
          stateText = 'Disconnecting';
        });
        break;
      case BluetoothDeviceState.connected:
        setState(() {
          stateText = 'Connected';

          connectButtonText = 'Disconnect';
        });
        // Store the connected device ID in SessionManager
        String deviceId = widget.device.id.id;
        SessionManager.setConnectedDeviceId(deviceId);

        Map<String, dynamic> settings = await SessionManager.getSettings();
        if (settings['isAudioEnabled'] && !isConnected) {
          flutterTts.speak(AppLocalizations.of(context)!.blec);
        }
        if (settings['isVisualEnabled'] && !isConnected) {
          showSuccessWindowBox(AppLocalizations.of(context)!.blec);
        }
        setState(() {
          isConnected = true;
        });
        break;
      case BluetoothDeviceState.connecting:
        setState(() {
          stateText = 'Connecting';
        });
        break;
    }
  }

  Future<bool> connect() async {
    setState(() {
      stateText = 'Connecting';
    });

    // Check if the device is already connected to the same device
    if (deviceState == BluetoothDeviceState.connected &&
        widget.device.id.id == SessionManager.getConnectedDeviceId()) {
      setState(() {
        stateText = 'Connected';
        connectButtonText = 'Disconnect';
      });
      return true;
    }

    try {
      await widget.device
          .connect(autoConnect: false)
          .timeout(Duration(milliseconds: 15000), onTimeout: () {
        debugPrint('timeout failed');
        setBleConnectionState(BluetoothDeviceState.disconnected);
        return false;
      });

      // Store the connected device ID in SessionManager
      String deviceId = widget.device.id.id;
      SessionManager.setConnectedDeviceId(deviceId);

      bluetoothService.clear();
      List<BluetoothService> bleServices =
          await widget.device.discoverServices();
      setState(() {
        bluetoothService = bleServices;
      });

      // Find the characteristic that holds the sensor data
      for (BluetoothService service in bleServices) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.properties.notify) {
            sensorCharacteristic = characteristic;
            await sensorCharacteristic!.setNotifyValue(true);
            _dataSubscription = sensorCharacteristic!.value.listen((data) {
              // Process and analyze the sensor data
              processSensorData(data);
            });
            break;
          }
        }
        if (sensorCharacteristic != null) {
          break;
        }
      }

      setState(() {
        stateText = 'Connected';
        connectButtonText = 'Disconnect';
      });

      return true;
    } catch (e) {
      debugPrint('connection failed: $e');
      setBleConnectionState(BluetoothDeviceState.disconnected);
      return false;
    }
  }

  void disconnect() {
    setState(() {
      stateText = 'Disconnecting';
    });
    _dataSubscription?.cancel(); // Cancel data subscription
    widget.device.disconnect();
  }

  void processSensorData(List<int> data) {
    print(data);
    // Analyze the sensor data
    // Perform your calculations, data interpretation, or visualization
    // based on the received data
  }

  // Success windowBox
  void showSuccessWindowBox(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
      ),
      body: Column(
        children: [
          ConnectionStatusWidget(
            stateText: stateText,
            connectButtonText: connectButtonText,
            onPressed: () {
              if (deviceState == BluetoothDeviceState.connected) {
                disconnect();
              } else if (deviceState == BluetoothDeviceState.disconnected) {
                connect();
              }
            },
          ),
          SizedBox(height: 16),
          if (stateText == "Connected")
            WelcomeWidget(
              onChanged: (value) {
                setState(() {
                  _floorNumber = value;
                });
              },
              onPressed: () {
                if (_floorNumber != null) {
                  // Do something with the selected floor number here
                }
              },
            ),
        ],
      ),
    );
  }
}
