/// @Author: zyg
/// @Date: 2019-07-23
/// @Last Modified by: zyg
/// @Last Modified time: 2019-07-23
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/services.dart';

import 'package:sensoro_survey/views/sensoro_city_page/task_detail_model.dart';

class taskDetailPage extends StatefulWidget {
  _taskDetailPageState createState() => _taskDetailPageState();
}

class _taskDetailPageState extends State<taskDetailPage> {
  TimeOfDay _time = TimeOfDay.now();
  // List<CityDetailModel> cityDetailArrays = <CityDetailModel>[];

  // 创建一个给native的channel (类似iOS的通知）
  static const methodChannel = const MethodChannel('com.pages.your/city_list');

  static const EventChannel eventChannel =
      const EventChannel("App/Event/Channel", const StandardMethodCodec());

  _navBack() async {
    Map<String, dynamic> map = {
      "code": "200",
      "data": [1, 2, 3]
    };
    await methodChannel.invokeMethod('navBack', map);
  }

  _taskDetailPageState() {
    final eventBus = new EventBus();
    // ApplicationEvent.event = eventBus;
  }

  @override
  void initState() {
    super.initState();
    //这里面只能初始化，不能执行add之类的操作
    // eventChannel
    //     .receiveBroadcastStream("init")
    //     .listen(_onEvent, onError: _onError);
    // this.initDetailList();

    //这一句代码改变上方状态栏字体颜色
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        //or set color with: Color(0xFF0000FF)
        // statusBarColor: Colors.blue,
        ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
