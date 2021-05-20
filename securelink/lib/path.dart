import 'package:flutter/material.dart';

enum RootPath {
  home,
  secureLink,
  unknown,
}

class MyRouterPath {
  final RootPath rootPath;
  final String? id;
  final bool? submit;
  final bool? done;

  MyRouterPath(this.rootPath, [this.id, this.submit, this.done]);
}

class MyRouteInformationParser extends RouteInformationParser<MyRouterPath> {
  @override
  Future<MyRouterPath> parseRouteInformation(
      RouteInformation routeInformation) async {
    var uri = Uri.parse(routeInformation.location ?? '/');

    // handle home
    if (uri.pathSegments.length == 0) {
      return MyRouterPath(RootPath.home);
    }

    //detail hendle '/securelink/:id'
    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'securelink') {
      var id = uri.pathSegments[1];
      return MyRouterPath(RootPath.secureLink, id);
    }

    return MyRouterPath(RootPath.unknown);
  }

  @override
  RouteInformation? restoreRouteInformation(MyRouterPath path) {
    if (path.rootPath == RootPath.home) return RouteInformation(location: '/');

    if (path.rootPath == RootPath.secureLink)
      return RouteInformation(location: '/securelink/${path.id}');

    if (path.rootPath == RootPath.unknown)
      return RouteInformation(location: '/unknown');
    return null;
  }
}
