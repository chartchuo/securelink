import 'package:flutter/material.dart';
import 'package:securelink/path.dart';
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
    case 'row':
      return SLRow.fromJson(json);
    case 'text':
      return SLText.fromJson(json);
    case 'textField':
      return SLTextField.fromJson(json);
    case 'button':
      return SLButton.fromJson(json);
    case 'link':
      return SLLink.fromJson(json);
    case 'submit':
      return SLSubmit.fromJson(json);
    case 'done':
      return SLDone.fromJson(json);
  }
  return SLText('unimplement');
}

class SLPage extends SLElement {
  @override
  String get type => 'page';

  final String title;
  final SLElement body;

  SLPage(this.title, this.body);
  factory SLPage.fromJson(Map<String, dynamic> json) {
    String title = json['title'];
    SLElement body = fromJson(json['body']);
    return SLPage(title, body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: body,
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

class SLRow extends SLElement {
  SLRow(this.children);

  @override
  String get type => 'row';

  final List<SLElement> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: children,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }

  factory SLRow.fromJson(Map<String, dynamic> json) {
    var c = SLRow([]);
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
  final String hintText;

  SLTextField(this.id, this.hintText);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hintText,
      ),
      onChanged: (value) {
        state[this.id] = value;
      },
    );
  }

  factory SLTextField.fromJson(Map<String, dynamic> json) {
    String id = json['id'];
    String hintText = json['hintText'] ?? '';
    return SLTextField(id, hintText);
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

class SLLink extends SLElement {
  @override
  String get type => 'link';

  final String text;
  final String to;

  SLLink(this.text, this.to);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(text),
      onPressed: () {
        Navigator.pop(context, MyRouterPath(RootPath.secureLink, to));
      },
    );
  }

  factory SLLink.fromJson(Map<String, dynamic> json) {
    return SLLink(json['text'], json['to']);
  }
}

class SLSubmit extends SLElement {
  @override
  String get type => 'submit';

  final String text;
  final String to;

  SLSubmit(this.text, this.to);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(text),
      onPressed: () {
        Navigator.pop(context, MyRouterPath(RootPath.secureLink, to, true));
      },
    );
  }

  factory SLSubmit.fromJson(Map<String, dynamic> json) {
    return SLSubmit(json['text'], json['to']);
  }
}

class SLDone extends SLElement {
  @override
  String get type => 'submit';

  final String text;

  SLDone(this.text);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(text),
      onPressed: () {
        Navigator.pop(
            context, MyRouterPath(RootPath.secureLink, '', false, true));
      },
    );
  }

  factory SLDone.fromJson(Map<String, dynamic> json) {
    return SLDone(json['text']);
  }
}
