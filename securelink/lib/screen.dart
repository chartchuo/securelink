import 'package:flutter/material.dart';
import 'package:securelink/secure_link.dart';

class HomeScreen extends StatefulWidget {
  final Function onSelect;

  const HomeScreen({Key? key, required this.onSelect}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
            child: Text('Go to Secure Link'),
            onPressed: () {
              widget.onSelect();
            },
          ),
        ],
      ),
    );
  }
}

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('Unknown Page'),
        ],
      ),
    );
  }
}

class SecureLinkScreen extends StatelessWidget {
  final Map<String, dynamic> json;

  const SecureLinkScreen({Key? key, required this.json}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return fromJson(json);
  }
}
