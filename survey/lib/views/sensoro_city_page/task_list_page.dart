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

import 'package:progress_hud/progress_hud.dart';
// import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sensoro_survey/generated/easyRefresh/easy_refresh.dart';
import 'package:dio_flutter_transformer/dio_flutter_transformer.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:sensoro_survey/views/sensoro_city_page/task_detail_page.dart';
import 'package:sensoro_survey/views/sensoro_city_page/task_detail_model.dart';
import 'package:sensoro_survey/generated/translations.dart';
import 'package:sensoro_survey/generated/application.dart';
import 'package:sensoro_survey/net/api/app_api.dart';
import 'package:sensoro_survey/net/api/bean/weather_bean.dart';
import 'package:sensoro_survey/widgets/progressHud.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/const.dart';

class taskListPage extends StatefulWidget {
  _taskListPageState createState() => _taskListPageState();
}

class _taskListPageState extends State<taskListPage> {
  _taskListPageState() {
    final eventBus = new EventBus();
    // ApplicationEvent.event = eventBus;
  }

  static List dataList = new List(); //static才能在build里使用
  static int listTotalCount = 0;
  static const EventChannel eventChannel =
      const EventChannel("App/Event/Channel", const StandardMethodCodec());

  static Map<String, dynamic> headers = {};
  // 创建一个给native的channel (类似iOS的通知）
  static const methodChannel = const MethodChannel('com.pages.your/task_list');

  static int pageNo = 1;
  static int pageSize = 10;
  static Map<String, dynamic> params = {};
  static String text11 = "旧的文本";
  static String urlStr = "";
  static String beginTimeStr = "";
  static String endTimeStr = "";
  static bool isFrist = true;

  var conditionList = [
    {
      'value': 'interval',
      'label': '周期设置',
      'icon': 'period',
    },
    {
      'value': 'threshold',
      'label': '预警设置',
      'icon': 'attention',
    },
    {
      'value': 'config',
      'label': '初始配置',
      'icon': 'edit',
    },
    {
      'value': 'password',
      'label': '重置密码',
      'icon': 'reset_password',
    },
    {
      'value': 'reset',
      'label': '报警复位',
      'icon': 'fuwei',
    },
    {
      'value': 'view',
      'label': '数据查询',
      'icon': 'chaxun',
    },
    {
      'value': 'mute',
      'label': '报警消音',
      'icon': 'xiaoyin',
    },
    {
      'value': 'mute2',
      'label': '报警长消音',
      'icon': 'xiaoyin',
    },
    {
      'value': 'mute_time',
      'label': '定时消音',
      'icon': 'xiaoyin',
    },
    {
      'value': 'check',
      'label': '设备自检',
      'icon': 'zijian',
    },
    {'value': 'close', 'label': '上电', 'icon': 'shangdian'},
    {'value': 'open', 'label': '断电', 'icon': 'duandian'}
  ];

  List<taskDetailModel> taskDetailArrays = <taskDetailModel>[];
  String text22 = "旧的文本";
  String title1 = "任务列表";
  String weather = "";

  static int _itemCount = dataList.length;

  Timer _changeTimer;
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();

  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();

  bool _loading = true;
  bool _loadMore = true;
  TimeOfDay _time = TimeOfDay.now();
  bool _calendaring = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    //初始化后主动请求拉取数据
    SendEvent();

    //延时调用
    _changeTimer = new Timer(Duration(milliseconds: 200), () {
      _getList();
      // setState(() {});
    });

    //延时调用
    _changeTimer = new Timer(Duration(milliseconds: 500), () {
      //监听信息传递
      SendEvent();
      // setState(() {});
    });

    //延时调用
    Timer _changeTimer1 = new Timer(Duration(milliseconds: 1000), () {
      setState(() {});
    });

    //时用
    Timer _changeTimer2 = new Timer(Duration(milliseconds: 1500), () {
      setState(() {});
    });

    //这里面只能初始化，不能执行add之类的操作
    eventChannel
        .receiveBroadcastStream("getURL")
        .listen(_onEvent, onError: _onError);

