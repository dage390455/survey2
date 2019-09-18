//现场情况
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensoro_survey/model/electrical_fire_model.dart';
import 'package:sensoro_survey/views/survey/SurveyPointInformation/survay_electrical_fire.dart';
import 'package:sensoro_survey/views/survey/common/data_transfer_manager.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/editPage/edit_address_page.dart';
import 'package:sensoro_survey/views/survey/editPage/edit_boss_person_page.dart';
import 'package:sensoro_survey/views/survey/editPage/edit_boss_person_phone_page.dart';
import 'package:sensoro_survey/views/survey/editPage/edit_content_page.dart';
import 'package:sensoro_survey/views/survey/editPage/edit_head_person_page.dart';
import 'package:sensoro_survey/views/survey/editPage/edit_head_person_phone_page.dart';
import 'package:sensoro_survey/views/survey/editPage/edit_name_page.dart';
import 'package:sensoro_survey/views/survey/editPage/edit_purpose_page.dart';
import 'package:sensoro_survey/views/survey/editPage/survey_point_area.dart';
import 'package:sensoro_survey/views/survey/editPage/survey_point_structure.dart';
import 'package:sensoro_survey/views/survey/survey_point_information.dart';

import '../const.dart';
import '../survey_type_page.dart';
import 'Model/SitePageModel.dart';

class CreatSitePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<CreatSitePage> {
  BasicMessageChannel<String> _basicMessageChannel =
      BasicMessageChannel("BasicMessageChannelPlugin", StringCodec());

  SitePageModel fireModel = SitePageModel();
  FocusNode blankNode = FocusNode();
  var isCheack = false;
  TextEditingController remarkController = TextEditingController();

  @override
  void initState() {
    updateNextButton();
    _basicMessageChannel.setMessageHandler((message) => Future<String>(() {
          print(message);
          //message为native传递的数据
          if (message != null && message.isNotEmpty) {
            List list = message.split(",");
            if (list.length == 3) {
              setState(() {
                fireModel.editLongitudeLatitude = list[0] + "," + list[1];
                fireModel.editPosition = list[2];
                updateNextButton();
              });
            }
          }
          //给Android端的返回值
          return "========================收到Native消息：" + message;
        }));
    remarkController.text = fireModel.remark;
    super.initState();
  }

  //向native发送消息
  void _sendToNative() {
    var location =
        "0," + fireModel.editLongitudeLatitude + "," + fireModel.editPosition;

    Future<String> future = _basicMessageChannel.send(location);
    future.then((message) {
      print("========================" + message);
    });
  }

