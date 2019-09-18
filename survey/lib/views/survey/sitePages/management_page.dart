import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/sitePages/Model/SitePageModel.dart';

import '../const.dart';
import 'creat_building_page.dart';

class ManagementPage extends StatefulWidget {
  ManagementPage({Key key, this.sitePageModel}) : super(key: key);

  final SitePageModel sitePageModel;

  @override
  _ManagementPageState createState() => _ManagementPageState(sitePageModel);
}

class _ManagementPageState extends State<ManagementPage> {
  SitePageModel model = SitePageModel();
  List<SitePageModel> listmodel = [];

  _ManagementPageState(SitePageModel sitePageModel) {
    listmodel = sitePageModel.listplace;
  }

  void _creatbuilding() async {
    final result = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute(builder: (BuildContext context) {
      return new CreatbuildingPage();
    }));

    if (result != null) {
      SitePageModel sitePageModel = result as SitePageModel;
      listmodel.add(sitePageModel);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget myListView = new ListView.builder(
        physics: new AlwaysScrollableScrollPhysics()
            .applyTo(new BouncingScrollPhysics()), // 这个是用来控制能否在不屏的状态下滚动的属性
        itemCount: listmodel.length == 0 ? 1 : listmodel.length,
        // separatorBuilder: (BuildContext context, int index) =>
        // Divider(height: 1.0, color: Colors.grey, indent: 20), // 添加分割线
        itemBuilder: (BuildContext context, int index) {
          // print("rebuild index =$index");
          if (listmodel.length == 0) {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
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
                                      Text(listmodel[index].siteName,
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
          );
        });

    Column body = Column(
      children: <Widget>[
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
                  "+ 建筑",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: myListView,
        ),
      ],
    );

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.sitePageModel.siteName),
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
        ),
        body: body);
  }
}
