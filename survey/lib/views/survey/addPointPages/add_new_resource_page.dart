///新增资源
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensoro_survey/net/NetService/result_data.dart';
import 'package:sensoro_survey/net/api/app_api.dart';
import 'package:sensoro_survey/net/api/net_config.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;

import '../const.dart';
import 'Model/fire_trouble_model.dart';

class AddResourcePage extends StatefulWidget {
  bool isCreate = true;
  String id;

  AddResourcePage(this.id, this.isCreate);

  @override
  _State createState() => _State();
}

class _State extends State<AddResourcePage> {
  bool isCheack = false;

  FireTroubleModel fireResourceModel =
      FireTroubleModel("", "", "fire_resource", "", "image", "", "", "", "");

  @override
  void initState() {
    super.initState();

    if (widget.isCreate) {
      fireResourceModel.prospect_id = widget.id;
    } else {
      fireResourceModel.id = widget.id;
    }
    if (!widget.isCreate) {
      getFireResourceDetail();
    }
  }

  Future creatFireResource() async {
    String urlStr = NetConfig.baseUrl + NetConfig.createProspectTaskUrl;
    Map<String, dynamic> headers = {};
    Map<String, dynamic> params = {"data": fireResourceModel.toJson()};

    print(params);

    ResultData resultData = await AppApi.getInstance()
        .post(urlStr, params: params, context: context, showLoad: true);
    if (resultData.isSuccess()) {
      // _stopLoading();

      int code = resultData.response["code"].toInt();
      if (code == 200) {
        Navigator.of(context).pop(fireResourceModel);
      }
      setState(() {});
    }
  }

  Future saveFireResource() async {
    String urlStr = NetConfig.baseUrl +
        NetConfig.updateprospectTaskurl +
        fireResourceModel.id;
    Map<String, dynamic> headers = {};
    Map<String, dynamic> params = {"data": fireResourceModel.toJson()};

    print(params);

    ResultData resultData = await AppApi.getInstance()
        .put(urlStr, params: params, context: context, showLoad: true);
    if (resultData.isSuccess()) {
      // _stopLoading();

      int code = resultData.response["code"].toInt();
      if (code == 200) {
        Navigator.of(context).pop(fireResourceModel);
      }
      setState(() {});
    }
  }

  Future getFireResourceDetail() async {
    String urlStr = NetConfig.baseUrl +
        NetConfig.prospectTaskDetailurl +
        fireResourceModel.id;
    Map<String, dynamic> headers = {};
    Map<String, dynamic> params = {};

    print(params);

    ResultData resultData = await AppApi.getInstance()
        .get(urlStr, params: params, context: context, showLoad: true);
    if (resultData.isSuccess()) {
      // _stopLoading();

      int code = resultData.response["code"].toInt();
      if (code == 200) {
        Map json = resultData.response["data"];

        fireResourceModel = FireTroubleModel.fromJson(json);
      }
      setState(() {});
    }
  }

  Future deleteTrouble() async {
    String urlStr = NetConfig.baseUrl +
        NetConfig.deleteprospectTaskurl +
        this.fireResourceModel.id;
    Map<String, dynamic> headers = {};
    Map<String, dynamic> params = {};

    print(params);

    ResultData resultData = await AppApi.getInstance()
        .delete(urlStr, params: params, context: context, showLoad: true);
    if (resultData.isSuccess()) {
      // _stopLoading();

      int code = resultData.response["code"].toInt();
      if (code == 200) {
        Navigator.of(context).pop(this.fireResourceModel);
      }
      setState(() {});
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
        widget.isCreate ? "新增资源" : "资源详情",
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
                if (widget.isCreate) {
                  creatFireResource();
                } else {
                  saveFireResource();
                }
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
                "资源类型",
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
            switch (s) {
              case "0":
                this.fireResourceModel.first_type = "消防栓";
                break;
              case "1":
                this.fireResourceModel.first_type = "灭火器";
                break;
              case "2":
                this.fireResourceModel.first_type = "防烟面罩";
                break;
              case "3":
                this.fireResourceModel.first_type = "辅助逃生";
                break;
              default:
                break;
            }
            _updateSaveState();
            setState(() {});
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
                            child: Padding(
                              padding: new EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text(
                                    "资源名称",
                                    style: new TextStyle(
                                        fontSize: prefix0.fontsSize),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: TextEditingController(
                                          text: fireResourceModel.item_name),
                                      onChanged: (v) {
                                        fireResourceModel.item_name =
                                            v.toString();
                                      },
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
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: prefix0.LINE_COLOR,
                      height: 1,
                    ),
                    popView1,
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
            child: Padding(
              padding: new EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new SizedBox(
                    height: 10,
                  ),
                  Text("资源描述",
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
                      border:
                          new Border.all(color: LIGHT_TEXT_COLOR, width: 0.5),
                    ),
                    child: TextField(
                      onSubmitted: (String str) {},
                      textAlign: TextAlign.start,
                      minLines: 1,
                      controller: TextEditingController(
                          text: fireResourceModel.description),
                      maxLines: 10,
                      style: new TextStyle(
                        fontSize: 13.0,
                        color: prefix0.BLACK_TEXT_COLOR,
                      ),
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        hintText: "点击输入",
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    Widget delete = new Offstage(
      offstage: widget.isCreate ? true : false,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () {
            deleteTrouble();
          },
          child: Container(
            color: Colors.red,
            height: 40,
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                "删除",
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
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
      bottomSheet: delete,
    );
  }

  _updateSaveState() {
    if (fireResourceModel.item_name.length > 0 &&
        fireResourceModel.danger_level.length > 0 &&
        fireResourceModel.first_type.length > 0) {
      this.isCheack = true;
    } else {
      this.isCheack = false;
    }
  }
}
