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
import 'package:sensoro_survey/views/survey/summary_construction_page.dart';
import 'package:sensoro_survey/widgets/progressHud.dart';
import 'package:sensoro_survey/generated/easyRefresh/easy_refresh.dart';
import 'package:sensoro_survey/views/survey/point_list_page.dart';

class ProjectListPage extends StatefulWidget {
  _ProjectListPageState createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  _ProjectListPageState() {
    final eventBus = new EventBus();
    // ApplicationEvent.event = eventBus;
  }

  static List dataList = new List(); //static才能在build里使用
  static int listTotalCount = 0;
  static const EventChannel eventChannel =
      const EventChannel("App/Event/Channel", const StandardMethodCodec());
  bool _calendaring = false;
  String beginTimeStr = "";
  String endTimeStr = "";
  FocusNode _focusNode = FocusNode();
  bool isFrist = true;

  static Map<String, dynamic> headers = {};
  // 创建一个给native的channel (类似iOS的通知）
  static const methodChannel =
      const MethodChannel('com.pages.your/project_list');
  static int _itemCount = dataList.length;

  Timer _changeTimer;
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();

  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();

  bool _loading = false;
  bool _loadMore = false;
  TimeOfDay _time = TimeOfDay.now();

  @override
  void dispose() {
    super.dispose();
  }

