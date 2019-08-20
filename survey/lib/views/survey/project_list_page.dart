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

import 'package:sensoro_survey/views/survey/survey_point_information.dart';
import 'package:sensoro_survey/widgets/progressHud.dart';
import 'package:sensoro_survey/generated/easyRefresh/easy_refresh.dart';
import 'package:sensoro_survey/views/survey/point_list_page.dart';
import 'package:sensoro_survey/views/survey/add_project_page.dart';
import 'package:sensoro_survey/model/project_info_model.dart';
import 'package:sensoro_survey/views/survey/SurveyPointInformation/summary_construction_page.dart';
import 'package:sensoro_survey/views/survey/comment/SaveDataManger.dart';

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
      home: Home1(),
    );
  }
}

class Home1 extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Home1> {
  static List dataList = new List(); //static才能在build里使用
  static int listTotalCount = 0;
  static const EventChannel eventChannel =
      const EventChannel("App/Event/Channel", const StandardMethodCodec());
  bool _calendaring = false;
  String beginTimeStr = "";
  String endTimeStr = "";
  int beginTime = 0;
  int endTime = 0;
  FocusNode _focusNode = FocusNode();
  bool isFrist = true;
  String searchStr = "";

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

  projectInfoModel myModel = projectInfoModel("", "", 1, "");

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

    loadLocalData();

    //测试用
    // this.initDetailList();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        //or set color with: Color(0xFF0000FF)
        // statusBarColor: Colors.blue,
        ));
  }

  void loadLocalData() async {
    String hisoryKey = "projectList";
    List<String> tags = [];
    tags = await SaveDataManger.getHistory(hisoryKey);
    setState(() {
      dataList.clear();
      for (int i = 0; i < tags.length; i++) {
        String jsonStr = tags[i];
        jsonStr = jsonStr.replaceAll(';', ',');

        Map<String, dynamic> map = json.decode(jsonStr);
        projectInfoModel model = projectInfoModel.fromJson(map);
        dataList.add(model);
      }
    });
  }

  void initDetailList() {
    for (int index = 0; index < 1000; index++) {
      var name = "测试设备 $index";
      name = "FAGJKJVXOE63S";
      if (index % 3 == 0) name = "项目1118888";
      if (index % 3 == 1) name = "项目222";
      if (index % 3 == 2) name = "项目333";

      var des = "状态 $index ��常";
      des = "11:04:12";
      if (index == 1) des = "2019-07-03 10:54";
      if (index == 2) des = "2019-07-06 15:24";
      if (index == 3) des = "2019-07-22 02:14:09";

      projectInfoModel model = projectInfoModel(name, des, index, "备注11");
      dataList.add(model);
      // var a = 'dd';
      // a = cityDetailArrays[index].name;
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
          _calendaring = true;
          beginTime = dic["beginTime"].toInt();
          endTime = dic["endTime"].toInt();
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

  _navBack() async {
    Map<String, dynamic> map = {
      "code": "200",
      "data": [0, 0, 0]
    };
    await methodChannel.invokeMethod('navBack', map);
  }

  _showCalendar() async {
    Map<String, dynamic> map = {
      "beginTime": beginTime > 10000 ? beginTime / 1000 : 0,
      "endTime": endTime > 10000 ? endTime / 1000 : 0,
    };
    await methodChannel.invokeMethod('showCalendar', map);
  }

  @override
  Widget build(BuildContext context) {
    void _gotoPoint() async {
      // projectInfoModel model = projectInfoModel("", "", 1, "");
      final result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new PointListPage(input: myModel)),
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
      projectInfoModel model = projectInfoModel("", "", 1, "");
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
        // print('用户提交变更');
      },
      onChanged: (val) {
        searchStr = val;
        setState(() {});
      },
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

    Widget myListView = new ListView.builder(
        physics: new AlwaysScrollableScrollPhysics()
            .applyTo(new BouncingScrollPhysics()), // 这个是用来控制能否在不�����屏的状态下滚动的属性
        itemCount: dataList.length == 0 ? 5 : dataList.length,
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

          projectInfoModel model = dataList[index];
          var name = model.projectName;
          var time = model.createTime;

          projectInfoModel model1 = projectInfoModel("", "", 1, "");
          this.myModel = model;

          if (!name.contains(searchStr) && searchStr.length > 0) {
            return emptyContainer;
          }

          return Container(
            color: Colors.white,
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

                  GestureDetector(
                    onTap: _gotoPoint,
                    child: Container(
                      color: Colors.white,
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
                                Text(name,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: prefix0.BLACK_TEXT_COLOR,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 17)),
                                Text(time,
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
                                    _editProject(model);

                                    // Navigator.push(
                                    //   context,
                                    //   new MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           new AddProjectPage(input: model)),
                                    // );
                                  },
                                ),
                                new RaisedButton(
                                  color: prefix0.LIGHT_TEXT_COLOR,
                                  textColor: Colors.white,
                                  child: new Text('导出'),
                                  onPressed: () {
                                    Navigator.push(
                                      context,

                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              new SurveyPointInformationPage()),
//=======
//                                    new MaterialPageRoute(
//                                        builder: (context) =>
//                                            new SummaryConstructionPage()),
//>>>>>>> f6809553813ee7414472fb92cdee210d1128d705
                                    );
                                  },
                                ),
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

    Widget bottomButton = Container(
      color: prefix0.LIGHT_LINE_COLOR,
      height: 60,
      width: prefix0.screen_width,
      child: new RaisedButton(
        color: prefix0.GREEN_COLOR,
        textColor: Colors.white,
        child: new Text('新建项目',
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
                          // _getListNetCall();
                          setState(() {
                            // params.remove("beginTime");
                            // params.remove("endTime");
                            _calendaring = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
          Expanded(
            child: myListView,
          ),
          // bottomButton,
        ],
      ),
    );

    return Scaffold(
      appBar: NavBar,
      body: bodyContiner,
      bottomSheet: bottomButton,
    );
  }
}
