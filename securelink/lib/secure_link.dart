import 'package:flutter/material.dart';
import 'state.dart';

abstract class SLElement extends StatelessWidget {
  String get type;
}

SLElement fromJson(Map<String, dynamic> json) {
  String type = json['type'];
  switch (type) {
    case 'page':
      return SLPage.fromJson(json);
    case 'column':
      return SLColumn.fromJson(json);
    case 'text':
      return SLText.fromJson(json);
    case 'textField':
      return SLTextField.fromJson(json);
    case 'button':
      return SLButton.fromJson(json);
  }
  return SLText('unimplement');
}

class SLPage extends SLElement {
  @override
  String get type => 'page';

  final String title;
  final SLElement home;

  SLPage(this.title, this.home);
  factory SLPage.fromJson(Map<String, dynamic> json) {
    String title = json['title'];
    SLElement home = fromJson(json['home']);
    return SLPage(title, home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: home,
    );
  }
}

class SLText extends SLElement {
  @override
  String get type => 'text';

  final String text;

  SLText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }

  factory SLText.fromJson(Map<String, dynamic> json) {
    String text = json['text'];
    return SLText(text);
  }
}

class SLColumn extends SLElement {
  SLColumn(this.children);

  @override
  String get type => 'column';

  final List<SLElement> children;

  @override
  Widget build(BuildContext context) {
    return Column(children: children);
  }

  factory SLColumn.fromJson(Map<String, dynamic> json) {
    var c = SLColumn([]);
    json['children'].forEach((v) {
      c.children.add(fromJson(v));
    });

    return c;
  }
}

class SLTextField extends SLElement {
  @override
  String get type => 'textField';

  final String id;

  SLTextField(this.id);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        state[this.id] = value;
      },
    );
  }

  factory SLTextField.fromJson(Map<String, dynamic> json) {
    String id = json['id'];
    return SLTextField(id);
  }
}

class SLButton extends SLElement {
  @override
  String get type => 'button';

  final String text;

  SLButton(this.text);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(text),
      onPressed: () {
        print(state);
      },
    );
  }

  factory SLButton.fromJson(Map<String, dynamic> json) {
    return SLButton(json['text']);
  }
}
