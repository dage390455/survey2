/// @Author: zyg
/// @Date: 2019-07-23
/// @Last Modified by: zyg
/// @Last Modified time: 2019-07-23
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/model/date_model.dart';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/const.dart';
import 'package:sensoro_survey/views/survey/survey_point_information.dart';
import 'package:sensoro_survey/widgets/progressHud.dart';
import 'package:sensoro_survey/generated/easyRefresh/easy_refresh.dart';
import 'package:sensoro_survey/generated/customCalendar/multi_select_style_page.dart';
import 'package:sensoro_survey/views/survey/point_list_page.dart';
import 'package:sensoro_survey/views/survey/add_project_page.dart';
import 'package:sensoro_survey/model/project_info_model.dart';
import 'package:sensoro_survey/views/survey/SurveyPointInformation/summary_construction_page.dart';
import 'package:sensoro_survey/views/survey/comment/save_data_manager.dart';

class ProjectListPage extends StatefulWidget {
  _ProjectListPageState createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  _ProjectListPageState() {
    final eventBus = new EventBus();
    // ApplicationEvent.event = eventBus;
  }

  @override
  Widget build(BuildContext context) {
    //要使用路由，根控件就不能是MaterialApp，否则跳转都会无效，解决方法：将 MaterialApp 内容
    // 再使用 StatelessWeight 或 StatefulWeight 包裹一层
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: Text("Flutter Layout Demo"),
      title: "Flutter Layout Demo",
      // home: Scaffold(
      //   appBar: NavBar,
      //   body: new Home1(),
      //   bottomSheet: bottomButton,
      //   // bottomSheet: bottomButton,
      // ) // This trailing comma makes auto-formatting nicer for build methods.
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<HomePage> {
  static List dataList = new List(); //static才能在build里使用
  static int listTotalCount = 0;
  static const EventChannel eventChannel =
      const EventChannel("App/Event/Channel", const StandardMethodCodec());
  bool _calendaring = false;
  String beginTimeStr = "";
  String endTimeStr = "";
  // int beginTime = 0;
  // int endTime = 0;
  FocusNode _focusNode = FocusNode();
  bool isFrist = true;
  TextEditingController searchController = TextEditingController();
  String searchStr = "";
  String dateFilterStr = "";
  List<String> dateFilterList = new List();
  String btnStr = '新建项目';
  projectInfoModel selectModel = projectInfoModel("", "", 1, "", []);

  CalendarController controller;
  // String dateText = "${DateTime.now().year}年${DateTime.now().month}月";
  // CalendarViewWidget({@required this.calendarController, this.boxDecoration});

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
  final bool confirmDismiss = true;

  Future<String> get token async {
    final sp = await SharedPreferences.getInstance();
    var value = sp.get("token");
    return sp.get("token") ?? "";
  }

  set token(value) {
    SharedPreferences.getInstance().then((sp) {
      sp.setString("token", value);
    });
  }

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

    testTranslate();

    //延时调用，重新获取window.physicalSize,因为release模式，不同机型有可能先显示页面后获取window.physicalSize
    _changeTimer = new Timer(Duration(milliseconds: 300), () {
      screen_height = window.physicalSize.height;
      screen_width = window.physicalSize.width;
      prefix0.screen_height = window.physicalSize.height;
      prefix0.screen_width = window.physicalSize.width;
      setState(() {});
      // setState(() {});
    });

    loadLocalData();
    // getData();
    // saveData();
    // token = "aaa";

    controller = new CalendarController();
    controller.addMonthChangeListener(
      (year, month) {
        setState(() {
          // dateText = "$year年$month月";
        });
      },
    );

    controller.addOnCalendarSelectListener((dateModel) {
      //刷新选择的时间
      setState(() {});
    });

    // eventChannel
    //     .receiveBroadcastStream("sendHistory")
    //     .listen(_onEvent, onError: _onError);
    eventChannel
        .receiveBroadcastStream("sendProjectList")
        .listen(_onEvent, onError: _onError);
    //测试用
    // this.initDetailList();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        //or set color with: Color(0xFF0000FF)
        // statusBarColor: Colors.blue,
        ));
  }

