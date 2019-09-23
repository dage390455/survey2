//现场情况
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensoro_survey/net/api/app_api.dart';
import 'package:sensoro_survey/net/api/net_config.dart';
import 'package:sensoro_survey/views/survey/commonWidegt/inputnumbertextfiled.dart';
import 'package:sensoro_survey/views/survey/commonWidegt/remarktextfiled.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/editPage/edit_content_page.dart';
import 'package:sensoro_survey/views/survey/sitePages/Model/SitePageModel.dart';

class CreatbuildingPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<CreatbuildingPage> {
  BasicMessageChannel<String> _basicMessageChannel =
      BasicMessageChannel("BasicMessageChannelPlugin", StringCodec());
  SitePageModel sitePageModel;

  bool isCheack = false;

  @override
  void initState() {
    _basicMessageChannel.setMessageHandler((message) => Future<String>(() {
          print(message);
          //message为native传递的数据
          if (message != null && message.isNotEmpty) {
            List list = message.split(",");
            if (list.length == 3) {
              setState(() {
//                sitePageModel.location = list[0] + "," + list[1];
//                sitePageModel.address = list[2];
                _updateSaveState();
              });
            }
          }
          //给Android端的返回值
          return "========================收到Native消息：" + message;
        }));

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

  Future creatBuilding() async {
    String urlStr = NetConfig.baseUrl + NetConfig.createUrl;
    Map<String, dynamic> headers = {};
    Map<String, dynamic> params = {"data": sitePageModel.toBuildJson()};

    print(params);

    ResultData resultData = await AppApi.getInstance()
        .post(urlStr, params: params, context: context, showLoad: true);
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
        "新建建筑",
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
                creatBuilding();
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

    editName() async {
      final result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new EditContentPage(
                  name: this.sitePageModel.name,
                  title: "建筑名称",
                  hintText: "请输入建筑名称",
                  historyKey: "buildingCreatHistoryKey",
                )),
      );

      if (result != null) {
        String name = result as String;

        this.sitePageModel.name = name;
        _updateSaveState();

        setState(() {});
      }
    }

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
                GestureDetector(
                  onTap: editName,
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    child: new Row(
                      children: <Widget>[
                        Text(
                          "建筑名称",
                          style: new TextStyle(fontSize: prefix0.fontsSize),
                        ),
                        Expanded(
                          child: Text(
                            null != this.sitePageModel.name
                                ? this.sitePageModel.name
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
    if (sitePageModel.name.length > 0 && sitePageModel.address.length > 0) {
      this.isCheack = true;
    } else {
      this.isCheack = false;
    }
  }
}