  nextStep() async {
    final result = await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new SurveyTypePage()),
    );

    if (result != null) {
      String name = result as String;

      if (name == "1") {
        Navigator.of(context).pop("1");
      }
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
        "新建场所",
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
              if (this.isCheack) {
                Navigator.of(context).pop(this.fireModel);
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
                  name: this.fireModel.siteName,
                  title: "场所名称",
                  hintText: "请输入场所名称，例如：望京Soho T1",
                  historyKey: "siteCreatHistoryKey",
                )),
      );

      if (result != null) {
        String name = result as String;

        this.fireModel.siteName = name;
        updateNextButton();
        setState(() {});
      }
    }

    editPurpose() async {
//      final result = await Navigator.push(
//        context,
//        new MaterialPageRoute(
//            builder: (context) => new EditPurposePage(
//                  name: this.fireModel.editPurpose,
//                )),
//      );
//
//      if (result != null) {
//        String name = result as String;
//
//        this.fireModel.editPurpose = name;
//        updateNextButton();
//        setState(() {});
//      }
    }

    editLoction() async {
//       final result = await Navigator.push(
//         context,
//         new MaterialPageRoute(builder: (context) => new EditLoctionPage(name: this.location,)),
//       );
//
//       if (result!=null){
//         String name = result as String;
//
//         this.location = name;
//         updateNextButton();
//         setState(() {
//
//         });
//       }
      _sendToNative();
    }

    String _getAreaString() {
      switch (fireModel.siteType) {
        case SiteType.area:
          return "区域";
          break;
        case SiteType.building:
          return "建筑";
          break;
        case SiteType.unkonw:
          return "请选择场所层级";
          break;
      }
    }

    Widget container = Container(
      color: Colors.white,
      padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: editName, //写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text(
                    "场所名称",
                    style: new TextStyle(fontSize: prefix0.fontsSize),
                  ),
                  Expanded(
                    child: Text(
                      this.fireModel.siteName.length > 0
                          ? this.fireModel.siteName
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
//          GestureDetector(
//            onTap: editPurpose, //写入方法名称就可以了，但是是无参的
//            child: Container(
//              alignment: Alignment.center,
//              height: 60,
//              child: new Row(
//                children: <Widget>[
//                  Text(
//                    "场所层级",
//                    style: new TextStyle(fontSize: prefix0.fontsSize),
//                  ),
//                  Expanded(
//                    child: Text(
//                      _getAreaString(),
//                      textAlign: TextAlign.right,
//                      style: new TextStyle(fontSize: prefix0.fontsSize),
//                    ),
//                  ),
//                  Image.asset(
//                    "assets/images/arrow_folddown.png",
//                    width: 20,
//                  )
//                ],
//              ),
//            ),
//          ),

          new Container(
            alignment: Alignment.center,
            height: 60,
            child: Center(
              child: PopupMenuButton(
//              icon: Icon(Icons.home),
                child: new Row(
                  children: <Widget>[
                    Text(
                      "场所层级",
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                    Expanded(
                      child: Text(
                        _getAreaString(),
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ),
                    Image.asset(
                      "assets/images/arrow_folddown.png",
                      width: 20,
                    )
                  ],
                ),
                tooltip: "长按提示",
                initialValue: "hot",
                offset: Offset(0.2, 0),
                padding:
                    EdgeInsets.only(top: 0.0, bottom: 0, left: 100, right: 0),

                itemBuilder: (BuildContext context) {
                  return <PopupMenuItem<String>>[
                    PopupMenuItem<String>(
                      child: Text("区域"),
                      value: "1",
                    ),
                    PopupMenuItem<String>(
                      child: Text("建筑"),
                      value: "0",
                    ),
                  ];
                },

                onSelected: (String s) {
                  switch (s) {
                    case "1":
                      fireModel.siteType = SiteType.area;
                      break;
                    case "0":
                      fireModel.siteType = SiteType.building;
                      break;
                  }
                  setState(() {
                    // choosedModel = cars[int.parse(action)];
                  });
                },
                onCanceled: () {
                  print("onCanceled");
                },
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
                    "行政区域",
                    style: new TextStyle(fontSize: prefix0.fontsSize),
                  ),
                  Expanded(
                    child: Text(
                      this.fireModel.editPosition.length > 0
                          ? this.fireModel.editPosition
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
          Container(
            color: Colors.white,
            padding: new EdgeInsets.fromLTRB(0, 0, 0, 40),
            child: Column(
              children: <Widget>[
                GestureDetector(
//            onTap: editAddress,//写入方法名称就可以了，但是是无参的
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    child: new Row(
                      children: <Widget>[
                        Text(
                          "备注",
                          style: new TextStyle(fontSize: prefix0.fontsSize),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                   height: 120,
                  decoration: BoxDecoration(
                    border: new Border.all(color: LIGHT_TEXT_COLOR, width: 0.5),
                  ),
                  child: TextField(
                    //文本输入控件
                    onChanged: (val) {
                      fireModel.remark = val;
                      setState(() {});
                    },
                    controller: remarkController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.start,
                    minLines: 1,
                    maxLines: 10,
                    style: new TextStyle(
                      fontSize: 15.0,
                      color: prefix0.BLACK_TEXT_COLOR,
                    ),
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      // border: new Border.all(color: LIGHT_TEXT_COLOR, width: 0.5),
                      hintText: "",
                      contentPadding: EdgeInsets.fromLTRB(
                          20.0, 20.0, 10.0, 10.0), //设置显示文本的一个内边距
// //                border: InputBorder.none,//取消默认的下划线边框
                    ),
                  ),
                ),
              ],
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
      body: GestureDetector(
        onTap: () {
          // 点击空白页面关闭键盘
          FocusScope.of(context).requestFocus(blankNode);
        },
        child: bigContainer,
      ),
    );
  }

  updateNextButton() {
    if (fireModel.siteName.length > 0 &&
        fireModel.siteType != SiteType.unkonw &&
        fireModel.editPosition.length > 0) {
      this.isCheack = true;
    } else {
      this.isCheack = false;
    }
  }
}
