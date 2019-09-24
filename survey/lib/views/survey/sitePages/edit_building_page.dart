//现场情况
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensoro_survey/net/api/app_api.dart';
import 'package:sensoro_survey/net/api/net_config.dart';
import 'package:sensoro_survey/views/survey/commonWidegt/inputnumbertextfiled.dart';
import 'package:sensoro_survey/views/survey/commonWidegt/remarktextfiled.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/sitePages/Model/SitePageModel.dart';

class EditbuildingPage extends StatefulWidget {
  SitePageModel sitePageModel = SitePageModel.building(
      "", "", "", "", "", "", "", 0, ",", "", 0, 0, "", "", "", "");

  EditbuildingPage(this.sitePageModel);

  @override
  _State createState() => _State(sitePageModel);
}

class _State extends State<EditbuildingPage> {
  BasicMessageChannel<String> _basicMessageChannel =
      BasicMessageChannel("BasicMessageChannelPlugin", StringCodec());
  SitePageModel sitePageModel;

  _State(this.sitePageModel);

  bool isCheack = false;

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
    String urlStr = NetConfig.baseUrl + NetConfig.getSiteUrl + sitePageModel.id;
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

        SitePageModel model = SitePageModel.fromDetailJson(json);
        if (model != null) {
          setState(() {
            sitePageModel = model;
          });
        }
      }
    }
    _updateSaveState();
  }

  Future editBuilding() async {
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

  Future deleteSite() async {
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
                editBuilding();
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
                                  child: inputnumbertextfiled(
                                    title: "建筑名称",
                                    intputtype: 0,
                                    defaultText: sitePageModel.name == null
                                        ? "建筑名称"
                                        : sitePageModel.name,
                                    onChanged: (text) {
                                      _updateSaveState();
                                      this.sitePageModel.name = text;
                                    },
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
                            null != this.sitePageModel.address
                                ? this.sitePageModel.address
                                : "必填",
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
                inputnumbertextfiled(
                  defaultText: sitePageModel.size != null
                      ? sitePageModel.size.toString()
                      : "",
                  title: "建筑面积(㎡)",
                  intputtype: 0,
                  onChanged: (text) {},
                  callbacktext: (text) {},
                ),
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
                    inputnumbertextfiled(
                      defaultText: sitePageModel.height.toString(),
                      title: "建筑高度(m)",
                      intputtype: 1,
                      onChanged: (text) {
                        sitePageModel.height = text;
                        print(text + "建筑高度");
                      },
                    ),
                    Container(
                      color: prefix0.LINE_COLOR,
                      height: 1,
                    ),
                    inputnumbertextfiled(
                      title: "地上楼层数(层)",
                      intputtype: 1,
                      defaultText: sitePageModel.upperFloor != null
                          ? sitePageModel.upperFloor.toString()
                          : "",
                      onChanged: (text) {
                        sitePageModel.upperFloor = text;

                        print(text + "地上楼层数");
                      },
                    ),
                    Container(
                      color: prefix0.LINE_COLOR,
                      height: 1,
                    ),
                    inputnumbertextfiled(
                      title: "地下楼层数(层)",
                      intputtype: 1,
                      defaultText: sitePageModel.belowFloor != null
                          ? sitePageModel.belowFloor.toString()
                          : "",
                      onChanged: (text) {
                        sitePageModel.belowFloor = text;

                        print(text + "地下楼层数");
                      },
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
            deleteSite();
//            _creatSite(new SitePageModel(), true);
          },
          child: Container(
            color: Colors.red,
            height: 40,
            alignment: Alignment.center,
//            decoration: BoxDecoration(
//                borderRadius: BorderRadius.circular(3.0), //3像素圆角
//                border: Border.all(color: Colors.grey),
////                boxShadow: [
////                  //阴影
////                  BoxShadow(color: Colors.white, blurRadius: 4.0)
////                ]
//            ),
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
    if (sitePageModel.name.length > 0 && sitePageModel.address.length > 0) {
      this.isCheack = true;
    } else {
      this.isCheack = false;
    }
  }
}
