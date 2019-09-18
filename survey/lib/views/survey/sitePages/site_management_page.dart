import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sensoro_survey/generated/customCalendar/lib/controller.dart';
import 'package:sensoro_survey/views/survey/common/data_transfer_manager.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/management_page.dart';
import 'package:sensoro_survey/views/survey/sitePages/Model/SitePageModel.dart';
import 'package:sensoro_survey/views/survey/sitePages/creat_site_page.dart';

import '../const.dart';

class SiteManagementPage extends StatefulWidget {
  SiteManagementPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SiteManagementPageState createState() => _SiteManagementPageState();
}

class _SiteManagementPageState extends State<SiteManagementPage> {
  bool calendaring = false;
  String beginTimeStr = "";
  String endTimeStr = "";
  String searchStr = "";
  String dateFilterStr = "";
  CalendarController controller;
  TextEditingController searchController = TextEditingController();
  List<SitePageModel> dataList = [];
  void _startManagePage(SitePageModel data) async {
    DataTransferManager.shared.creatModel();
    final result = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute(builder: (BuildContext context) {
      return new ManagementPage(sitePageModel: data);
    }));

    if (result != null) {
      String name = result as String;
      if (name == "refreshList") {}
      // this.name = name;
      setState(() {});
    }
  }

  void _creatSite() async {
    DataTransferManager.shared.creatModel();
    final result = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute(builder: (BuildContext context) {
      return new CreatSitePage();
    }));

    if (result != null) {
      SitePageModel name = result as SitePageModel;

      // this.name = name;
      dataList.add(name);
      setState(() {});
    }
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
            onPressed: () {
//              _showCalendar();
//              eventChannel
//                  .receiveBroadcastStream("showCalendar")
//                  .listen(_onEvent, onError: _onError);
              // do nothing
            }),
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
                Text("暂无场所",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: prefix0.LIGHT_TEXT_COLOR,
                        fontWeight: FontWeight.normal,
                        fontSize: 17)),
              ]),
            );
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
//                String historyKey = 'projectList';
//                Map<String, dynamic> map = model.toJson();
//                String jsonStr = json.encode(map);
//
//                SaveDataManger.deleteHistory(
//                  jsonStr,
//                  historyKey,
//                  model.projectId,
//                );
//                setState(() {
//                  dataList.removeAt(index);
//                });
              }
            },
            direction: DismissDirection.endToStart,
            // direction: DismissDirection.up,

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
                      onTap: () {},
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
                                      Text(dataList[index].siteName,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: prefix0.BLACK_TEXT_COLOR,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 17)),
                                      // ),
                                      new SizedBox(
                                        height: 2,
                                      ),
//                                      Text("",
//                                          textAlign: TextAlign.start,
//                                          style: TextStyle(
//                                              color: prefix0.BLACK_TEXT_COLOR,
//                                              fontWeight: FontWeight.normal,
//                                              fontSize: 17)),
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
                                    color: Colors.lightBlue,
                                    textColor: Colors.white,
                                    child: new Text('编辑'),
                                    onPressed: () {
//                                      _editProject(model);
                                    },
                                  ),
                                  new RaisedButton(
                                    color: Colors.lightBlue,
                                    textColor: Colors.white,
                                    child: new Text('管理'),
                                    onPressed: () {
                                      _startManagePage(dataList[index]);
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

    Widget bodyContiner = new Container(
      color: Colors.white,
      // height: 140, //高度不填会自适应
      padding: const EdgeInsets.only(top: 0.0, bottom: 0, left: 0, right: 0),
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

          new Offstage(
            offstage: false,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: _creatSite,
                child: Container(
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
                      "+ 场所",
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
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

    return new Scaffold(appBar: navBar, body: bodyContiner);
  }
}

//const dataList = ["场所1", "场所2", "场所3", "场所4", "场所5", "场所6", "场所7", "场所8"];