    this.initDetailList();

    //这一句码改变上方状态栏字体颜色
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        //or set color with: Color(0xFF0000FF)
        // statusBarColor: Colors.blue,
        ));
  }

  void _getWeather() async {
    ResultData resultData =
        await AppApi.getInstance().getWeather(context, true);
    if (resultData.isSuccess()) {
      WeatherBean weatherBean = WeatherBean.fromJson(resultData.response);
      // Fluttertoast.showToast(msg: "成功获取本周天气, 显示周一天气");
      setState(() {
        weather = json.encode(weatherBean.result[1]);
      });
    }
  }

  void _getListNetCall() async {
    if (dataList.length == 0) {
      pageNo = 1;
    } else {
      pageNo = ((dataList.length - 1) / 10).toInt() + 2;
    }
    if (params["limit"] != null) {
      params["offset"] = (pageNo - 1) * pageSize;
      if ((pageNo - 1) * pageSize == 0) {
        // dataList.clear();
      }
    }
    if (params["pageSize"] != null) {
      params["page"] = pageNo;
      if (pageNo == 1) {
        // dataList.clear();
      }
    }

    ResultData resultData = await AppApi.getInstance()
        .getListNetCall(context, true, urlStr, headers, params);
    if (resultData.isSuccess()) {
      _stopLoading();
      int errcode = resultData.response["errcode"].toInt();
      if (errcode == 0) {
        isFrist = false;
        if (resultData.response["data"] is List) {
          List resultList = resultData.response["data"];
          if (resultList.length > 0) {
            setState(() {
              dataList.addAll(resultList);
            });
          }
        }

        if (resultData.response["total"] is int) {
          listTotalCount = resultData.response["total"];
        }
      } else {}
    }
  }

  // Must be top-level function
  _parseAndDecode(String response) {
    return jsonDecode(response);
  }

  // _parseJson(String text) {
  //   return compute(_parseAndDecode, text);
  // }

  void SendEvent() {
    eventChannel
        .receiveBroadcastStream("getList")
        .listen(_onEvent, onError: _onError);
    // {
    //   print('flutter listen:$result');

    //   if (flag == 1) {}
    //   if (result is List) {
    //     dataList = result;
    //   }
    // });
  }

  // 错误处理
  void _onError(dynamic) {}

  //数据接
  void _onEvent(Object value) {
    if (value is Map) {
      Map dic = value;
      var name = dic["name"];
      if (name == "getList") {
        var content = dic["content"];
        dataList = content;
        int count = dataList.length;
        //算出要拉取的下一页的页数
        if (dataList.length > 0) {
          int temp = pageSize;
          int temp1 = dataList.length - 1;
          double temp2 = temp1 / temp;
          int temp3 = temp2.toInt(); //强制转换

          pageNo = temp3 + 2;
          print("new pageNo =$pageNo");
        }
      }

      if (name == "getURL") {
        urlStr = dic["urlStr"];
        Map temp1 = dic["headers"];
        Map temp2 = dic["params"];
        //判断某个变量非空
        if (temp2["limit"] != null) {
          pageSize = temp2["limit"].toInt();
        }
        if (temp2["pageSize"] != null) {
          pageSize = temp2["pageSize"].toInt();
        }

        temp1.forEach((key, value) => headers[key] = value);
        temp2.forEach((key, value) => params[key] = value);

        String sessionId = headers["x-session-id"];
        // print("getURL=$urlStr");
        // print("getHeaders=$headers");

        if (urlStr.length > 5 && sessionId.length > 5) {
          // _getWeather();
          Future.delayed(new Duration(milliseconds: 200), () {});
          _getListNetCall();
        }
      }

      if (name == "showCalendar") {
        dataList.clear();
        _startLoading();
        setState(() {
          _calendaring = true;
          var beginTime = dic["beginTime"].toInt();
          var endTime = dic["endTime"].toInt();
          if (beginTime > 10000 && endTime > 10000) {
            DateTime date1 = new DateTime.fromMillisecondsSinceEpoch(beginTime);
            beginTimeStr = date1.toString();
            if (beginTimeStr.length > 11) {
              beginTimeStr = beginTimeStr.substring(0, 11);
            }

            DateTime date2 = new DateTime.fromMillisecondsSinceEpoch(endTime);
            endTimeStr = date2.toString();
            if (endTimeStr.length > 11) {
              endTimeStr = endTimeStr.substring(0, 11);
            }
          }
        });
      }

      setState(() {});
      return;
    }

    if (value is List) {
      dataList = value;
    }
    int count = dataList.length;
    //算出要拉取的下一页的页数
    if (dataList.length > 0) {
      int temp = pageSize;
      int temp1 = dataList.length - 1;
      double temp2 = temp1 / temp;
      int temp3 = temp2.toInt(); //强制转换

      pageNo = temp3 + 2;
      print("new pageNo =$pageNo");
    }
    print("old pageNo =$pageNo");
    print("dataList count =$count");
    setState(() {});
  }

  //method 调用的方法
  _navBack() async {
    Map<String, dynamic> map = {
      "code": "200",
      "data": [0, 0, 0]
    };
    await methodChannel.invokeMethod('navBack', map);
  }

  _showCalendar() async {
    Map<String, dynamic> map = {
      "code": "200",
      "data": [1, 2, 3]
    };
    await methodChannel.invokeMethod('showCalendar', map);
  }

  _getList() async {
    print("getList ->pageNo = $pageNo");
    Map<String, dynamic> map = {
      "pageNO": pageNo,
    };
    await methodChannel.invokeMethod('getList', map);
  }

  void initDetailList() {
    for (int index = 0; index < 1000; index++) {
      var name = "测试设备 $index";
      name = "FAGJKJVXOE63S";
      if (index % 3 == 0) name = "调动flutter系统库，选择一个时间";
      if (index % 3 == 1) name = "动flutter自定义的plugin插件，选择一个城市";
      if (index % 3 == 2) name = "进入一段flutter动画";

      if (index % 3 == 0) name = "02ABDGAFGAGA";
      if (index % 3 == 1) name = "GFAGATRGD3434";
      if (index % 3 == 2) name = "JKLJLKGAFI87";

      var des = "状态 $index 常";
      des = "11:04:12";
      if (index == 1) des = "10:54:32";
      if (index == 2) des = "15:24:32";
      if (index == 3) des = "02:14:09";

      taskDetailModel model = taskDetailModel(index, name, '', des);
      taskDetailArrays.add(model);
      // var a = 'dd';
      // a = cityDetailArrays[index].name;
    }
  }

  // 顶部刷新
  Future<Null> onHeaderRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        // rowNumber = 0;
        // lastFileID = '0';
        // newsListBean = null;
        // getNewsData(lastFileID, rowNumber);
      });
    });
  }

