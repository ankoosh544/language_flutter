import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:language_transalator_example/components/characteristic_screen.dart';

class ServiceListItem extends StatelessWidget {
  const ServiceListItem({
    Key? key,
    required this.service,
    required this.device, // Add device property
  }) : super(key: key);

  final BluetoothService service;
  final BluetoothDevice device; // Add device property

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CharacteristicScreen(
              service: service,
              device: device, // Pass the device object here
            ),
          ),
        );
      },
      title: Text(service.uuid.toString()),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (BluetoothCharacteristic characteristic
              in service.characteristics)
            Text(
              'UUID: ${characteristic.uuid.toString()}\nProperties: ${_getPropertiesString(characteristic.properties)}',
            ),
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
