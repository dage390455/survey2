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
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/const.dart';
import 'package:sensoro_survey/widgets/progressHud.dart';
import 'package:sensoro_survey/model/project_info_model.dart';

class AddProjectPage extends StatefulWidget {
  final projectInfoModel todo;
  AddProjectPage({Key key, @required this.todo}) : super(key: key);
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  _AddProjectPageState() {
    final eventBus = new EventBus();
    // ApplicationEvent.event = eventBus;
  }

  String name = "";
  String time = "";
  String remark = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget emptyContainer = Container(
      height: 0,
      width: 0,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: Text("Flutter Layout Demo"),
      title: "Flutter Layout Demo",
      home: Scaffold(
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
        body: new Column(
            //这行决定了左对齐
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            //占满剩���空间
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                    top: 0.0, bottom: 0, left: 20, right: 20),
                child: Column(
                  children: <Widget>[
                    Text("项目名称",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: prefix0.BLACK_TEXT_COLOR,
                            fontWeight: FontWeight.normal,
                            fontSize: 17)),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
