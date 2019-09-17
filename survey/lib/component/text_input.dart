//现场情况
import 'package:flutter/material.dart';
import 'package:sensoro_survey/views/survey/common/save_data_manager.dart';
import 'package:sensoro_survey/views/survey/common/history_page.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/model/component_configure_model.dart';

class TextInputPage extends StatefulWidget {
  componentModel model;

  TextInputPage({this.model});
  @override
  _State createState() => _State(input: this.model);
}

class _State extends State<TextInputPage> {
  componentModel input;
  String historyKey = "";
  String name = "";
  String placeHoder = "";
  String value = "";
  Map extroInfo = {};
  FocusNode blankNode = FocusNode();
  var isHighHistory = false;
  _State({this.input});

  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    name = this.input.variable_name;
    historyKey = this.input.variable_code;
    value = this.input.variable_value;
    placeHoder = this.input.placeholder;
    // placeHoder = extroInfo["placeHoder"];

    // TODO: implement initState
    if (this.value.length > 0) {
      locationController.text = this.value;
    }
    locationController.addListener(() {
      isHighHistory = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //弹出的提示框
    Container popC = new Container(
      child: Center(
        child: PopupMenuButton(
//              icon: Icon(Icons.home),
          child: Text("abc"),
          tooltip: "长按提示",
          initialValue: "hot",
          padding: EdgeInsets.all(0.0),
          itemBuilder: (BuildContext context) {
            return <PopupMenuItem<String>>[
              PopupMenuItem<String>(
                child: Text("热度"),
                value: "hot",
              ),
              PopupMenuItem<String>(
                child: Text("最新"),
                value: "new",
              ),
            ];
          },
          onSelected: (String action) {
            switch (action) {
              case "hot":
                print("热度");
                break;
              case "new":
                print("最新");
                break;
            }
          },
          onCanceled: () {
            print("onCanceled");
          },
        ),
      ),
    );

    Widget NavBar = AppBar(
      elevation: 1.0,
      centerTitle: true,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text(
        this.name,
        style: TextStyle(color: Colors.black),
      ),
      leading: Container(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            // 点击空白页面关闭键盘
            Navigator.pop(context);
          },
          child: Text(
            "取消",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      actions: <Widget>[
        Container(
          padding: new EdgeInsets.fromLTRB(0, 0, 20, 0),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              // 点击空白页面关闭键盘
              if (this.value.length > 0) {
                SaveDataManger.addHistory(this.value, historyKey);
                Navigator.of(context).pop(this.value);
              }
            },
            child: Text(
              "保存",
              style: TextStyle(
                color:
                    this.value.length > 0 ? prefix0.GREEN_COLOR : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );

    Widget bottomButton = Container(
      color: prefix0.LIGHT_LINE_COLOR,
      height: 60,
      width: prefix0.screen_width,
      child: new MaterialButton(
        color: this.value.length > 0 ? prefix0.GREEN_COLOR : Colors.grey,
        textColor: Colors.white,
        child: new Text('保存',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 20)),
        onPressed: () {
          if (this.value.length > 0) {
            SaveDataManger.addHistory(this.value, historyKey);
            Navigator.of(context).pop(this.value);
          }
        },
      ),
    );

    _editParentText(editText) {
      setState(() {
        this.value = editText;
        locationController.text = editText;
//        locationController.selection(TextSelection.fromPosition(TextPosition(
//            affinity: TextAffinity.downstream,
//            offset: this.name.length)));
//        locationController.selection(new TextSelection.fromPosition(new TextPosition()));
      });

      print(editText);
    }

    Widget container = Container(
      color: Colors.white,
      padding: new EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: locationController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: InputBorder.none,

//                  labelText: '备注',
              hintText: placeHoder,
            ),
            autofocus: false,
            onChanged: (val) {
              this.value = val;

              setState(() {});
            },
          ),
        ],
      ),
    );

    Widget backContainer = Container(
        color: Colors.white,
        padding: EdgeInsets.all(0),
//        height: 70,
        child: container);

    Widget bigContainer = Container(
      color: prefix0.LIGHT_LINE_COLOR,
      padding: new EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          backContainer,
          new Offstage(
            offstage: isHighHistory,
            child: HistoryPage(
                hisoryKey: historyKey,
                editParentText: (editText) => _editParentText(editText)),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: NavBar,
      body: GestureDetector(
        onTap: () {
          // 点击空白页面关闭键盘
          FocusScope.of(context).requestFocus(blankNode);
        },
        child: bigContainer,
      ),
    );
  }
}
