import 'dart:convert';

import 'package:flutter/material.dart';
import 'path.dart';

import 'screen.dart';

import 'package:dart_nats/dart_nats.dart' as nats;

var json = jsonDecode('''
{
    "type": "page",
    "title": "test",
    "home": {
        "type": "column",
        "children": [
            {
                "type": "text",
                "text": "line1"
            },
            {
                "type": "textField",
                "id": "textField1"
            },
            {
                "type": "button",
                "text": "Submit"
            }
        ]
    }
}
      ''');

class MyRouter extends RouterDelegate<MyRouterPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyRouterPath> {
  final GlobalKey<NavigatorState> _navigatorKey;
  var _myRouterPath = MyRouterPath(RootPath.home);

  var 
  var natsClient = nats.Client();

  MaterialPage homePage() {
    return MaterialPage(
        key: ValueKey('homePage'),
        child: HomeScreen(onSelect: () async {
          var msg = await natsClient.requestString('kpi', '0');
          print(msg.string);
          setNewRoutePath(MyRouterPath(RootPath.secureLink, 0));
        }));
  }

  MaterialPage<String> secureLinkPage()  {
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
    natsClient.connect("10.0.2.2");
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
        return route.didPop(result);
      },
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(MyRouterPath path) async {
    _myRouterPath = path;

    notifyListeners();
  }
}
