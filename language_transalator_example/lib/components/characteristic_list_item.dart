import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class CharacteristicListItem extends StatelessWidget {
  const CharacteristicListItem({
    Key? key,
    required this.characteristic,
    required this.service,
  }) : super(key: key);

  final BluetoothCharacteristic characteristic;
  final BluetoothService service; // Add service property

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Characteristic: ${characteristic.uuid}'),
      subtitle: Text('Service: ${service.uuid}'), // Use service.uuid here
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        // Perform actions on the selected characteristic
      },
    );
  }
}
