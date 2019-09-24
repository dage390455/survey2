import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sensoro_survey/views/survey/common/data_transfer_manager.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/sitePages/Model/SitePageModel.dart';
import 'package:sensoro_survey/views/survey/sitePages/buildinglist_page.dart';
import 'package:sensoro_survey/views/survey/sitePages/creat_site_page.dart';

import '../const.dart';
import 'Fire_Trouble_List_management_page.dart';
import 'Model/PointListModel.dart';
import 'Model/ProspectTaskListModel.dart';
import 'fire_resources_list_page.dart';

class PointRiskTypeSelectPage extends StatefulWidget {
  PointRiskTypeSelectPage({Key key, this.title,this.model}) : super(key: key);

  PointListModel model;
  final String title;

  @override
  _PointRiskTypeSelectPageState createState() =>
      _PointRiskTypeSelectPageState();
}

class _PointRiskTypeSelectPageState extends State<PointRiskTypeSelectPage> {
  List<String> dataList = ["风险评估", "消防隐患", "消防资源"];
  var tabImages;
  void _startManagePage(SitePageModel data) async {
    DataTransferManager.shared.creatModel();
    final result = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute(builder: (BuildContext context) {
      return new BuildingListPage(sitePageModel: data);
    }));

    if (result != null) {
      String name = result as String;
      if (name == "refreshList") {}
      // this.name = name;
      setState(() {});
    }
  }

  void _creatSite(SitePageModel model, bool isCreat) async {
    DataTransferManager.shared.creatModel();
    final result = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute(builder: (BuildContext context) {
      return new CreatSitePage(fireModel: model, isCreatSite: isCreat);
    }));

    if (result != null) {
//      SitePageModel name = result as SitePageModel;
//
//      for (int i = 0; i < dataList.length; i++) {
//        SitePageModel model = dataList[i];
//        if (model.sitePageModelId == name.sitePageModelId) {
//          dataList.removeAt(i);
//          break;
//        }
//      }
//
//      dataList.add(name);
//
//      // this.name = name;
//
//      setState(() {});

//      getListNetCall();
    }
  }

  void _startTroublePageList() async {
    final result = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute(builder: (BuildContext context) {
      return new FireTroubleListManagementPage(input: widget.model,);
    }));

    if (result != null) {
      // this.name = name;
      setState(() {});
    }
  }

  void _startFireResPageList() async {
    final result = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute(builder: (BuildContext context) {
      return new FireResourcesListPage();
    }));

    if (result != null) {
      // this.name = name;
      setState(() {});
    }
  }

  Image getTabImage(path) {
    return Image.asset(path, width: 20.0, height: 20.0);
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    if (tabImages == null) {
      tabImages = [
        getTabImage('assets/images/pingfen.png'),
        getTabImage('assets/images/yinhuan.png'),
        getTabImage('assets/images/ziyuan.png'),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
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
      title: Text("勘察任务类型"),

      leading: IconButton(
        icon: Image.asset(
          "assets/images/back.png",
          // height: 20,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[],
    );

    //打开创建页面
    _openCreatPage(int Index) {
      switch (Index) {
        case 1:
          _startTroublePageList();
        break;
        case 2:
          _startFireResPageList();
          break;
      }
    }

    Widget myListView = new ListView.builder(
        physics: new AlwaysScrollableScrollPhysics()
            .applyTo(new BouncingScrollPhysics()), // 这个是用来控制能否在不屏的状态下滚动的属性
        itemCount: 3,
        // separatorBuilder: (BuildContext context, int index) =>
        // Divider(height: 1.0, color: Colors.grey, indent: 20), // 添加分割线
        itemBuilder: (BuildContext context, int index) {
          // print("rebuild index =$index");

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
                        _openCreatPage(index);
//                        _startManagePage(dataList[index]);
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
                              tabImages[index],

                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 0.0, bottom: 0, left: 10, right: 0),
                                  child: Text(dataList[index],
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
                              )
//                              new SizedBox(
//                                width: 10,
//                              ),
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
    Widget bodyContiner = new Container(
      color: Colors.white,
      // height: 140, //高度不填会自适应
      padding: const EdgeInsets.only(top: 0.0, bottom: 120, left: 0, right: 0),
      child: Column(
        //这行决定了左对齐
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
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

    return new Scaffold(
//      appBar: navBar,
      body: bodyContiner,
    );
  }
}
