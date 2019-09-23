///新增资源
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensoro_survey/views/survey/commonWidegt/inputnumbertextfiled.dart';
import 'package:sensoro_survey/views/survey/commonWidegt/remarktextfiled.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/sitePages/Model/fire_resource_model.dart';

class AddNewFireResourcePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<AddNewFireResourcePage> {
  bool isCheack = false;

  FireResourceModel fireResourceModel = FireResourceModel("", "", "", "", "");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget NavBar = AppBar(
      elevation: 1.0,
      centerTitle: true,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text(
        "新增资源",
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
              if (this.isCheack) {
//                Navigator.of(context).pop(this.sitePageModel);
              }
            },
            child: Text(
              "保存",
              style: TextStyle(
                color: this.isCheack ? prefix0.GREEN_COLOR : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );

    Container popView = new Container(
      alignment: Alignment.center,
      height: 60,
      child: Center(
        child: PopupMenuButton(
          child: new Row(
            children: <Widget>[
              Text(
                "*",
                style: TextStyle(color: Colors.red),
              ),
              Text(
                "资源类型",
                style: new TextStyle(fontSize: prefix0.fontsSize),
              ),
              Expanded(
                child: Text(
                  fireResourceModel.resourceType,
                  textAlign: TextAlign.right,
                  style: new TextStyle(fontSize: prefix0.fontsSize),
                ),
              ),
              Image.asset(
                "assets/images/right_arrar.png",
                width: 20,
              )
            ],
          ),
          offset: Offset(0.2, 0),
          padding: EdgeInsets.only(top: 0.0, bottom: 0, left: 100, right: 0),
          itemBuilder: (BuildContext context) {
            return <PopupMenuItem<String>>[
              PopupMenuItem<String>(
                child: Text("消防栓"),
                value: "0",
              ),
              PopupMenuItem<String>(
                child: Text("灭火器"),
                value: "1",
              ),
              PopupMenuItem<String>(
                child: Text("防烟面罩"),
                value: "2",
              ),
              PopupMenuItem<String>(
                child: Text("辅助逃生"),
                value: "3",
              ),
            ];
          },
          onSelected: (String s) {
            setState(() {
              switch (s) {
                case "0":
                  this.fireResourceModel.resourceType = "消防栓";
                  break;
                case "1":
                  this.fireResourceModel.resourceType = "灭火器";
                  break;
                case "2":
                  this.fireResourceModel.resourceType = "防烟面罩";
                  break;
                case "3":
                  this.fireResourceModel.resourceType = "辅助逃生";
                  break;
                default:
                  _updateSaveState();

                  break;
              }
            });
          },
          onCanceled: () {
            print("onCanceled");
          },
        ),
      ),
    );

    Widget container = Container(
      color: Colors.white,
      child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,

        children: <Widget>[
          Padding(
              padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Container(
                      height: 60,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "*",
                            style: TextStyle(color: Colors.red),
                          ),
                          Expanded(
                            child: inputnumbertextfiled(
                              title: "资源名称",
                              intputtype: 0,
                              onChanged: (text) {
                                _updateSaveState();
                                this.fireResourceModel.resourceName = text;
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: prefix0.LINE_COLOR,
                      height: 1,
                    ),
                    popView,
                  ])),
          Padding(
            padding: new EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Container(
              color: prefix0.LINE_COLOR,
              height: 10,
            ),
          ),
          Padding(
            padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: remarktextfiled(
              title: "资源描述：",
              callbacktext: (text) {
                print(text + "资源描述：");
              },
            ),
          ),
        ],
      ),
    );

    Widget bigContainer = Container(
      color: prefix0.LIGHT_LINE_COLOR,
      padding: new EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: new ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: container,
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: NavBar,
      body: bigContainer,
    );
  }

  _updateSaveState() {
    if (fireResourceModel.resourceType.length > 0 &&
        fireResourceModel.resourceName.length > 0) {
      this.isCheack = true;
    } else {
      this.isCheack = false;
    }
  }
}
