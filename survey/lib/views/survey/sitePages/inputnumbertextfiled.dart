import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;

class inputnumbertextfiled extends StatefulWidget {
  final String title;
  final callbacktext;
  final onChanged;

  const inputnumbertextfiled(
      {Key key, this.title, this.callbacktext, this.onChanged})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _inputnumbertextfiledState();
  }
}

class _inputnumbertextfiledState extends State<inputnumbertextfiled> {
  final TextEditingController _editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editingController.addListener(() {
      widget.callbacktext(_editingController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: new EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              widget.title,
              style: new TextStyle(fontSize: prefix0.fontsSize),
            ),
            Expanded(
              child: TextField(
                controller: _editingController,
                onChanged: (v) {
                  widget.onChanged(v);
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '请输入',
                ),
                autofocus: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