  // 创建一个给native的channel (类似iOS的通知）
  // static const methodChannel = const MethodChannel('com.pages.your/task_test');
  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {}
    });

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        //or set color with: Color(0xFF0000FF)
        // statusBarColor: Colors.blue,
        ));
  }

  void _onEvent(Object value) {
    if (value is Map) {
      Map dic = value;
      var name = dic["name"];

      if (name == "showCalendar") {
        dataList.clear();
        // _startLoading();
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
  }

  // 错误处理
  void _onError(dynamic) {}

  void _addProject() async {
    Map<String, dynamic> aa = {"dd": 5};
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return PointListPage();
    }));
  }

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

  @override
  Widget build(BuildContext context) {
    Widget emptyContainer = Container(
      height: 0,
      width: 0,
    );

    Widget searchbar = TextField(
      //文本输入控件
      // onSubmitted: (String str) {
      //   //提交监听
      //   print('用户提交变更');
      // }
      cursorWidth: 0,
      cursorColor: Colors.white,
      keyboardType: TextInputType.text, //设置输入框文本类型
      textAlign: TextAlign.left,
      //设置内容显示位置是否居中等
      style: new TextStyle(
        fontSize: 13.0,
        color: prefix0.BLACK_TEXT_COLOR,
      ),
      autofocus: false, //自动获取焦点
      decoration: new InputDecoration(
        border: InputBorder.none,
        hintText: "项目名称",
        icon: new Container(
          padding: EdgeInsets.all(0.0),
          child: new Image(
            image: new AssetImage("assets/images/search.png"),
            width: 20,
            height: 20,
            // fit: BoxFit.fitWidth,
          ),
        ),

        contentPadding:
            EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0), //设置显示文本的一个内边距
// //                border: InputBorder.none,//取消默认的下划线边框
      ),
    );

    Widget NavBar = AppBar(
      elevation: 1.0,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      // title: Text(
      //   "项目列表",
      //   style: TextStyle(
      //       color: BLACK_TEXT_COLOR, fontWeight: FontWeight.bold, fontSize: 16),
      // ),
      title: Container(
        height: 40,
        width: 200,
        // color: prefix0.LIGHT_LINE_COLOR,
        decoration: BoxDecoration(
          color: prefix0.FENGE_LINE_COLOR,
          borderRadius: BorderRadius.circular(20.0),
        ),
        // height: 140, //高度不填会自适应
        padding:
            const EdgeInsets.only(top: 0.0, bottom: 0, left: 20, right: 10),
        child: searchbar,
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
    );

    Widget bottomButton = Container(
      color: prefix0.LIGHT_LINE_COLOR,
      height: 60,
      width: prefix0.screen_width,
      child: new MaterialButton(
        color: prefix0.GREEN_COLOR,
        textColor: Colors.white,
        child: new Text('新建项目',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 20)),
        onPressed: () {
          _addProject();
        },
      ),
    );

    Widget myListView = new ListView.builder(
        physics: new AlwaysScrollableScrollPhysics()
            .applyTo(new BouncingScrollPhysics()), // 这个是用来控制能否在不满屏的状态下滚动的属性
        itemCount: dataList.length == 0 ? 5 : 3,
        // separatorBuilder: (BuildContext context, int index) =>
        // Divider(height: 1.0, color: Colors.grey, indent: 20), // 添加分割线
        itemBuilder: (BuildContext context, int index) {
          // print("rebuild index =$index");
          if (dataList.length == 10) {
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
                Text("没���到任何已创建的项目，请添加一个新项目",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: prefix0.LIGHT_TEXT_COLOR,
                        fontWeight: FontWeight.normal,
                        fontSize: 17)),
              ]),
            );
          }

          // if (!(dataList[index - 1] is Map)) {
          //   return emptyContainer;
          // }

          // Map dic = dataList[index];
          // var scheduleNo =
          //     dic["scheduleNo"] == null ? "" : dic["scheduleNo"];
          // var contact = dic["contact"];
          // var name = contact["name"] == null ? "" : contact["name"];
          // var total = "0";
          // var successTotal = "0";
          // if (dic["complete"] != null) {
          //   successTotal = dic["complete"].toString();
          // }
          // if (dic["total"] != null) {
          //   total = dic["total"].toString();
          // }
          // var totalStr = "$successTotal/$total";
          // var updatedTimeStr = dic["updatedTime"].toString();
          // var updatedTime = dic["updatedTime"].toInt();
          // var type = dic["type"] == null ? "" : dic["type"];
          // var content = dic["content"] == null ? "" : dic["content"];
          // var rules = dic["rules"];
          // var typeStr = "";
          // var contentStr = "";

          // DateTime date =
          //     new DateTime.fromMillisecondsSinceEpoch(updatedTime);
          // updatedTimeStr = date.toString();
          // updatedTimeStr = updatedTimeStr.substring(0, 19);
          // print("updatedTimeStr = $updatedTimeStr");

          return new Container(
            color: Colors.white,
            // decoration: const BoxDecoration(
            //   border: Border(
            //  bottom:
            //   ),
            // ),
            // height: 140, //高度不填会自适应
            padding:
                const EdgeInsets.only(top: 0.0, bottom: 0, left: 0, right: 0),
            child: new Column(

                //这行决定了左对齐
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    color: LIGHT_LINE_COLOR,
                    height: 12,
                    width: prefix0.screen_width,
                  ),

                  Container(
                    padding: const EdgeInsets.only(
                        top: 0.0, bottom: 0, left: 20, right: 20),
                    child: Row(
                        //Row 中mainAxisAlignment是水平的，Column中是垂直的
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //表示所有的子控件都是从左到右顺序排列，这是默认值
                        textDirection: TextDirection.ltr,
                        children: <Widget>[
                          //这行决定了左对齐
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              //这个位置用ListTile就会报错
                              Text("批次号",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: prefix0.BLACK_TEXT_COLOR,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 17)),
                              Text("2019-09-29",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: prefix0.BLACK_TEXT_COLOR,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 17)),
                            ],
                          ),

                          new SizedBox(
                            width: 10,
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new RaisedButton(
                                color: Colors.orange,
                                textColor: Colors.white,
                                child: new Text('编辑'),
                                onPressed: () {
                                  _addProject();
                                },
                              ),
                              new RaisedButton(
                                color: prefix0.LIGHT_TEXT_COLOR,
                                textColor: Colors.white,
                                child: new Text('导出'),
                                onPressed: () {

                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(builder: (context) => new SummaryConstructionPage()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ]),
                  ),
                  //分割线
                  Container(
                      width: prefix0.screen_width - 40,
                      height: 1.0,
                      color: FENGE_LINE_COLOR),
                ]),
          );
        });

    Widget myRefreshListView = ProgressDialog(
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
          loadedText: loadFinish_localString,
          noMoreText: loadFinish_localString,
          moreInfo: "",
          bgColor: LIGHT_LINE_COLOR,
          textColor: Colors.black87,
          moreInfoColor: Colors.black54,
          showMore: true,
        ),
        child: myListView,
        onRefresh: () async {
          await new Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              _easyRefreshKey.currentState.waitState(() {
                dataList.clear();
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
              });
            });
          });
        },
      ),
    );

    final navigatorKey = GlobalKey<NavigatorState>();
    return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        // title: Text("Flutter Layout Demo"),
        title: "Flutter Layout Demo",
        home: Scaffold(
            appBar: NavBar,
            body: Container(
              color: Colors.white,
              // height: 140, //高度不填会自适应
              padding:
                  const EdgeInsets.only(top: 0.0, bottom: 0, left: 0, right: 0),
              child: myListView,
            ),
            bottomSheet: Builder(builder: (context) {
              return GestureDetector(
                onTap: () {
                  _addProject(); //自己封装的跳转方法，忽略
                },
                child: bottomButton,
              );
            })) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
