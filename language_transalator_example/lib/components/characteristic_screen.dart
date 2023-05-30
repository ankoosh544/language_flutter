import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:language_transalator_example/components/characteristic_list_item.dart';

class CharacteristicScreen extends StatelessWidget {
  CharacteristicScreen({Key? key, required this.service, required this.device})
      : super(key: key);

  final BluetoothService service;
  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(service.uuid.toString()),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Service: ${service.uuid}'),
            subtitle: Text('Device: ${device.name}'), // Use device.name here
          ),
          Divider(),
          ...service.characteristics.map(
            (characteristic) {
              return CharacteristicListItem(
                characteristic: characteristic,
                service: service,
              );
            },
          ),
        ],
      ),
    );
  }
}
