///新增资源
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensoro_survey/net/NetService/result_data.dart';
import 'package:sensoro_survey/net/api/app_api.dart';
import 'package:sensoro_survey/net/api/net_config.dart';
import 'package:sensoro_survey/views/survey/commonWidegt/inputnumbertextfiled.dart';
import 'package:sensoro_survey/views/survey/commonWidegt/remarktextfiled.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/sitePages/Model/fire_resource_model.dart';

import 'Model/PointListModel.dart';
import 'Model/fire_trouble_model.dart';

class AddNewTroublePage extends StatefulWidget {
  PointListModel input;
  bool isCreate = true;
  AddNewTroublePage(this.input,this.isCreate);
  @override
  _State createState() => _State();
}

class _State extends State<AddNewTroublePage> {
  bool isCheack = false;

  FireTroubleModel fireResourceModel = FireTroubleModel("", "fire_danger", "", "image", "", "", "", "");

  @override
  void initState() {
    super.initState();
    fireResourceModel.prospect_id = widget.input.id;
  }

  Future creatFireResource() async {

    String urlStr =NetConfig.baseUrl + NetConfig.createProspectTaskUrl;
    Map<String, dynamic> headers = {};
    Map<String, dynamic> params = {"data":fireResourceModel.toJson()};

    print(params);

    ResultData resultData = await AppApi.getInstance()
        .post(urlStr,params: params,context: context,showLoad: true);
    if (resultData.isSuccess()) {
      // _stopLoading();

      int code = resultData.response["code"].toInt();
      if (code == 200) {

        Navigator.of(context).pop();

      }
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget NavBar = AppBar(
      elevation: 1.0,
      centerTitle: true,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text(
        "新增隐患",
        style: TextStyle(color: Colors.black),
      ),
      leading: Container(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
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
                creatFireResource();
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
                "隐患程度",
                style: new TextStyle(fontSize: prefix0.fontsSize),
              ),
              Expanded(
                child: Text(
                  fireResourceModel.danger_level,
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
                child: Text("轻危"),
                value: "0",
              ),
              PopupMenuItem<String>(
                child: Text("中危"),
                value: "1",
              ),
              PopupMenuItem<String>(
                child: Text("高危"),
                value: "2",
              ),
            ];
          },
          onSelected: (String s) {
            switch (s) {
              case "0":
                this.fireResourceModel.danger_level = "轻危";
                break;
              case "1":
                this.fireResourceModel.danger_level = "中危";
                break;
              case "2":
                this.fireResourceModel.danger_level = "高危";
                break;
              default:
                break;
            }
            _updateSaveState();
            setState(() {

            });
          },
          onCanceled: () {
            print("onCanceled");
          },
        ),
      ),
    );

    Container popView1 = new Container(
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
                "隐患类型",
                style: new TextStyle(fontSize: prefix0.fontsSize),
              ),
              Expanded(
                child: Text(
                  fireResourceModel.first_type,
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
                child: Text("违规用电"),
                value: "0",
              ),
              PopupMenuItem<String>(
                child: Text("疏散逃生"),
                value: "1",
              ),
              PopupMenuItem<String>(
                child: Text("易燃易爆"),
                value: "2",
              ),
              PopupMenuItem<String>(
                child: Text("安全标识"),
                value: "3",
              ),
            ];
          },
          onSelected: (String s) {
            switch (s) {
              case "0":
                this.fireResourceModel.first_type = "易燃易爆品";
                break;
              case "1":
                this.fireResourceModel.first_type = "电箱隐患";
                break;
              case "2":
                this.fireResourceModel.first_type = "易燃易爆";
                break;
              case "3":
                this.fireResourceModel.first_type = "安全标识";
                break;
              default:
                break;
            }
            _updateSaveState();
            setState(() {

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
                              title: "隐患名称",
                              intputtype: 0,
                              onChanged: (text) {
                                _updateSaveState();
                                this.fireResourceModel.item_name = text;
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
                    popView1,
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
    if (fireResourceModel.item_name.length > 0 &&
        fireResourceModel.danger_level.length>0&&fireResourceModel.first_type.length>0) {
      this.isCheack = true;
    } else {
      this.isCheack = false;
    }
  }
}
