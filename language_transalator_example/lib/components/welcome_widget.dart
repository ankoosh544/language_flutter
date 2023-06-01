import 'package:flutter/material.dart';
import 'package:language_transalator_example/utils/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeWidget extends StatefulWidget {
  final Function(int)? onChanged;
  final Function()? onPressed;

  const WelcomeWidget({Key? key, this.onChanged, this.onPressed}) : super(key: key);

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
