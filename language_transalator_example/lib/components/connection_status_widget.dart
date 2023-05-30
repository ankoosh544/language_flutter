import 'package:flutter/material.dart';

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
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Status: $stateText',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            child: Text(connectButtonText),
          ),
        ],
      ),
    );
  }
}