//测试JSON ，LIST ,MAP ,MODEL的转换
  void testTranslate() {
    // String teststr =
    // "[{\'remark' : \'ii',\'createTime' : \'2019-08-22 16:58'},{\'remark' : \'oo',\'createTime' : \'2019-08-22 16:22'}]";
//    String teststr = "[{\"remark\":\"ii\"},{\"remark\":\"ii\"}]";
//    List<dynamic> user = jsonDecode(teststr);
//    String teststr2 = jsonEncode(user);
//
//    projectInfoModel model = projectInfoModel("name", "des", 1, "备注11", []);
//    projectInfoSubModel model1 = projectInfoSubModel("name1", "des1");
//    projectInfoSubModel model2 = projectInfoSubModel("name2", "des2");
//    List<projectInfoSubModel> sublist = [model1, model2];
//    model.subList = sublist;
//
//    Map<String, dynamic> json = model.toJson();
//    List<Map<String, dynamic>> list = [json, json];
//    String teststr3 = jsonEncode(list);
//    List<dynamic> user2 = jsonDecode(teststr3);
//
//    //model转JSONrr
//    String teststr4 = "";
    // model.subList = {};
  }

  // void saveData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setInt('counter', 5);
  // }

  // void getData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final counter = prefs.getInt('counter') ?? 0;
  //   final counter1 = prefs.getInt('counter') ?? 0;
  //   print("countet = $counter");
  //   if (counter > 0) {
  //     btnStr = "已有项目";
  //     setState(() {});
  //   }
  // }

  void loadLocalData() async {
    String hisoryKey = "projectList";
    // List<String> tags = [];
    List<dynamic> list = [];
    list = await SaveDataManger.getProjectHistory(hisoryKey);
    setState(() {
      dataList.clear();
      for (int i = 0; i < list.length; i++) {
        Map<String, dynamic> map = list[i];
        projectInfoModel model = projectInfoModel.fromJson(map);
        dataList.add(model);
      }
    });

    // String tags = jsonEncode(list);
    // setState(() {
    //   dataList.clear();
    //   for (int i = 0; i < tags.length; i++) {
    //     // Map<String, dynamic> map = tags[i];
    //     String jsonStr = tags[i];
    //     if (jsonStr == null || jsonStr.length < 3) {
    //       continue;
    //     }
    //     // String jsonStr1 = jsonStr.replaceAll(';', ',');
    //     Map<String, dynamic> map = json.decode(jsonStr);
    //     projectInfoModel model = projectInfoModel.fromJson(map);
    //     dataList.add(model);
    //   }
    // });
  }

  void deleteData(int index) async {
    String hisoryKey = "projectList";
  }

