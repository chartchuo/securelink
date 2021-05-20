import 'package:flutter/material.dart';

class SLPage extends StatelessWidget {
  final String? title;
  final List<SLElement>? elements;

  const SLPage({Key? key, required this.title, required this.elements})
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

abstract class SLElement extends StatelessWidget {
  String get type;
  bool get isAction => false;
}

class SLText extends SLElement {
  @override
  String get type => 'Text';

  final String data;

  SLText(this.data);

  @override
  Widget build(BuildContext context) {
    return Text(data);
  }
}

class SLColumn extends SLElement {
  SLColumn(this.children);

  @override
  String get type => 'Column';

  final List<SLElement> children;

  @override
  Widget build(BuildContext context) {
    return Column(children: children);
  }
}
