/// @Author: zyg
/// @Date: 2019-07-23
/// @Last Modified by: zyg
/// @Last Modified time: 2019-07-23
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/services.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/const.dart';
import 'package:sensoro_survey/model/survey_type_model.dart';
import 'package:sensoro_survey/views/survey/survey_point_information.dart';

class SurveyTypePage extends StatefulWidget {
  _SurveyTypePageState createState() => _SurveyTypePageState();
}

class _SurveyTypePageState extends State<SurveyTypePage> {
  _SurveyTypePageState() {}

  static List dataList = new List(); //static才能在build里使用
  static int listTotalCount = 0;

  @override
  void initState() {
    super.initState();

    dataList.clear();
    initDetailList();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        //or set color with: Color(0xFF0000FF)
        // statusBarColor: Colors.blue,
        ));
  }

  void initDetailList() {
    for (int index = 0; index < 1; index++) {
      var name = "测试设备 $index";
      if (index == 0) name = "电气火灾安装点";
      if (index == 1) name = "烟感安装点";
      if (index == 2) name = "摄像头安装点";
      if (index == 3) name = "消防主机安装点";

      var path = " ";
      if (index == 0) path = "assets/images/电气火灾.png";
      if (index == 1) path = "assets/images/电气火灾.png";
      if (index == 2) path = "2019-07-06 15:24";
      if (index == 3) path = "2019-07-22 02:14:09";

      surveyTypeModel model = surveyTypeModel(name, path);
      dataList.add(model);
      // var a = 'dd';
      // a = cityDetailArrays[index].name;
    }
  }

  @override
  Widget build(BuildContext context) {
    void _gotoInformation() async {
      // projectInfoModel model = projectInfoModel("", "", 1, "");
      final result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new SurveyPointInformationPage()),
      );

      if (result != null) {
        String name = result as String;

        if (name == "1") {
          Navigator.of(context).pop("1");
        } else {
          setState(() {});
        }
        // this.name = name;
      }
    }

    Widget NavBar = AppBar(
      elevation: 1.0,
      centerTitle: true,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text(
        "勘察类型",
        style: TextStyle(color: Colors.black),
      ),
      leading: IconButton(
        icon: Image.asset(
          "assets/images/back.png",
          // height: 20,
        ),
        onPressed: () {
          // SendEvent();
          Navigator.pop(context);
        },
      ),
    );

    Widget emptyContainer = Container(
      height: 0,
      width: 0,
    );

    Widget myListView = new ListView.builder(
        physics: new AlwaysScrollableScrollPhysics()
            .applyTo(new BouncingScrollPhysics()), // 这个是用来控制能否在不屏的状态下滚动的属性
        itemCount: dataList.length,
        // separatorBuilder: (BuildContext context, int index) =>
        // Divider(height: 1.0, color: Colors.grey, indent: 20), // 添加分割线
        itemBuilder: (BuildContext context, int index) {
          surveyTypeModel model = dataList[index];
          var name = model.name;
          var imagePath = model.ImagePath;

          return Container(
            color: Colors.white,
            padding:
                const EdgeInsets.only(top: 0.0, bottom: 0, left: 0, right: 0),
            child: new Column(

                //这行决定了左对齐
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  index == 0
                      ? Container(
                          color: LIGHT_LINE_COLOR,
                          height: 12,
                          width: prefix0.screen_width,
                        )
                      : emptyContainer,

                  GestureDetector(
                    onTap: _gotoInformation,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(
                          top: 20.0, bottom: 20, left: 20, right: 20),
                      child: Row(
                          //Row 中mainAxisAlignment是水平的，Column中是垂直的
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //表示所有的子控件都是从左到右顺序排列，这是默认值
                          textDirection: TextDirection.ltr,
                          children: <Widget>[
                            new Image(
                              image: new AssetImage(imagePath),
                              width: 20,
                              height: 20,
                              // fit: BoxFit.fitWidth,
                            ),
                            Text(name,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: prefix0.BLACK_TEXT_COLOR,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 17)),
                            new Image(
                              image: new AssetImage(
                                  "assets/images/right_arrar.png"),
                              width: 20,
                              height: 20,
                              // fit: BoxFit.fitWidth,
                            ),
                          ]),
                    ),
                  ),
                  //分割线
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0.0, bottom: 0, left: 20, right: 0),
                    child: Container(
                        alignment: Alignment.center,
                        width: prefix0.screen_width - 40,
                        height: 1.0,
                        color: FENGE_LINE_COLOR),
                  ),
                ]),
          );
        });

    return Scaffold(
      appBar: NavBar,
      body: myListView,
    );
  }
}
