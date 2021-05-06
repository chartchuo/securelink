import 'package:flutter/material.dart';
import 'package:securelink/remotescreen.dart';

void main() {
  runApp(MaterialApp(
    home: RemoteScreen(
      title: 'Test',
      elements: [
        RsText('data 1'),
        RsText('data 2'),
        RsText('data 3'),
        RsText('data 4'),
        RsColumn([
          RsText('data 4.1'),
          RsText('data 4.2'),
          RsText('data 4.3'),
          RsText('data 4.4'),
        ])
      ],
    ),
  ));
}
