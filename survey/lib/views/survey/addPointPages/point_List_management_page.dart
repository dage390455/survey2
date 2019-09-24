import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sensoro_survey/generated/customCalendar/lib/controller.dart';
import 'package:sensoro_survey/model/project_info_model.dart';
import 'package:sensoro_survey/net/api/app_api.dart';
import 'package:sensoro_survey/net/api/net_config.dart';
import 'package:sensoro_survey/views/survey/addPointPages/point_risk_type_select_page.dart';
import 'package:sensoro_survey/views/survey/common/data_transfer_manager.dart';
import 'package:sensoro_survey/views/survey/commonWidegt/SearchView.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/sitePages/Model/SitePageModel.dart';
import 'package:sensoro_survey/views/survey/sitePages/buildinglist_page.dart';
import 'package:sensoro_survey/views/survey/sitePages/creat_site_page.dart';
import 'package:sensoro_survey/views/survey/sitePages/sqflite_page.dart';
import 'package:sensoro_survey/views/survey/add_point_page.dart';
import 'package:sensoro_survey/views/survey/add_project_page.dart';

import '../const.dart';
import '../point_content_page.dart';
import 'Model/PointListModel.dart';

class PointListManagementPage extends StatefulWidget {
  PointListManagementPage({Key key, this.title, this.input}) : super(key: key);

  projectInfoModel input;
  final String title;

  @override
  _PointListManagementPageState createState() =>
      _PointListManagementPageState(this.input);
}

class _PointListManagementPageState extends State<PointListManagementPage> {
  projectInfoModel input;
  BasicMessageChannel _locationBasicMessageChannel = BasicMessageChannel(
      "BasicMessageChannelPluginGetCity", StandardMessageCodec());
  _PointListManagementPageState(this.input);
  bool calendaring = false;
  String beginTimeStr = "";
  String endTimeStr = "";
  String searchStr = "";
  String dateFilterStr = "";
  CalendarController controller;

  TextEditingController searchController = TextEditingController();
  List<PointListModel> dataList = [];

  void _startManagePage(SitePageModel data) async {
    DataTransferManager.shared.creatModel();
    final result = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute(builder: (BuildContext context) {
      return new PointRiskTypeSelectPage();
    }));

