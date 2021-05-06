import 'package:flutter/material.dart';

class RemoteScreen extends StatelessWidget {
  final String? title;
  final List<RsElement>? elements;

  const RemoteScreen({Key? key, required this.title, required this.elements})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title ?? '')),
      body: Column(
        children: elements ?? [],
      ),
    );
  }
}

abstract class RsElement extends StatelessWidget {
  String get type;
  bool get isAction => false;
}

class RsText extends RsElement {
  @override
  String get type => 'Text';

  final String data;

  RsText(this.data);

  @override
  Widget build(BuildContext context) {
    return Text(data);
  }
}

class RsColumn extends RsElement {
  RsColumn(this.children);

  @override
  String get type => 'Column';

  final List<RsElement> children;

  @override
  Widget build(BuildContext context) {
    return Column(children: children);
  }
}
