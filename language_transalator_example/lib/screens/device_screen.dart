// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:language_transalator_example/utils/session_manager.dart';

// class DeviceScreen extends StatefulWidget {
//   DeviceScreen({Key? key, required this.device}) : super(key: key);

//   final BluetoothDevice device;

//   @override
//   _DeviceScreenState createState() => _DeviceScreenState();
// }

// class _DeviceScreenState extends State<DeviceScreen> {
//   FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
//   FlutterTts flutterTts = FlutterTts();

//   String stateText = 'Connecting';
//   String connectButtonText = 'Connect';
//   BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;
//   StreamSubscription<BluetoothDeviceState>? _stateListener;
//   List<BluetoothService> bluetoothService = [];
//   bool isConnectionAudioPlayed = false; // Added flag to track connection audio

//   @override
//   void initState() {
//     super.initState();
//     _stateListener = widget.device.state.listen((event) {
//       debugPrint('event: $event');
//       if (deviceState == event) {
//         return;
//       }

//       setBleConnectionState(event);
//     });

//     connect();
//   }

//   @override
//   void dispose() {
//     _stateListener?.cancel();
//     disconnect();
//     super.dispose();
//   }

//   setBleConnectionState(BluetoothDeviceState event) async {
//     setState(() {
//       deviceState = event;
//     });

//     switch (event) {
//       case BluetoothDeviceState.disconnected:
//         setState(() {
//           stateText = 'Disconnected';
//           connectButtonText = 'Connect';
//         });
//         Map<String, dynamic> settings = await SessionManager.getSettings();
//         if (settings['isAudioEnabled']) {
//           flutterTts.speak("Bluetooth disconnected");
//         }
//         break;
//       case BluetoothDeviceState.disconnecting:
//         setState(() {
//           stateText = 'Disconnecting';
//         });
//         break;
//       case BluetoothDeviceState.connected:
//         setState(() {
//           stateText = 'Connected';
//           connectButtonText = 'Disconnect';
//         });
//         Map<String, dynamic> settings = await SessionManager.getSettings();
//         if (settings['isAudioEnabled'] && !isConnectionAudioPlayed) {
//           flutterTts.speak("Bluetooth connected");
//           isConnectionAudioPlayed = true;
//         }
//         break;
//       case BluetoothDeviceState.connecting:
//         setState(() {
//           stateText = 'Connecting';
//         });
//         break;
//     }
//   }

//   Future<bool> connect() async {
//     setState(() {
//       stateText = 'Connecting';
//     });

//     try {
//       await widget.device
//           .connect(autoConnect: false)
//           .timeout(Duration(milliseconds: 15000), onTimeout: () {
//         debugPrint('timeout failed');
//         setBleConnectionState(BluetoothDeviceState.disconnected);
//         return false;
//       });

//       setState(() {
//         stateText = 'Connected';
//         connectButtonText = 'Disconnect';
//       });

//       bluetoothService.clear();
//       List<BluetoothService> bleServices =
//           await widget.device.discoverServices();
//       setState(() {
//         bluetoothService = bleServices;
//       });

//       return true;
//     } catch (e) {
//       debugPrint('connection failed: $e');
//       setBleConnectionState(BluetoothDeviceState.disconnected);
//       return false;
//     }
//   }

//   void disconnect() {
//     setState(() {
//       stateText = 'Disconnecting';
//     });
//     widget.device.disconnect();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.device.name),
//       ),
//       body: Column(
//         children: [
//           ConnectionStatusWidget(
//               stateText: stateText,
//               connectButtonText: connectButtonText,
//               onPressed: () {
//                 if (deviceState == BluetoothDeviceState.connected) {
//                   disconnect();
//                 } else if (deviceState == BluetoothDeviceState.disconnected) {
//                   connect();
//                 }
//               }),
//           Expanded(
//             child: ListView.separated(
//               itemCount: bluetoothService.length,
//               itemBuilder: (context, index) {
//                 return ServiceListItem(service: bluetoothService[index]);
//               },
//               separatorBuilder: (BuildContext context, int index) {
//                 return Divider();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ConnectionStatusWidget extends StatelessWidget {
//   const ConnectionStatusWidget({
//     Key? key,
//     required this.stateText,
//     required this.connectButtonText,
//     required this.onPressed,
//   }) : super(key: key);