// 底部刷新
  Future<Null> onFooterRefresh() async {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        _getList();
        //延时调用
        _changeTimer = new Timer(Duration(milliseconds: 500), () {
          //监信息传递
          SendEvent();
          // setState(() {});
        });
      });
    });
  }

  //小菊花
  Future<Null> _stopLoading() async {
    setState(() {
      _loading = false;
    });
    // await Future.delayed(Duration(seconds: 3), () {
    //   setState(() {
    //     _loading = false;
    //     // Toast.show(context, "加载完成");
    //   });
    // });
  }

  Future<Null> _startLoading() async {
    setState(() {
      _loading = true;
    });
    // await Future.delayed(Duration(seconds: 3), () {
    //   setState(() {
    //     _loading = true;
    //     // Toast.show(context, "加载完成");
    //   });
    // });
  }

/*
  @override
  Widget build(BuildContext context) {
    print('次进入了build');
    var name1 = 'fadfa';

    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: Text("Flutter Layout Demo"),
      title: "Flutter Layout Demo",
      home: Scaffold(
        appBar: AppBar(

          brightness: Brightness.dark,
          title: new Text(self.ti,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 17)),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {

              // _navBack();
              // setState(() {
              //   text11 = "新的文本";
              //   title1 = "务列表新";

                // eventChannel
                //     .receiveBroadcastStream("getList")
                //     .listen(_onEvent, onError: _onError);
                // dataList.removeAt(0);
                // dataList.removeAt(0);
              });
              // eventChannel
              //     .receiveBroadcastStream("getList")
              //     .listen(_onEvent, onError: _onError);
            },
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          actions: <Widget>[],
        ),
        body: ListView(
          children: <Widget>[
            ListSection,
            // listView1,
          ],
        ),
      ),
    );
  }
*/

  //经过测试，在build当中，如果放置setState，会导致多次build，而影响刷新，使listView显示不出来
  //把build的一部分拆分出去作为函数，有的全局变量不可用。取值无效
  @override
  Widget build(BuildContext context) {
    print('再次进入了build');
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
        .copyWith(statusBarBrightness: Brightness.dark));
    var finishstr = "";
    if (dataList.length >= listTotalCount && listTotalCount > 0) {
      finishstr = lastPage_localString;
    } else {
      finishstr = loadFinish_localString;
    }

    Widget emptyContainer = Container(
      height: 0,
      width: 0,
    );

    Widget myListView = ProgressDialog(
      loading: _loading,
      msg: '正在加载...',
      child: EasyRefresh(
        key: _easyRefreshKey,
        behavior: ScrollOverBehavior(),
        refreshHeader: ClassicsHeader(
          key: _headerKey,
          refreshText: pullToRefresh_localString,
          // refreshReadyText: Translations.of(context).txt("releaseToRefresh"),
          refreshReadyText: pullToRefresh_localString,
          refreshingText: pullToRefresh_localString,
          refreshedText: refreshed_localString,
          moreInfo: "",
          bgColor: LIGHT_LINE_COLOR,
          textColor: Colors.black87,
          moreInfoColor: Colors.black54,
          showMore: true,
        ),
        refreshFooter: ClassicsFooter(
          key: _footerKey,
          loadText: pushToLoad_localString,
          loadReadyText: releaseToLoad_localString,
          loadingText: pushToLoad_localString,
          loadedText: finishstr,
          noMoreText: finishstr,
          moreInfo: "",
          bgColor: LIGHT_LINE_COLOR,
          textColor: Colors.black87,
          moreInfoColor: Colors.black54,
          showMore: true,
        ),

        // child: new Container(
        //   color: LIGHT_LINE_COLOR,
        //   padding:
        //       const EdgeInsets.only(top: 20.0, bottom: 0, left: 0, right: 0),
        child: new ListView.builder(
            physics: new AlwaysScrollableScrollPhysics()
                .applyTo(new BouncingScrollPhysics()), // 这个是用来控制能否在不满屏的状态下滚动的属性
            itemCount: dataList.length + 1,
            // separatorBuilder: (BuildContext context, int index) =>
            // Divider(height: 1.0, color: Colors.grey, indent: 20), // 添加分割线
            itemBuilder: (BuildContext context, int index) {
              // print("rebuild index =$index");
              if (dataList.length == 0 && !isFrist) {
                return new Container(
                  padding: const EdgeInsets.only(
                      top: 150.0, bottom: 0, left: 0, right: 0),
                  child: new Column(children: <Widget>[
                    new Image(
                      image: new AssetImage("assets/images/nocontent.png"),
                      width: 120,
                      height: 120,
                      // fit: BoxFit.fitWidth,
                    ),
                    Text("搜索不到相关内容",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: prefix0.LIGHT_TEXT_COLOR,
                            fontWeight: FontWeight.normal,
                            fontSize: 17)),
                  ]),
                );
              }

              if (index == 0) {
                return new Container(
                  color: LIGHT_LINE_COLOR,
                  height: 12,
                  width: prefix0.screen_width,
                );
              }

              if (!(dataList[index - 1] is Map)) {
                return new Container();
              }

              Map dic = dataList[index - 1];
              var scheduleNo =
                  dic["scheduleNo"] == null ? "" : dic["scheduleNo"];
              var contact = dic["contact"];
              var name = contact["name"] == null ? "" : contact["name"];
              var total = "0";
              var successTotal = "0";
              if (dic["complete"] != null) {
                successTotal = dic["complete"].toString();
              }
              if (dic["total"] != null) {
                total = dic["total"].toString();
              }
              var totalStr = "$successTotal/$total";
              var updatedTimeStr = dic["updatedTime"].toString();
              var updatedTime = dic["updatedTime"].toInt();
              var type = dic["type"] == null ? "" : dic["type"];
              var content = dic["content"] == null ? "" : dic["content"];
              var rules = dic["rules"];
              var typeStr = "";
              var contentStr = "";

              DateTime date =
                  new DateTime.fromMillisecondsSinceEpoch(updatedTime);
              updatedTimeStr = date.toString();
              updatedTimeStr = updatedTimeStr.substring(0, 19);
              print("updatedTimeStr = $updatedTimeStr");

              if (type == "threshold") {
                typeStr = "预警设置";
                if (content is Map) {
                  Map dic = content;
                  if (dic["tempAlarmHigh"] != null) {
                    int temp1 = dic["tempAlarmHigh"].toInt();
                    contentStr = "$contentStr" "温度高于$temp1℃时报警，";
                  }
                  if (dic["tempAlarmLow"] != null) {
                    int temp1 = dic["tempAlarmLow"].toInt();
                    contentStr = "$contentStr" "温度低于$temp1℃时报警，";
                  }
                  if (dic["humiAlarmHigh"] != null) {
                    int temp1 = dic["humiAlarmHigh"].toInt();
                    contentStr = "$contentStr" "湿度高于$temp1℃时报警，";
                  }
                  if (dic["humiAlarmLow"] != null) {
                    int temp1 = dic["humiAlarmLow"].toInt();
                    contentStr = "$contentStr" "湿度低于$temp1℃时报警，";
                  }
                }
                print("content = $content");
              } else {
                for (int i = 0; i < conditionList.length; i++) {
                  var dic = conditionList[i];
                  if (dic["value"] == type) {
                    typeStr = dic["label"].toString();
                    contentStr = dic["label"].toString();
                  }
                }
              }

              return new Container(
                color: Colors.white,
                // decoration: const BoxDecoration(
                //   border: Border(
                //  bottom:
                //   ),
                // ),
                // height: 140, //高度不填会自适应
                padding: const EdgeInsets.only(
                    top: 20.0, bottom: 0, left: 20, right: 20),
                child: new Column(

                    //这行决定了左对齐
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //占满剩空间

                    children: <Widget>[
                      Row(
                          //Row 中mainAxisAlignment是水平的，Column中是垂直的
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //表示所有的子控件都是从左到右顺序排列，这是默认值
                          textDirection: TextDirection.ltr,
                          children: <Widget>[
                            //这行决定了左对齐

                            //这个位置用ListTile就会报错
                            Text("批次号",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: LIGHT_TEXT_COLOR,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13)),
                            new SizedBox(
                              width: 20,
                            ),

                            Text(
                              scheduleNo,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: BLACK_TEXT_COLOR,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13),
                            ),
                          ]),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "商户",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: LIGHT_TEXT_COLOR,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13),
                            ),
                            new SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Text(
                                dic["userName"],
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: BLACK_TEXT_COLOR,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13),
                              ),
                            ),
                          ]),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "操作员",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: LIGHT_TEXT_COLOR,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13),
                            ),
                            new SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Text(
                                name,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: BLACK_TEXT_COLOR,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13),
                              ),
                            ),
                          ]),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "任务类型",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: LIGHT_TEXT_COLOR,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13),
                            ),
                            new SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Text(
                                typeStr,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: BLACK_TEXT_COLOR,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13),
                              ),
                            ),
                          ]),
                      SizedBox(
                        height: 5,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Text(
                              "任务内容",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: LIGHT_TEXT_COLOR,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13),
                            ),
                            new SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Text(
                                contentStr,
                                textAlign: TextAlign.right,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 50,
                                style: TextStyle(
                                    color: BLACK_TEXT_COLOR,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13),
                              ),
                            ),
                          ]),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "任务完成时间",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: LIGHT_TEXT_COLOR,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13),
                            ),
                            new SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Text(
                                updatedTimeStr,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: BLACK_TEXT_COLOR,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13),
                              ),
                            ),
                          ]),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "完成数/总数",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: LIGHT_TEXT_COLOR,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13),
                            ),
                            new SizedBox(
                              width: 20,
                            ),
                            new Container(
                              padding: const EdgeInsets.only(
                                  top: 2.0, bottom: 2, left: 5, right: 5),
                              decoration: BoxDecoration(
                                color: successTotal == total
                                    ? GREEN_COLOR
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(4.0),
                                border: new Border.all(
                                    color: successTotal == total
                                        ? GREEN_COLOR
                                        : LIGHT_TEXT_COLOR,
                                    width: successTotal == total ? 0 : 0.5),
                              ),
                              child: Text(
                                totalStr,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: successTotal == total
                                        ? Colors.white
                                        : BLACK_TEXT_COLOR,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13),
                              ),
                            ),
                          ]),
                      new SizedBox(
                        height: 20,
                      ),
                      //分割线
                      Container(
                          width: prefix0.screen_width - 40,
                          height: 1.0,
                          color: FENGE_LINE_COLOR),
                    ]),
              );
            }),
        // ),
        onRefresh: () async {
          await new Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              _easyRefreshKey.currentState.waitState(() {
                dataList.clear();
                _getListNetCall();
                setState(() {
                  _loadMore = true;
                });
              });
            });
          });
        },
        loadMore: () async {
          await new Future.delayed(const Duration(milliseconds: 600), () {
            _easyRefreshKey.currentState.waitState(() {
              setState(() {
                _loadMore = false;
                if (dataList.length >= listTotalCount && listTotalCount > 0) {
                  return;
                }
                _getListNetCall();
                //延时调用
                // _changeTimer = new Timer(Duration(milliseconds: 600), () {
                //   //监听信息传
                //   SendEvent();
                //   // setState(() {});
                // });
              });
            });
          });
        },
      ),
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
            title1,
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
              // SendEvent();
              _navBack();
              // SendEvent();
              // setState(() {
              //   text11 = '新的文本';
              //   title1 = '的列表';
              // });
            },
          ),
          actions: <Widget>[
            IconButton(
                // icon: Icon(Icons.date_range, color: Colors.black),
                icon: Image.asset(
                  "assets/images/calendar_black.png",
                  // height: 20,
                ),
                tooltip: '日期筛选',
                onPressed: () {
                  _showCalendar();
                  eventChannel
                      .receiveBroadcastStream("showCalendar")
                      .listen(_onEvent, onError: _onError);
                  // do nothing
                }),
          ],
        ),
        body: new Column(
            //这行决定了左对齐
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            //占满剩空间
            children: <Widget>[
              !_calendaring
                  ? emptyContainer
                  : Container(
                      color: Colors.white,
                      // height: 140, //高度不填会自适应
                      padding: const EdgeInsets.only(
                          top: 3.0, bottom: 3, left: 20, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "$beginTimeStr ~ $endTimeStr",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: prefix0.BLACK_TEXT_COLOR,
                                fontWeight: FontWeight.normal,
                                fontSize: 12),
                          ),
                          IconButton(
                            icon: Image.asset(
                              "assets/images/close_black.png",
                              color: Colors.black,
                            ),
                            onPressed: () {
                              // dataList.clear();
                              _getListNetCall();
                              setState(() {
                                params.remove("beginTime");
                                params.remove("endTime");
                                _calendaring = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
              // !_calendaring
              //     ? emptyContainer
              //     : SizedBox(
              //         height: 10,
              //         child: Container(
              //           width: 500.0,
              //           height: 10.0,
              //           color: LIGHT_LINE_COLOR,
              //         ),
              //       ),
              Expanded(
                child: myListView,
              ),
            ]),
      ),
    );
    // //这一句代码改变上方状态栏字体颜色
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }
}
