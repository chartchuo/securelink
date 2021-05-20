import 'package:flutter/material.dart';
import 'router.dart';
import 'path.dart';

void main() {
  runApp(MaterialApp.router(
    routeInformationParser: MyRouteInformationParser(),
    routerDelegate: MyRouter(),
  ));
}
