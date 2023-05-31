import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:language_transalator_example/components/service_list_item.dart';
import 'package:language_transalator_example/utils/session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/connection_status_widget.dart';

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
  bool isAudioEnabled = false;
  bool isVisualEnabled = false;

  final String deviceType = "ESP32";

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
    });
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
          isAudioEnabled = false;
          isVisualEnabled = false;
          connectButtonText = 'Connect';
        });
        Map<String, dynamic> settings = await SessionManager.getSettings();
        if (settings['isAudioEnabled'] && !isAudioEnabled) {
          flutterTts.speak(AppLocalizations.of(context)!.bledisc);
        }
        if (settings['isVisualEnabled'] && !isVisualEnabled) {
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
        debugPrint("==============audio=================================");
        debugPrint(isAudioEnabled.toString());
        debugPrint("===================visual============================");
        debugPrint(isVisualEnabled.toString());
        if (settings['isAudioEnabled'] && !isAudioEnabled) {
          flutterTts.speak(AppLocalizations.of(context)!.blec);
        }
        if (settings['isVisualEnabled'] && !isVisualEnabled) {
          showSuccessWindowBox(AppLocalizations.of(context)!.blec);
        }
        setState(() {
          isAudioEnabled = true;
          isVisualEnabled = true;
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
            {
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
            },
        ],
      ),
    );
  }
}

class WelcomeWidget extends StatefulWidget {
  final Function(int)? onChanged;
  final Function()? onPressed;

  const WelcomeWidget({Key? key, this.onChanged, this.onPressed})
      : super(key: key);

  @override
  _WelcomeWidgetState createState() => _WelcomeWidgetState();
}

class _WelcomeWidgetState extends State<WelcomeWidget> {
  String? userName;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    loadProfileData();
  }

  Future<void> loadProfileData() async {
    userName = await SessionManager.getUsername();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString('username');
    });
  }

  @override
  Widget build(BuildContext context) {
    print(userName);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Welcome  ' + userName.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(int.tryParse(value) ?? -1);
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter Floor Number',
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: widget.onPressed,
          child: Text('Confirm'),
        ),
      ],
    );
  }
}
