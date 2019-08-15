/// @Author: zyg
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

class ElectricInstallPage extends StatefulWidget {
  _ElectricInstallPageState createState() => _ElectricInstallPageState();
}

class _ElectricInstallPageState extends State<ElectricInstallPage> {
  _ElectricInstallPageState() {
    final eventBus = new EventBus();
    // ApplicationEvent.event = eventBus;
  }

  static List dataList = new List(); //static才能在build里使用
  static int listTotalCount = 0;
  static const EventChannel eventChannel =
      const EventChannel("App/Event/Channel", const StandardMethodCodec());

  static Map<String, dynamic> headers = {};
  // 创建一个给native的channel (类似iOS的通知）
  static const methodChannel =
      const MethodChannel('com.pages.your/electric_install');

  // 创建一个给native的channel (类似iOS的通知）
  // static const methodChannel = const MethodChannel('com.pages.your/task_test');
  @override
  void initState() {
    super.initState();
  }

  _navBack() async {
    Map<String, dynamic> map = {
      "code": "200",
      "data": [0, 0, 0]
    };
    await methodChannel.invokeMethod('navBack', map);
  }

  String text1 = "111111";
  @override
  Widget build(BuildContext context) {
    Widget NavBar = AppBar(
      elevation: 1.0,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text(
        "电气火灾安装点勘测",
        style: TextStyle(
            color: BLACK_TEXT_COLOR, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      leading: IconButton(
        icon: Image.asset(
          "assets/images/back.png",
          // height: 20,
        ),
        onPressed: () {
          // SendEvent();
          _navBack();
        },
      ),
    );

    Widget elecHeader = Container(
      color: prefix0.LIGHT_LINE_COLOR,
      // height: 140, //高度不填会自适应
      padding: const EdgeInsets.only(top: 0.0, bottom: 0, left: 20, right: 10),
      child: Text(
        "1 电箱信息",
        textAlign: TextAlign.start,
        style: TextStyle(
            color: prefix0.GREEN_COLOR,
            fontWeight: FontWeight.normal,
            fontSize: 13),
      ),
    );

    Widget mainView1 = new CustomScrollView(
      shrinkWrap: true,
      // 内容
      slivers: <Widget>[
        new SliverPadding(
          padding: const EdgeInsets.all(20.0),
          sliver: new SliverList(
            delegate: new SliverChildListDelegate(
              <Widget>[
                const Text('A'),
                const Text('B'),
                const Text('C'),
                const Text('D'),
              ],
            ),
          ),
        )
      ],
    );

    Widget mainView = new ListView.builder(
      physics: new AlwaysScrollableScrollPhysics()
          .applyTo(new BouncingScrollPhysics()), // 这个是用来控制能否在不满屏的状态下滚动的属性
      itemCount: 5,
      // separatorBuilder: (BuildContext context, int index) =>
      // Divider(height: 1.0, color: Colors.grey, indent: 20), // 添加分割线
      itemBuilder: (BuildContext context, int index) {},
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: Text("Flutter Layout Demo"),
      title: "Flutter Layout Demo",
      home: Scaffold(
        appBar: NavBar,
        body: Container(
          color: Colors.white,
          // height: 140, //高度不填会自适应
          padding:
              const EdgeInsets.only(top: 0.0, bottom: 0, left: 20, right: 10),
          child: Column(
            //这行决定了左对齐
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              elecHeader,
              mainView,
              Text(
                'You have pushed the button this many times:',
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