    if (result != null) {
      String name = result as String;
      if (name == "refreshList") {}
      dataList.clear();
      getListNetCall();
      setState(() {});
    }
  }

  void _gotoPoint(int index) async {
    final result = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute(builder: (BuildContext context) {
      return new PointContentPage(input: input,model: dataList[index],);
    }));

    if (result != null) {
      String name = result as String;
      if (name == "refreshList") {
//        loadLocalData();
        dataList.clear();
        getListNetCall();
      }
      // this.name = name;
      setState(() {});
    }
  }

  void _creatSite(SitePageModel model, bool isCreat) async {
    DataTransferManager.shared.creatModel();
    final result = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute(builder: (BuildContext context) {
      return new PointRiskTypeSelectPage();
    }));

    if (result != null) {
      getListNetCall();
    }
  }

  void _textSql() async {
    Future<String> future = _locationBasicMessageChannel.send("000000");
    future.then((message) {
      print("========================" + message);
    });
  }

  Future getListNetCall() async {
    String urlStr = NetConfig.pointListUrl + input.projectId + "&keyword=" + searchStr;
    Map<String, dynamic> headers = {};
    Map<String, dynamic> params = {};

    ResultData resultData = await AppApi.getInstance()
        .getListNetCall(context, true, urlStr, headers, params);
    if (resultData.isSuccess()) {
      // _stopLoading();
      dataList.clear();
      int code = resultData.response["code"].toInt();
      if (code == 200) {
        if (resultData.response["data"]["records"] is List) {
          List resultList = resultData.response["data"]["records"];
          if (resultList.length > 0) {
            for (int i = 0; i < resultList.length; i++) {
              Map json = resultList[i] as Map;
              PointListModel model = PointListModel.fromJson(json);
              if (model != null) {
                dataList.add(model);
              }
            }
          }
          setState(() {});
        }
      }
    }
  }

  void _addPoint() async {
    projectInfoModel model = projectInfoModel(
        input.projectId.toString(), "", "", "", "", "", "", []);

    final result = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute(builder: (BuildContext context) {
      return new AddPointPage(input: model);
    }));

    if (result != null) {
      String name = result as String;
      if (name == "refreshList") {
        dataList.clear();
        getListNetCall();
      }
      // this.name = name;
      setState(() {});
    }
  }

  void _editProject() async {
    final result = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute(builder: (BuildContext context) {
      return new AddProjectPage(
        input: input,
        isEdit: true,
      );
    }));

    if (result != null) {
      String name = result as String;
      if (name == "refreshList") {
//        loadLocalData();
        dataList.clear();
        getListNetCall();
      }
      // this.name = name;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _locationBasicMessageChannel
        .setMessageHandler((message) => Future<String>(() {
              print(message);
              //message为native传递的数据
              //给Android端的返回值
              return "========================收到Native消息：" + message;
            }));

    getListNetCall();
  }

  @override
  Widget build(BuildContext context) {
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
        hintText: "场所名称",
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
      leading: IconButton(
        icon: Image.asset(
          "assets/images/back.png",
          // height: 20,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(input.projectName),
      actions: <Widget>[
        Container(
          padding: new EdgeInsets.fromLTRB(0, 0, 20, 0),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              _editProject();
            },
            child: Text(
              "详情",
              style: TextStyle(
                color: prefix0.GREEN_COLOR,
              ),
            ),
          ),
        ),
      ],
    );

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
                Text("暂无勘察点",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: prefix0.LIGHT_TEXT_COLOR,
                        fontWeight: FontWeight.normal,
                        fontSize: 17)),
              ]),
            );
          }

          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
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
                        height: 80,
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
                                  child: Text(dataList[index].name,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: prefix0.BLACK_TEXT_COLOR,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 17)),
                                ),
                              ),
                              Image.asset(
                                "assets/images/right_arrar.png",
                                width: 20,
                              ),
                              new SizedBox(
                                width: 10,
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
            secondaryActions: <Widget>[
//              IconSlideAction(
//                caption: '删除',
//                color: Colors.red,
//                icon: Icons.delete,
//                onTap: () => setState(() {
//                  dataList.removeAt(index);
//                }),
//              ),
            ],
          );
        });

    _searchAction(String text) {
      searchStr = text;
      getListNetCall();
      print("........................." + text);
    }

    Widget reflust = new RefreshIndicator(
        displacement: 10.0, child: myListView, onRefresh: getListNetCall);

    Widget bodyContiner = new Container(
      color: Colors.white,
      // height: 140, //高度不填会自适应
      padding: const EdgeInsets.only(top: 0.0, bottom: 120, left: 0, right: 0),
      child: Column(
        //这行决定了左对齐
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Offstage(
            offstage: true,
            child: Container(
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
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: new EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: new SearchView(
                hitText: "勘察点名称",
                searchAction: (editText) => _searchAction(editText)),
          ),

          //分割线
          Container(
              width: prefix0.screen_width,
              height: 1.0,
              color: FENGE_LINE_COLOR),
          Expanded(
            child: reflust,
          ),
          // bottomButton,
        ],
      ),
    );

    Widget of = new Offstage(
      offstage: false,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () {
            _addPoint();

            // _creatSite(
            //     new SitePageModel(
            //         "", "", "0", "area", "", "", "", "", 0.0, "", ""),
            //     true);
          },
          child: Container(
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0), //3像素圆角
                border: Border.all(color: Colors.grey),
                boxShadow: [
                  //阴影
                  BoxShadow(color: Colors.white, blurRadius: 4.0)
                ]),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                "+ 新建勘察点",
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
    );

    return new Scaffold(
      appBar: navBar,
      body: bodyContiner,
      bottomSheet: of,
    );
  }
}
