import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;

import '../const.dart';

class remarktextfiled extends StatefulWidget {
  final callbacktext;

  const remarktextfiled({Key key, this.callbacktext}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _remarktextfiledState();
  }
}

class _remarktextfiledState extends State<remarktextfiled> {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new SizedBox(
              height: 10,
            ),
            Text("备注",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: prefix0.LIGHT_TEXT_COLOR,
                    fontWeight: FontWeight.normal,
                    fontSize: 17)),
            new SizedBox(
              height: 15,
            ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: new Border.all(color: LIGHT_TEXT_COLOR, width: 0.5),
              ),
              child: TextField(
                onSubmitted: (String str) {},
                textAlign: TextAlign.start,
                minLines: 1,
                controller: _editingController,
                maxLines: 10,
                style: new TextStyle(
                  fontSize: 13.0,
                  color: prefix0.BLACK_TEXT_COLOR,
                ),
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  hintText: "点击输入",
                  contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
