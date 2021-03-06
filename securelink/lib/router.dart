import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:securelink/state.dart';
import 'path.dart';

import 'screen.dart';

import 'package:dart_nats/dart_nats.dart' as nats;

var json = jsonDecode('');

class MyRouter extends RouterDelegate<MyRouterPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyRouterPath> {
  final GlobalKey<NavigatorState> _navigatorKey;
  var _myRouterPath = MyRouterPath(RootPath.home);

  var natsClient = nats.Client();
  String provider = 'kpi';

  MaterialPage homePage() {
    return MaterialPage(
        key: ValueKey('homePage'),
        child: HomeScreen(onSelect: (p) async {
          provider = p;
          setNewRoutePath(MyRouterPath(RootPath.secureLink, '0'));
        }));
  }

  MaterialPage<String> secureLinkPage() {
    return MaterialPage<String>(
      key: ValueKey('secureLinkPage${_myRouterPath.id}'),
      maintainState: false,
      child: SecureLinkScreen(json: json),
    );
  }

  MaterialPage unknownPage() {
    return MaterialPage(
      key: ValueKey('UnknownPage'),
      child: UnknownScreen(),
    );
  }

  MyRouter() : _navigatorKey = GlobalKey<NavigatorState>() {
    natsClient.connect(Uri.parse('ws://10.0.2.2:80'));
    // natsClient.connect(Uri.parse('ws://localhost:80'));
  }

  @override
  MyRouterPath get currentConfiguration => _myRouterPath;

  @override
  Widget build(BuildContext context) {
    List<Page> pageStack;
    switch (_myRouterPath.rootPath) {
      case RootPath.home:
        pageStack = [homePage()];
        break;
      case RootPath.secureLink:
        pageStack = [homePage(), secureLinkPage()];
        break;
      case RootPath.unknown:
        pageStack = [unknownPage()];
        break;
    }

    return Navigator(
      key: _navigatorKey,
      pages: pageStack,
      onPopPage: (route, result) {
        print('Pop value $result');
        if (result is MyRouterPath) {
          setNewRoutePath(result);
        } else {
          // back button
          state = {};
        }
        return route.didPop(result);
      },
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(MyRouterPath path) async {
    if (path.done == true) {
      _myRouterPath = MyRouterPath(RootPath.home);
      notifyListeners();
      return;
    }
    _myRouterPath = path;
    String submitText = '';
    if (path.submit == true) submitText = state.toString();
    var msg =
        await natsClient.requestString('$provider.${path.id}', submitText);
    print(msg.string);
    json = jsonDecode(msg.string);
    notifyListeners();
  }
}
