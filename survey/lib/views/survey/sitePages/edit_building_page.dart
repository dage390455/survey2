//现场情况
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensoro_survey/net/api/app_api.dart';
import 'package:sensoro_survey/net/api/net_config.dart';
import 'package:sensoro_survey/views/survey/commonWidegt/remarktextfiled.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/sitePages/Model/SitePageModel.dart';

class EditbuildingPage extends StatefulWidget {
  String id = "";

  String parent_id = "";

  EditbuildingPage(this.id, this.parent_id);

  SitePageModel sitePageModel = SitePageModel.building(
      "", "", "", "building", "", "", "", 0.0, ",", "", 0, 0, "", "", "", "");

  @override
  _State createState() => _State(sitePageModel);
}

class _State extends State<EditbuildingPage> {
  BasicMessageChannel<String> _basicMessageChannel =
      BasicMessageChannel("BasicMessageChannelPlugin", StringCodec());
  SitePageModel sitePageModel;

  bool isCheack = false;

  _State(this.sitePageModel);

  @override
  void initState() {
    _basicMessageChannel.setMessageHandler((message) => Future<String>(() {
          print(message);
          //message为native传递的数据
          if (message != null && message.isNotEmpty) {
            List list = message.split(",");
            if (list.length == 3) {
              sitePageModel.location = list[0] + "," + list[1];
              sitePageModel.address = list[2];
              _updateSaveState();
              setState(() {});
            }
          }
          //给Android端的返回值
          return "========================收到Native消息：" + message;
        }));
    getBuildingDetail();
    super.initState();
  }

  //向native发送消息
  void _sendToNative() {
    var location = "0," + sitePageModel.location + "," + sitePageModel.address;

    Future<String> future = _basicMessageChannel.send(location);
    future.then((message) {
      print("========================" + message);
    });
  }

  ///详情
  Future getBuildingDetail() async {
    String urlStr = NetConfig.baseUrl + NetConfig.getSiteUrl + widget.id;
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

        sitePageModel = SitePageModel.fromDetailJson(json);
        _updateSaveState();
        setState(() {});
      }
    }
  }

  Future saveBuilding() async {
    String urlStr =
        NetConfig.baseUrl + NetConfig.editeUrl + this.sitePageModel.id;
    Map<String, dynamic> headers = {};
    Map<String, dynamic> params = {"data": sitePageModel.toBuildJson()};

    print(params);

    ResultData resultData = await AppApi.getInstance()
        .put(urlStr, params: params, context: context, showLoad: true);
    if (resultData.isSuccess()) {
      // _stopLoading();

      int code = resultData.response["code"].toInt();
      if (code == 200) {
        Navigator.of(context).pop(this.sitePageModel);
      }
      setState(() {});
    }
  }

  Future deleteBuilding() async {
    String urlStr =
        NetConfig.baseUrl + NetConfig.deleteSiteUrl + this.sitePageModel.id;
    Map<String, dynamic> headers = {};
    Map<String, dynamic> params = {};

    print(params);

    ResultData resultData = await AppApi.getInstance()
        .delete(urlStr, params: params, context: context, showLoad: true);
    if (resultData.isSuccess()) {
      // _stopLoading();

      int code = resultData.response["code"].toInt();
      if (code == 200) {
        Navigator.of(context).pop(this.sitePageModel);
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
        "建筑详情",
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
                saveBuilding();
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

    editLoction() async {
      _sendToNative();
    }

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
                Padding(
                    padding: new EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                                          "建筑名称",
                                          style: new TextStyle(
                                              fontSize: prefix0.fontsSize),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: TextEditingController(
                                                text: sitePageModel.name),
                                            onChanged: (v) {
                                              sitePageModel.name = v;
                                            },

                                            //只允许输入数字
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
                        ])),
                Container(
                  color: prefix0.LINE_COLOR,
                  height: 1,
                ),
                GestureDetector(
                  onTap: editLoction, //写入方法名称就可以了，但是是无参的
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    child: new Row(
                      children: <Widget>[
                        Text(
                          "建筑位置",
                          style: new TextStyle(fontSize: prefix0.fontsSize),
                        ),
                        Expanded(
                          child: Text(
                            sitePageModel.address.toString(),
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
                  ),
                ),
                Container(
                  color: prefix0.LINE_COLOR,
                  height: 1,
                ),
                Container(
                  child: Padding(
                    padding:
                        new EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "建筑面积(㎡)",
                          style: new TextStyle(fontSize: prefix0.fontsSize),
                        ),
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(
                                text: sitePageModel.size.toString()),
                            onChanged: (v) {
                              sitePageModel.size = double.parse(v);
                            },
                            inputFormatters: [
                              WhitelistingTextInputFormatter(RegExp("[0-9.]")),
                            ],
                            //只允许输入数字
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
            height: 10,
          ),
          Padding(
              padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: new EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Text(
                              "建筑高度(m)",
                              style: new TextStyle(fontSize: prefix0.fontsSize),
                            ),
                            Expanded(
                              child: TextField(
                                controller: TextEditingController(
                                    text: sitePageModel.height.toString()),
                                onChanged: (v) {
                                  sitePageModel.height = double.parse(v);
                                },
                                inputFormatters: [
                                  WhitelistingTextInputFormatter(
                                      RegExp("[0-9.]")),
                                ],
                                //只允许输入数字
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
                    ),
                    Container(
                      color: prefix0.LINE_COLOR,
                      height: 1,
                    ),
                    Container(
                      child: Padding(
                        padding: new EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Text(
                              "地上楼层数(层)",
                              style: new TextStyle(fontSize: prefix0.fontsSize),
                            ),
                            Expanded(
                              child: TextField(
                                controller: TextEditingController(
                                    text: sitePageModel.upperFloor.toString()),
                                onChanged: (v) {
                                  sitePageModel.upperFloor = int.parse(v);
                                },
                                inputFormatters: [
                                  WhitelistingTextInputFormatter(
                                      RegExp("[0-9.]")),
                                ],
                                //只允许输入数字
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
                    ),
                    Container(
                      color: prefix0.LINE_COLOR,
                      height: 1,
                    ),
                    Container(
                      child: Padding(
                        padding: new EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Text(
                              "地下楼层数(层)",
                              style: new TextStyle(fontSize: prefix0.fontsSize),
                            ),
                            Expanded(
                              child: TextField(
                                controller: TextEditingController(
                                    text: sitePageModel.belowFloor.toString()),
                                onChanged: (v) {
                                  sitePageModel.belowFloor = int.parse(v);
                                },
                                inputFormatters: [
                                  WhitelistingTextInputFormatter(
                                      RegExp("[0-9.]")),
                                ],
                                //只允许输入数字
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
                    ),
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
              callbacktext: (text) {
                print(text + "备注");
                sitePageModel.remarks = text;
              },
            ),
          ),
        ],
      ),
    );

    Widget delete = new Offstage(
      offstage: false,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () {
            deleteBuilding();
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
    if (null != sitePageModel) {
      if ((null != sitePageModel.name && sitePageModel.name.length > 0) &&
          (null != sitePageModel.address && sitePageModel.address.length > 0)) {
        this.isCheack = true;
      } else {
        this.isCheack = false;
      }
    }
  }
}
