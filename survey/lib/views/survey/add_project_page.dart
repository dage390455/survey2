// @Author: zyg
/// @Date: 2019-07-23
/// @Last Modified by: zyg
/// @Last Modified time: 2019-07-23
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/const.dart';
import 'package:sensoro_survey/widgets/progressHud.dart';
import 'package:sensoro_survey/model/project_info_model.dart';
import 'package:sensoro_survey/views/survey/editPage/edit_project_name_page.dart';
import 'package:sensoro_survey/views/survey/comment/SaveDataManger.dart';

class AddProjectPage extends StatefulWidget {
  projectInfoModel input;
  AddProjectPage({Key key, @required this.input}) : super(key: key);

  @override
  _AddProjectPageState createState() => _AddProjectPageState(input: this.input);
}

class _AddProjectPageState extends State<AddProjectPage> {
  projectInfoModel input;
  _AddProjectPageState({this.input});

  String name = "";
  String time = "";
  String remark = "";

  @override
  void initState() {
    name = this.input.projectName;
    time = this.input.createTime;
    super.initState();
  }

  void saveInfoInLocal() {
    int currentTimeMillis = prefix0.currentTimeMillis();
    DateTime _dateTime = DateTime.now();
    String datestr =
        "${_dateTime.year}-${_dateTime.month}-${_dateTime.day} ${_dateTime.hour}:${_dateTime.minute}";
    input.createTime = datestr;
    input.projectName = this.name;
    input.projectId = currentTimeMillis;

    String historyKey = 'projectList';
    String json = input.toJson();
    SaveDataManger.addHistory(json, historyKey);
  }

  @override
  Widget build(BuildContext context) {
    editName() async {
      final result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new EditProjectNamePage(
                  name: this.name,
                )),
      );

      if (result != null) {
        String name = result as String;

        // updateNextButton();
        setState(() {
          this.name = name;
        });
      }
    }

    Widget emptyContainer = Container(
      height: 0,
      width: 0,
    );

    Widget bottomButton = Container(
      color: prefix0.LIGHT_LINE_COLOR,
      height: 60,
      width: prefix0.screen_width,
      child: new MaterialButton(
        color: this.name.length > 0 ? prefix0.GREEN_COLOR : Colors.grey,
        textColor: Colors.white,
        child: new Text('完成',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 20)),
        onPressed: () {
          if (this.name.length > 0) {
            saveInfoInLocal();
            Navigator.of(context).pop("refreshList");
            // Navigator.push(
            //   context,
            //   new MaterialPageRoute(
            //       builder: (context) => new SurvayElectricalFirePage()),
            // );
          }
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Text(
          "项目信息",
          style: TextStyle(
              color: BLACK_TEXT_COLOR,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        leading: IconButton(
          icon: Image.asset(
            "assets/images/back.png",
            // height: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding:
            const EdgeInsets.only(top: 20.0, bottom: 0, left: 20, right: 20),
        child: Column(
            //这行决定了左对齐
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            //占满剩���空间
            children: <Widget>[
              GestureDetector(
                onTap: editName, //写入方法名称就可以了，但是是无参的
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("项目名称",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: prefix0.BLACK_TEXT_COLOR,
                            fontWeight: FontWeight.normal,
                            fontSize: 15)),
                    Text(name.length > 0 ? name : "必填",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: name.length > 0
                                ? prefix0.BLACK_TEXT_COLOR
                                : prefix0.LIGHT_TEXT_COLOR,
                            fontWeight: FontWeight.normal,
                            fontSize: 15)),
                    new Image(
                      image: new AssetImage("assets/images/right_arrar.png"),
                      width: 24,
                      height: 24,
                      // fit: BoxFit.fitWidth,
                    ),
                    // IconButton(
                    //   icon: Image.asset(
                    //     "assets/images/right_arrar.png",
                    //     // height: 20,
                    //   ),
                    //   onPressed: () {
                    //     editName;
                    //   },
                    // ),
                  ],
                ),
              ),

              new SizedBox(
                height: 10,
              ),
              //分割线
              Container(
                  width: prefix0.screen_width - 40,
                  height: 1.0,
                  color: FENGE_LINE_COLOR),

              new SizedBox(
                height: 10,
              ),
              Text("备注",
                  textAlign: TextAlign.start,
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
                  border: new Border.all(color: LIGHT_TEXT_COLOR, width: 0.5),
                ),
                child: TextField(
                  //文本输入控件
                  onSubmitted: (String str) {
                    //提交监听
                    // searchStr = val;
                    // print('用户提交变更');
                  },
                  textAlign: TextAlign.start,
                  minLines: 1,
                  maxLines: 10,
                  style: new TextStyle(
                    fontSize: 13.0,
                    color: prefix0.BLACK_TEXT_COLOR,
                  ),
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                    // border: new Border.all(color: LIGHT_TEXT_COLOR, width: 0.5),
                    hintText: "点击输入",

                    contentPadding: EdgeInsets.fromLTRB(
                        20.0, 20.0, 10.0, 10.0), //设置显示文本的一个内边距
// //                border: InputBorder.none,//取消默认的下划线边框
                  ),
                ),
              ),
            ]),
      ),
      bottomSheet: bottomButton,
    );
  }
}
