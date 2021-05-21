import 'package:flutter/material.dart';
import 'package:securelink/secure_link.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<String> onSelect;

  const HomeScreen({Key? key, required this.onSelect}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              Image.network(
                  'http://sitem.co.th/wp-content/uploads/2016/02/ktb-logo-1.jpg'),
              ElevatedButton(
                child: Text('Secure Link to KPI'),
                onPressed: () {
                  widget.onSelect('kpi');
                },
              ),
              ElevatedButton(
                child: Text('Secure Link to Krung Thai AXA'),
                onPressed: () {
                  widget.onSelect('axa');
                },
              ),
              ElevatedButton(
                child: Text('Secure Link to KTC'),
                onPressed: () {
                  widget.onSelect('ktc');
                },
              ),
            ],
          ),
        ),
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
