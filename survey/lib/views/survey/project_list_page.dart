/// @Author: zyg
/// @Date: 2019-07-23
/// @Last Modified by: zyg
/// @Last Modified time: 2019-07-23
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:fluwx/fluwx.dart' as fluwx;

import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/const.dart';
import 'package:sensoro_survey/views/survey/survey_point_information.dart';
import 'package:sensoro_survey/widgets/progressHud.dart';
import 'package:sensoro_survey/generated/easyRefresh/easy_refresh.dart';
import 'package:sensoro_survey/generated/customCalendar/multi_select_style_page.dart';
import 'package:sensoro_survey/generated/customCalendar/lib/flutter_custom_calendar.dart';
import 'package:sensoro_survey/generated/customCalendar/lib/model/date_model.dart';
import 'package:sensoro_survey/views/survey/point_list_page.dart';
import 'package:sensoro_survey/views/survey/add_project_page.dart';
import 'package:sensoro_survey/model/project_info_model.dart';
import 'package:sensoro_survey/views/survey/SurveyPointInformation/summary_construction_page.dart';
import 'package:sensoro_survey/views/survey/common/save_data_manager.dart';
import 'package:sensoro_survey/views/survey/common/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sensoro_survey/net/api/app_api.dart';

//import 'package:fluwx/fluwx.dart' as fluwx;
BasicMessageChannel<String> _basicMessageChannel =
    BasicMessageChannel("BasicMessageGetVersionChannelPlugin", StringCodec());

class ProjectListPage extends StatefulWidget {
  String _text = "share text from fluwx";

//  fluwx.WeChatScene scene = fluwx.WeChatScene.SESSION;

  _ProjectListPageState createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  _ProjectListPageState() {}

  @override
  Widget build(BuildContext context) {
    //要使用路由，根控件就不能是MaterialApp，否则跳转都会无效，解决方法：将 MaterialApp 内容
    // 再使用 StatelessWeight 或 StatefulWeight 包裹一层
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: Text("Flutter Layout Demo"),
      title: "Flutter Layout Demo",

      //   // bottomSheet: bottomButton,
      // ) // This trailing comma makes auto-formatting nicer for build methods.
      home: HomePage(),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//    _initFluwx();
//    fluwx.responseFromShare.listen((data) {
//      print(data.toString());
//    });
  }
}

