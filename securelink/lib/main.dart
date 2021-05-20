import 'package:flutter/material.dart';
import 'secure-link.dart';

void main() {
  runApp(MaterialApp(
    home: SLPage(
      title: 'Test',
      elements: [
        SLText('data 1'),
        SLText('data 2'),
        SLText('data 3'),
        SLText('data 4'),
        SLColumn([
          SLText('data 4.1'),
          SLText('data 4.2'),
          SLText('data 4.3'),
          SLText('data 4.4'),
        ])
      ],
    ),
  ));
}
