import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sensoro_survey/net/NetService/result_data.dart';
import 'package:sensoro_survey/net/api/app_api.dart';
import 'package:sensoro_survey/net/api/net_config.dart';
import 'package:sensoro_survey/views/survey/commonWidegt/SearchView.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/sitePages/Model/SitePageModel.dart';

import '../const.dart';
import 'creat_building_page.dart';
import 'creat_site_page.dart';
import 'edit_building_page.dart';

class BuildingListPage extends StatefulWidget {
  BuildingListPage({Key key, this.sitePageModel}) : super(key: key);

  SitePageModel sitePageModel;

  @override
  _BuildingListPageState createState() => _BuildingListPageState(sitePageModel);
}

class _BuildingListPageState extends State<BuildingListPage> {
  _BuildingListPageState(SitePageModel sitePageModel) {}

  ///新建建筑
  void _creatbuilding() async {
    final result = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute(builder: (BuildContext context) {
      return new CreatbuildingPage(
          new SitePageModel("", "", "", "", "", "", "", "", 0.0, "", ""));
    }));

    if (result != null) {
      SitePageModel sitePageModel = result as SitePageModel;
      widget.sitePageModel.buildingList.add(sitePageModel);
      setState(() {});
    }
  }

  ///建筑详情
  void _buildingdetail(int index) async {
    final result = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute(builder: (BuildContext context) {
      return new EditbuildingPage(widget.sitePageModel.buildingList[index]);
    }));

    if (result != null) {
      SitePageModel sitePageModel = result as SitePageModel;
//      widget.sitePageModel.buildingList.add(sitePageModel);
      setState(() {});
    }
  }

  Future getBuildingListCall() async {
    String urlStr =
        NetConfig.siteListUrl + widget.sitePageModel.id + "&keyword=";
    Map<String, dynamic> headers = {};
    Map<String, dynamic> params = {};

    ResultData resultData = await AppApi.getInstance()
        .getListNetCall(context, true, urlStr, headers, params);
    if (resultData.isSuccess()) {
      // _stopLoading();
      widget.sitePageModel.buildingList.clear();
      int code = resultData.response["code"].toInt();
      if (code == 200) {
        if (resultData.response["data"]["records"] is List) {
          List resultList = resultData.response["data"]["records"];
          if (resultList.length > 0) {
            for (int i = 0; i < resultList.length; i++) {
              Map json = resultList[i] as Map;
              SitePageModel model = SitePageModel.fromJson(json);
              if (model != null) {
                widget.sitePageModel.buildingList.add(model);
              }
            }
          }
        }
      }
      setState(() {});
    }
  }

  ///区域
  void _openEreaPage() async {
    final result = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute(builder: (BuildContext context) {
      return new CreatSitePage(
          fireModel: widget.sitePageModel, isCreatSite: false);
    }));

    if (result != null) {
      SitePageModel sitePageModel = result as SitePageModel;
      sitePageModel.listplace = widget.sitePageModel.listplace;
      widget.sitePageModel = sitePageModel;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBuildingListCall();
  }

  @override
  Widget build(BuildContext context) {
    Widget myListView = new ListView.builder(
        physics: new AlwaysScrollableScrollPhysics()
            .applyTo(new BouncingScrollPhysics()), // 这个是用来控制能否在不屏的状态下滚动的属性
        itemCount: widget.sitePageModel.buildingList.length == 0
            ? 1
            : widget.sitePageModel.buildingList.length,
        // separatorBuilder: (BuildContext context, int index) =>
        // Divider(height: 1.0, color: Colors.grey, indent: 20), // 添加分割线
        itemBuilder: (BuildContext context, int index) {
          // print("rebuild index =$index");
          if (widget.sitePageModel.buildingList.length == 0) {
            return new Container(
              padding: const EdgeInsets.only(
                  top: 80.0, bottom: 0, left: 0, right: 0),
              child: new Column(children: <Widget>[
                new Image(
                  image: new AssetImage("assets/images/nocontent.png"),
                  width: 120,
                  height: 120,
                  // fit: BoxFit.fitWidth,
                ),
                Text("暂无建筑",
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _buildingdetail(index);
                      },
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            textDirection: TextDirection.ltr,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          widget.sitePageModel
                                              .buildingList[index].name,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: prefix0.BLACK_TEXT_COLOR,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 17)),
                                      new SizedBox(
                                        height: 1,
                                      ),
                                    ],
                                  ),
                                ),
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
              IconSlideAction(
                caption: '删除',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => setState(() {
                  widget.sitePageModel.buildingList.removeAt(index);
                }),
              ),
            ],
          );
        });

    Widget reflust = new RefreshIndicator(
        displacement: 10.0, child: myListView, onRefresh: getBuildingListCall);
    Column body = Column(
      children: <Widget>[
        Padding(
          padding: new EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: new SearchView(
              hitText: "建筑名称",
              searchAction: (editText) => _searchAction(editText)),
        ),
        Expanded(
          child: reflust,
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: GestureDetector(
            onTap: _creatbuilding,
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
                  "+ 新建建筑",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.sitePageModel.name),
          centerTitle: true,
          leading: IconButton(
            icon: Image.asset(
              "assets/images/back.png",
              // height: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            Container(
              padding: new EdgeInsets.fromLTRB(0, 0, 20, 0),
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  _openEreaPage();
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
        ),
        body: body);
  }
}

_searchAction(editText) {
  print("==建筑列表"
          "=" +
      editText);
}