_launchURL() async {
  if (Platform.isIOS) {
    Future<String> future = _basicMessageChannel.send("1");
    future.then((message) {});
  } else {
    const url = 'https://fir.im/sensoroSurvey';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

Future getVersionData(BuildContext context) async {
  BaseOptions options = BaseOptions(
    method: "get",
    baseUrl: "http://api.fir.im/apps/latest/5d70dd4e23389f4c4ab7a133",
    queryParameters: {
      "api_token": "342bc0fd7fd5b115b3db9bafbd9b02bd",
    },
  );

  Dio netRequest = Dio(options);
  final response = await netRequest.get('');
  Map data = json.decode(response.toString());
  print(data);
  String versionShort = data["versionShort"];
  String version = "";
  if (Platform.isIOS) {
    Future<String> future = _basicMessageChannel.send("");
    future.then((message) {});

    _basicMessageChannel.setMessageHandler((message) => Future<String>(() {
          print(message);
          //message为native传递的数据
          if (message != null && message.isNotEmpty) {
            version = message;
            if (versionShort != null && (version != versionShort)) {
              _showConfirmationDialog(context, "更新");
            }
          }
          //给Android端的返回值
          return "========================收到Native消息：" + message;
        }));
  } else {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    if (versionShort != null && (version != versionShort)) {
      _showConfirmationDialog(context, "更新");
    }
  }

//    print(response.toString());

//    Dio dio = new Dio();
//    Response response=await dio.get("https://www.baidu.com/");
//    print(response.data);
}

Future<bool> _showConfirmationDialog(BuildContext context, String action) {
  final ThemeData theme = Theme.of(context);
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('有新版本更新，立即去更新'),
        actions: <Widget>[
          FlatButton(
            color: theme.buttonColor,
            child: Text(action.substring(0, 1).toUpperCase() +
                action.substring(1, action.length)),
            onPressed: () {
              _launchURL();
              Navigator.pop(context, true);
            },
          ),
          new SizedBox(
            width: 10,
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

_initFluwx() async {
//  await fluwx.register(
//      appId: "wxa65d8bad62a982e1",
//      doOnAndroid: true,
//      doOnIOS: false,
//      enableMTA: false);
//  var result = await fluwx.isWeChatInstalled();
//  print("is installed $result");
}

class HomePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<HomePage> {
  static List dataList = new List(); //static才能在build里使用
  static int listTotalCount = 0;
  bool calendaring = false;
  String beginTimeStr = "";
  String endTimeStr = "";
  String searchStr = "";
  String dateFilterStr = "";
  String btnStr = '新建项目';
  bool isFrist = true;
  bool loading = false;
  bool loadMore = false;
  TimeOfDay _time = TimeOfDay.now();
  final bool confirmDismiss = true;
  List<String> dateFilterList = new List();
  static Map<String, dynamic> headers = {};
  static Map<String, dynamic> params = {};
  static String urlStr = "";

  CalendarController controller;
  TextEditingController searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  FocusNode blankNode = FocusNode();

  // 创建一个给native的channel (类似iOS的通知）
  static const methodChannel =
      const MethodChannel('com.pages.your/project_list');
  static const EventChannel eventChannel =
      const EventChannel("App/Event/Channel", const StandardMethodCodec());

  Timer _changeTimer;
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();

  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();

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

    //微信插件
//    fluwx.register(appId: "wxa6699198d77a32f2");
    testTranslate();

    //延时调用，重新获取window.physicalSize,因为release模式，不同机型有可能先显示页面后获取window.physicalSize
    // _changeTimer = new Timer(Duration(milliseconds: 300), () {
    //   screen_height = window.physicalSize.height;
    //   screen_width = window.physicalSize.width;
    //   prefix0.screen_height = window.physicalSize.height;
    //   prefix0.screen_width = window.physicalSize.width;
    //   setState(() {});
    // });

    loadLocalData();

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

    eventChannel
        .receiveBroadcastStream("sendProjectList")
        .listen(_onEvent, onError: _onError);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        //or set color with: Color(0xFF0000FF)
        // statusBarColor: Colors.blue,
        ));
    getVersionData(context);
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

  void loadLocalData() async {
    String hisoryKey = "projectList";
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
  }

  void deleteData(int index) async {
    String hisoryKey = "projectList";
  }

  void _getListNetCall() async {
    if (dataList.length == 0) {
    } else {}
    ResultData resultData = await AppApi.getInstance()
        .getListNetCall(context, true, urlStr, headers, params);
    if (resultData.isSuccess()) {
      // _stopLoading();
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

  void _onEvent(Object value) {
    if (value is Map) {
      Map dic = value;
      var name = dic["name"];

      if (name == "showCalendar") {
        dataList.clear();
        // _startLoading();
        setState(() {
          calendaring = true;
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
            for (int j = 0; j < dataList.length; j++) {
              projectInfoModel model1 = dataList[j];
              if (model1.projectId == model.projectId &&
                  model1.projectName == model.projectName) {
                Fluttertoast.showToast(
                    msg: "导入的数据和已有的数据重复了",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.black);
                return;
              }
            }
            setState(() {
              dataList.add(model);
            });
          }
          historyStr = str;
          SaveDataManger.addHistory(historyStr, historyKey);
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

  _showCalendar() async {
    //调用flutter日历控件
    final result = await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new MultiSelectStylePage()),
    );

    if (result != null) {
      if (result is List) {
        dateFilterList.clear();

        for (int i = 0; i < result.length; i++) {
          DateModel model = result[i];
          int year = model.year;
          int month = model.month;
          int day = model.day;
          String monthStr = month < 10 ? "0${month}" : "${month}";
          String dayStr = day < 10 ? "0${day}" : "${day}";
          String dateFilterStr = "${year}.${monthStr}.${dayStr}";
          dateFilterList.add(dateFilterStr);
          year = model.year;
        }
        if (dateFilterList.length == 1) {
          dateFilterStr = dateFilterList[0];
        } else {
          dateFilterStr =
              "${dateFilterList[0]}~${dateFilterList[dateFilterList.length - 1]}";
        }
        calendaring = true;
        setState(() {});
      }
    }
    return;
  }

  //调用原生文件导出
  _outputDocument(int index) async {
    projectInfoModel selectModel = dataList[index];
    Map<String, dynamic> json = selectModel.toJson();
    Map<String, dynamic> map = {
      "json": json,
    };
//    StringBuffer stringBuffer = new StringBuffer();
//    map.forEach((String key, dynamic value) {
//      stringBuffer..write(value);
//      stringBuffer..write("\n");
//    });
//    print(stringBuffer.toString());
//    showWxDialog(stringBuffer.toString());
    await methodChannel.invokeMethod('outputDocument', map);
  }

  /**
   * 分享弹窗
   */
  showWxDialog(String res) {
    showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            title: Text("分享到微信"),
            titlePadding: EdgeInsets.all(10),
            backgroundColor: Colors.white,
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6))),
            children: <Widget>[
              ListTile(
                title: Center(
                  child: Text("会话"),
                ),
                onTap: () {
                  Navigator.pop(context);

//                  _shareText(res, fluwx.WeChatScene.SESSION);
                },
              ),
              ListTile(
                title: Center(
                  child: Text("朋友圈"),
                ),
                onTap: () {
                  Navigator.pop(context);

//                  _shareText(res, fluwx.WeChatScene.TIMELINE);
                },
              ),
              ListTile(
                title: Center(
                  child: Text("Close"),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  /**
   * 分享
   */
//  void _shareText(String _text, fluwx.WeChatScene scene) {
//    fluwx
//        .share(fluwx.WeChatShareTextModel(
//            text: _text,
//            transaction: "text${DateTime.now().millisecondsSinceEpoch}",
//            scene: scene))
//        .then((data) {
//      print(data);
//    });
//  }

  @override
  Widget build(BuildContext context) {
    //首次build时获取屏幕宽度等
    initScreenPhysics(context);
    MediaQueryData mediaQuery = MediaQuery.of(context);
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
        // print('用户提变更');
      },
      onChanged: (val) {
        searchStr = val;
        setState(() {});
      },
      controller: searchController,
      cursorWidth: 0,
      cursorColor: Colors.white,
      keyboardType: TextInputType.text,
      //设置输入框文本类型
      textAlign: TextAlign.left,
      //设置内容显示位置是否居中等
      style: new TextStyle(
        fontSize: 13.0,
        color: prefix0.BLACK_TEXT_COLOR,
      ),
      autofocus: false,
      //自动获取焦点
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

        contentPadding: EdgeInsets.fromLTRB(3.0, 20.0, 3.0, 10.0), //设置显示本的一个内边距
// //                border: InputBorder.none,//取默认的下划线边框
      ),
    );

    Widget navBar = AppBar(
      elevation: 1.0,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      centerTitle: true,
      // title: Text(
      //   "项目列表",
      //   style: TextStyle(
      //       color: BLACK_TEXT_COLOR, fontWeight: FontWeight.bold, fontSize: 16),
      // ),
      title: Container(
        height: 40,
        width: prefix0.screen_width,
        // color: prefix0.LIGHT_LINE_COLOR,
        decoration: BoxDecoration(
          color: prefix0.FENGE_LINE_COLOR,
          borderRadius: BorderRadius.circular(20.0),
        ),
        // height: 140, //高度不填会适应
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
              new SizedBox(
                width: 10,
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
            .applyTo(new BouncingScrollPhysics()), // 这个是用来控制能否在不屏的状态下滚动的属性
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
          String time1 = time.substring(0, 11);
          time1 = time1.replaceAll('-', '.');

          bool flag = false;
          if (dateFilterList.length > 0) {
            for (String dateStr in dateFilterList) {
              if (time1.contains(dateStr)) {
                flag = true;
              }
            }
          } else {
            flag = true;
          }
          if (!flag) {
            return emptyContainer;
          }

          if (!name.contains(searchStr) && searchStr.length > 0) {
            return emptyContainer;
          }

          return Dismissible(
            background: Container(
                color: Colors.red,
                child: Center(
                  child: Text(
                    "删除",
                    style: TextStyle(color: Colors.white),
                  ),
                )),
            key: Key("$index"),
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.endToStart) {
                //这里处理数据
                print("这里���理数据");
                //本地存储也去掉
                String historyKey = 'projectList';
                Map<String, dynamic> map = model.toJson();
                String jsonStr = json.encode(map);

                SaveDataManger.deleteHistory(
                  jsonStr,
                  historyKey,
                  model.projectId,
                );
                setState(() {
                  dataList.removeAt(index);
                });
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

                  //这行决定了对齐
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
                            //表示所有的子件都是从左到顺序排列，这是默认值
                            textDirection: TextDirection.ltr,
                            children: <Widget>[
                              //这决定了左对齐
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
                        alignment: Alignment.center,
                        width: prefix0.screen_width,
                        height: 1.0,
                        color: FENGE_LINE_COLOR),
                  ]),
            ),
          );
        });

    Widget myRefreshListView = ProgressDialog(
      loading: loading,
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
                  loadMore = true;
                });
              });
            });
          });
        },
        loadMore: () async {
          await new Future.delayed(const Duration(milliseconds: 600), () {
            _easyRefreshKey.currentState.waitState(() {
              setState(() {
                loadMore = false;
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
      width: mediaQuery.size.width,
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
          !calendaring
              ? emptyContainer
              : Container(
                  color: Colors.white,
                  // height: 140, //高度填会自适应
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
                          calendaring = false;
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
              width: prefix0.screen_width,
              height: 1.0,
              color: FENGE_LINE_COLOR),
          Expanded(
            child: myListView,
          ),
          // bottomButton,
        ],
      ),
    );

    return Scaffold(
        appBar: navBar,
        body: GestureDetector(
          onTap: () {
            // 点击空白页面关闭键盘
            FocusScope.of(context).requestFocus(blankNode);
          },
          child: bodyContiner,
        ),
        bottomNavigationBar: BottomAppBar(
          child: bottomButton,
        )
        // bottomSheet: bottomButton,
        );
  }
}