//   final String stateText;
//   final String connectButtonText;
//   final VoidCallback onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         Text(stateText),
//         OutlinedButton(
//           onPressed: onPressed,
//           child: Text(connectButtonText),
//         ),
//       ],
//     );
//   }
// }

// class ServiceListItem extends StatelessWidget {
//   const ServiceListItem({
//     Key? key,
//     required this.service,
//   }) : super(key: key);

//   final BluetoothService service;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: null,
//       title: Text(service.uuid.toString()),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           for (BluetoothCharacteristic characteristic
//               in service.characteristics)
//             Text(
//                 'UUID: ${characteristic.uuid.toString()}\nProperties: ${_getPropertiesString(characteristic.properties)}'),
//         ],
//       ),
//     );
//   }

//   String _getPropertiesString(CharacteristicProperties properties) {
//     List<String> propertyList = [];
//     if (properties.write) propertyList.add('Write');
//     if (properties.read) propertyList.add('Read');
//     if (properties.notify) propertyList.add('Notify');
//     if (properties.writeWithoutResponse) propertyList.add('WriteWR');
//     if (properties.indicate) propertyList.add('Indicate');

//     return propertyList.join(', ');
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:language_transalator_example/utils/session_manager.dart';

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
  bool isConnectionAudioPlayed = false; // Added flag to track connection audio

  BluetoothCharacteristic? sensorCharacteristic;
  StreamSubscription<List<int>>? _dataSubscription;

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

    connect();
  }

  @override
  void dispose() {
    _stateListener?.cancel();
    _dataSubscription?.cancel(); // Cancel data subscription
    disconnect();
    super.dispose();
  }

  setBleConnectionState(BluetoothDeviceState event) async {
    setState(() {
      deviceState = event;
    });

    switch (event) {
      case BluetoothDeviceState.disconnected:
        setState(() {
          stateText = 'Disconnected';
          connectButtonText = 'Connect';
        });
        Map<String, dynamic> settings = await SessionManager.getSettings();
        if (settings['isAudioEnabled']) {
          flutterTts.speak("Bluetooth disconnected");
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
        Map<String, dynamic> settings = await SessionManager.getSettings();
        if (settings['isAudioEnabled'] && !isConnectionAudioPlayed) {
          flutterTts.speak("Bluetooth connected");
          isConnectionAudioPlayed = true;
        }
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

    try {
      await widget.device
          .connect(autoConnect: false)
          .timeout(Duration(milliseconds: 15000), onTimeout: () {
        debugPrint('timeout failed');
        setBleConnectionState(BluetoothDeviceState.disconnected);
        return false;
      });

      setState(() {
        stateText = 'Connected';
        connectButtonText = 'Disconnect';
      });

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
          if (characteristic == true) {
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
              }),
          Expanded(
            child: ListView.separated(
              itemCount: bluetoothService.length,
              itemBuilder: (context, index) {
                return ServiceListItem(service: bluetoothService[index]);
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ConnectionStatusWidget extends StatelessWidget {
  const ConnectionStatusWidget({
    Key? key,
    required this.stateText,
    required this.connectButtonText,
    required this.onPressed,
  }) : super(key: key);

  final String stateText;
  final String connectButtonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(stateText),
        OutlinedButton(
          onPressed: onPressed,
          child: Text(connectButtonText),
        ),
      ],
    );
  }
}

class ServiceListItem extends StatelessWidget {
  const ServiceListItem({
    Key? key,
    required this.service,
  }) : super(key: key);

  final BluetoothService service;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: null,
      title: Text(service.uuid.toString()),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (BluetoothCharacteristic characteristic
              in service.characteristics)
            Text(
                'UUID: ${characteristic.uuid.toString()}\nProperties: ${_getPropertiesString(characteristic.properties)}'),
        ],
      ),
    );
  }

  String _getPropertiesString(CharacteristicProperties properties) {
    List<String> propertyList = [];
    if (properties.write) propertyList.add('Write');
    if (properties.read) propertyList.add('Read');
    if (properties.notify) propertyList.add('Notify');
    if (properties.writeWithoutResponse) propertyList.add('WriteWR');
    if (properties.indicate) propertyList.add('Indicate');

    return propertyList.join(', ');
  }
}
