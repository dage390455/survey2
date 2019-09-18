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
          GestureDetector(
            onTap: editPurpose, //写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text(
                    "场所层级",
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
          Container(
            color: Colors.white,
            padding: new EdgeInsets.fromLTRB(20, 0, 20, 40),
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
                TextField(
                  controller: remarkController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2.0),
                        borderSide: BorderSide(color: Colors.transparent)),
                    hintText: 'xccx',
                  ),
                  maxLines: 5,
//                  autofocus: false,
                  onChanged: (val) {
                    fireModel.remark = val;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),

          Padding(
            padding: new EdgeInsets.fromLTRB(0, 0, 0, 100),
          )

        ],
      ),
    );

    return Scaffold(
      appBar: NavBar,
      body: bigContainer,
    );
  }

  updateNextButton() {
    if (fireModel.siteName.length > 0 &&
//        fireModel.siteName.length > 0 &&
        fireModel.editPosition.length > 0) {
      this.isCheack = true;
    } else {
      this.isCheack = false;
    }
  }
}