//  void initDetailList() {
//    for (int index = 0; index < 1000; index++) {
//      var name = "测试设备 $index";
//      name = "FAGJKJVXOE63S";
//      if (index % 3 == 0) name = "项目1118888";
//      if (index % 3 == 1) name = "项��222";
//      if (index % 3 == 2) name = "项目333";
//
//      var des = "状态 $index ��常";
//      des = "11:04:12";
//      if (index == 1) des = "2019-07-03 10:54";
//      if (index == 2) des = "2019-07-06 15:24";
//      if (index == 3) des = "2019-07-22 02:14:09";
//
//      projectInfoModel model = projectInfoModel(name, des, index, "备注11", []);
//      dataList.add(model);
//      // var a = 'dd';
//      // a = cityDetailArrays[index].name;
//    }
//  }

  void _onEvent(Object value) {
    if (value is Map) {
      Map dic = value;
      var name = dic["name"];

      if (name == "showCalendar") {
        dataList.clear();
        // _startLoading();
        setState(() {
          _calendaring = true;
          int beginTime = dic["beginTime"].toInt();
          int endTime = dic["endTime"].toInt();
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

      if (name == "sendHistory") {
        //把history历史写入share_preference
        Map dic = value;
        Map historyDic = dic["value"];

        for (String key in historyDic.keys) {
          String value = historyDic[key];
          SaveDataManger.addHistory(value, key);
        }
      }

      if (name == "sendOneProject") {
        String projectListStr = dic["projectListStr"].toString();
        // List<String> list = projectListStr.split(',');
        List<String> list = projectListStr.split(';');
        String historyKey = 'projectList';

        String historyStr = "";
        //外部导入文件的情况
        if (list.length == 1) {
          String str = list[0];
          if (str == null || str.length < 3) {
            return;
          }
          str = str.replaceAll(';', ',');
          str = str.replaceAll('subList\":}', 'subList\":[]}');
          String str1 = '[' + str + ']';
          List<dynamic> jsonList = jsonDecode(str1);
          for (int i = 0; i < jsonList.length; i++) {
            Map<String, dynamic> map = jsonList[i];
            if (map["subList"] == null) {
              map["subList"] = [];
            }
            projectInfoModel model = projectInfoModel.fromJson(map);
            dataList.add(model);
          }
          historyStr = str;
          SaveDataManger.addProjectHistory(historyStr, historyKey);
        }
      }

      if (name == "sendProjectList") {
        String projectListStr = dic["projectListStr"].toString();
        // List<String> list = projectListStr.split(',');
        List<String> list = projectListStr.split(';');
        String historyKey = 'projectList';
        String historyStr = "";
        for (int i = 0; i < list.length; i++) {
          String str = list[i];
          if (str.length > 0) {
            if (str == null || str.length < 3) {
              continue;
            }
            // if (!str.contains('[') && !str.contains(']')) {
            //   str = "[" + str + "]";
            // }
            str = str.replaceAll(';', ',');
            str = str.replaceAll('subList\":}', 'subList\":[]}');
            String str1 = '[' + str + ']';
            List<dynamic> jsonList = jsonDecode(str1);
            for (int i = 0; i < jsonList.length; i++) {
              Map<String, dynamic> map = jsonList[i];
              if (map["subList"] == null) {
                map["subList"] = [];
              }
              projectInfoModel model = projectInfoModel.fromJson(map);
              dataList.add(model);
            }
            // projectInfoModel model = projectInfoModel.fromJson(map);
            //把native发来的数据发给share_preferences保存下来
            //原来过来的数据存储share_preference
            if (historyStr.length == 0) {
              historyStr = str;
            } else {
              historyStr = historyStr + ',' + str;
            }
          }
        }
        //historyStr这种格式的 "{"projectName":"ttttttuuuuyyyy"}
        SaveDataManger.addProjectHistory(historyStr, historyKey);
      }

      setState(() {});
      return;
    }
  }

  // 错误处理
  void _onError(dynamic) {}

  _navBack() async {
    Map<String, dynamic> map = {
      "code": "200",
      "data": [0, 0, 0]
    };
    await methodChannel.invokeMethod('navBack', map);
  }

  _showCalendar() async {
    //调用flutter日历控件
    final result = await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new MultiSelectStylePage()),
    );

    if (result != null) {
      if (result is Set) {
        dateFilterList.clear();
        for (DateModel model in result) {
          int year = model.year;
          int month = model.month;
          int day = model.day;
          String monthStr = month < 10 ? "0${month}" : "${month}";
          String dayStr = day < 10 ? "0${day}" : "${day}";
          String dateFilterStr = "${year}-${monthStr}-${dayStr}";
          dateFilterList.add(dateFilterStr);
          year = model.year;
        }
        if (dateFilterList.length == 1) {
          dateFilterStr = dateFilterList[0];
        }
        if (dateFilterList.length == 2) {
          dateFilterStr = "${dateFilterList[0]},${dateFilterList[1]}";
        }
        if (dateFilterList.length > 2) {
          dateFilterStr = "${dateFilterList[0]},${dateFilterList[1]}等";
        }
        _calendaring = true;
        setState(() {});
      }
    }
    return;
    //调用IOS原生日历组件
    // Map<String, dynamic> map = {
    //   "beginTime": beginTime > 10000 ? beginTime / 1000 : 0,
    //   "endTime": endTime > 10000 ? endTime / 1000 : 0,
    // };
    // await methodChannel.invokeMethod('showCalendar', map);
  }

  //调用原生文件导出
  _outputDocument(int index) async {
    selectModel = dataList[index];
    Map<String, dynamic> json = selectModel.toJson();
    Map<String, dynamic> map = {
      "json": json,
    };
    await methodChannel.invokeMethod('outputDocument', map);
  }

  Widget _createDialog(
      String _confirmContent, Function sureFunction, Function cancelFunction) {
    return AlertDialog(
      title: Text('Confirm'),
      content: Text(_confirmContent),
      actions: <Widget>[
        FlatButton(onPressed: sureFunction, child: Text('确认')),
        FlatButton(onPressed: cancelFunction, child: Text('删除')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    void _gotoPoint(int index) async {
      // projectInfoModel model = projectInfoModel("", "", 1, "");
      final result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new PointListPage(input: dataList[index])),
      );

      if (result != null) {
        String name = result as String;
        if (name == "refreshList") {
          loadLocalData();
        }
        // this.name = name;
        setState(() {});
      }
    }

    void _editProject(projectInfoModel model) async {
      // projectInfoModel model = projectInfoModel("", "", 1, "");
      final result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new AddProjectPage(input: model)),
      );

      if (result != null) {
        String name = result as String;
        if (name == "refreshList") {
          loadLocalData();
        }
        // this.name = name;
        setState(() {});
      }
    }

    void _addProject() async {
      projectInfoModel model = projectInfoModel("", "", 1, "", []);
      final result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new AddProjectPage(input: model)),
      );

      if (result != null) {
        String name = result as String;
        if (name == "refreshList") {
          loadLocalData();
        }
        // this.name = name;
        setState(() {});
      }
    }

    Widget emptyContainer = Container(
      height: 0,
      width: 0,
    );

    Widget searchbar = TextField(
      //文本输入控件
      onSubmitted: (String str) {
        //提交监听
        // searchStr = val;
        // print('用户提���变更');
      },
      onChanged: (val) {
        searchStr = val;
        setState(() {});
      },
      controller: searchController,
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

        suffixIcon: new IconButton(
            icon: Image.asset(
              "assets/images/close_black.png",
              // height: 20,
            ),
            tooltip: '消除',
            onPressed: () {
              searchController.clear();
              searchStr = "";
              setState(() {});
            }),

        contentPadding:
            EdgeInsets.fromLTRB(3.0, 20.0, 3.0, 10.0), //设置显示��本的一个内边距
// //                border: InputBorder.none,//取���默认的下划线边框
      ),
    );

    Widget navBar = AppBar(
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
        // height: 140, //高度不填会���适应
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

    Future<bool> _showConfirmationDialog(BuildContext context, String action) {
      final ThemeData theme = Theme.of(context);
      return showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('你想${action}这一条数据吗?'),
            actions: <Widget>[
              FlatButton(
                color: theme.buttonColor,
                child: Text(action.substring(0, 1).toUpperCase() +
                    action.substring(1, action.length)),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              FlatButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        },
      );
    }

    Widget myListView = new ListView.builder(
        physics: new AlwaysScrollableScrollPhysics()
            .applyTo(new BouncingScrollPhysics()), // 这个是用来控制能否在不�����屏的状态下滚动的属性
        itemCount: dataList.length == 0 ? 1 : dataList.length,
        // separatorBuilder: (BuildContext context, int index) =>
        // Divider(height: 1.0, color: Colors.grey, indent: 20), // 添加分割线
        itemBuilder: (BuildContext context, int index) {
          // print("rebuild index =$index");
          if (dataList.length == 0) {
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
                Text("没有任何已创建的项目，请添加一个新项目",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: prefix0.LIGHT_TEXT_COLOR,
                        fontWeight: FontWeight.normal,
                        fontSize: 17)),
              ]),
            );
          }

          projectInfoModel model = dataList[index];
          var name = model.projectName;
          var time = model.createTime;

          bool flag = false;
          if (dateFilterList.length > 0) {
            for (String dateStr in dateFilterList) {
              if (time.contains(dateStr)) {
                flag = true;
              }
            }
          } else {
            flag = true;
          }
          if (!flag) {
            return emptyContainer;
          }
          this.selectModel = model;

          if (!name.contains(searchStr) && searchStr.length > 0) {
            return emptyContainer;
          }

          return Dismissible(
            key: Key("$index"),
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.endToStart) {
                //这里处理数据
                print("object");
              }
            },
            direction: DismissDirection.endToStart,
            // direction: DismissDirection.up,
            confirmDismiss: !confirmDismiss
                ? null
                : (DismissDirection dismissDirection) async {
                    switch (dismissDirection) {
                      case DismissDirection.endToStart:
                        return await _showConfirmationDialog(context, '删除') ==
                            true;
                      case DismissDirection.startToEnd:
                        return false;
                      // return await _showConfirmationDialog(
                      //         context, 'delete') ==
                      //     true;
                      case DismissDirection.horizontal:
                      case DismissDirection.vertical:
                      case DismissDirection.up:
                      case DismissDirection.down:
                        assert(false);
                    }
                    return false;
                  },
            // confirmDismiss: confirmDismiss1,
            child: new Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.only(top: 0.0, bottom: 0, left: 0, right: 0),
              child: new Column(

                  //这行决定了�������对齐
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      color: LIGHT_LINE_COLOR,
                      height: 12,
                      width: prefix0.screen_width,
                    ),

                    GestureDetector(
                      onTap: () {
                        _gotoPoint(index);
                      },
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.only(
                            top: 0.0, bottom: 0, left: 20, right: 20),
                        child: Row(
                            //Row 中mainAxisAlignment是水平的，Column中是垂直的
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //表示所有的子��件都是从左到��顺序排列，这是默认值
                            textDirection: TextDirection.ltr,
                            children: <Widget>[
                              //这��决定了左对齐
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      //这个位置用ListTile就会报错
                                      // Expanded(
                                      Text(name,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: prefix0.BLACK_TEXT_COLOR,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 17)),
                                      // ),
                                      new SizedBox(
                                        height: 2,
                                      ),
                                      Text(time,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: prefix0.BLACK_TEXT_COLOR,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 17)),
                                    ],
                                  ),
                                ),
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
                                      _editProject(model);
                                    },
                                  ),
                                  new RaisedButton(
                                    color: prefix0.LIGHT_TEXT_COLOR,
                                    textColor: Colors.white,
                                    child: new Text('导出'),
                                    onPressed: () {
                                      _outputDocument(index);
                                    },
                                  ),
//                                  new RaisedButton(
//                                    color: prefix0.LIGHT_TEXT_COLOR,
//                                    textColor: Colors.white,
//                                    child: new Text('入口'),
//                                    onPressed: () {
//                                      Navigator.push(
//                                        context,
//                                        new MaterialPageRoute(
//                                            builder: (context) =>
//                                                new SurveyPointInformationPage()),
//                                      );
//                                    },
//                                  ),
                                ],
                              ),
                            ]),
                      ),
                    ),

                    //分割线
                    Container(
                        width: prefix0.screen_width - 40,
                        height: 1.0,
                        color: FENGE_LINE_COLOR),
                  ]),
            ),
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

    Widget bottomButton = new Container(
      color: LIGHT_LINE_COLOR,
      height: 60,
      width: screen_width,
      child: new RaisedButton(
        color: GREEN_COLOR,
        textColor: Colors.white,
        child: new Text(this.btnStr,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 20)),
        onPressed: () {
          _addProject();
          // projectInfoModel model = projectInfoModel("", "", 0, "");
          // Navigator.push(
          //   context,
          //   new MaterialPageRoute(
          //       builder: (context) => new AddProjectPage(input: model)),
          // );
        },
      ),
    );

    Widget bodyContiner = new Container(
      color: Colors.white,
      // height: 140, //高度不填会自适应
      padding: const EdgeInsets.only(top: 0.0, bottom: 0, left: 0, right: 0),
      child: Column(
        //这行决定了左对齐
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        // "$beginTimeStr ~ $endTimeStr",
                        dateFilterStr.length > 0 ? dateFilterStr : "",
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
                          _calendaring = false;
                          this.dateFilterList.clear();
                          this.dateFilterStr = "";
                          loadLocalData();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
          //分割线
          Container(
              width: prefix0.screen_width - 40,
              height: 1.0,
              color: FENGE_LINE_COLOR),
          Expanded(
            child: myListView,
          ),
          bottomButton,
        ],
      ),
    );

    return Scaffold(
      appBar: navBar,
      body: bodyContiner,
      // bottomSheet: bottomButton,
    );
  }
}
