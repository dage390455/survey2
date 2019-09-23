import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;

import '../const.dart';
import 'add_new_fireresoure_page.dart';

class FireResourcesListPage extends StatefulWidget {
  FireResourcesListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FireResourcesListPageState createState() => _FireResourcesListPageState();
}

class _FireResourcesListPageState extends State<FireResourcesListPage> {
  List<String> dataList = ["消防栓", "灭火器", "消防栓"];

  void _startAddNewFireResourcePage() async {
    final result = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute(builder: (BuildContext context) {
      return new AddNewFireResourcePage();
    }));

    if (result != null) {
      String name = result as String;
      if (name == "refreshList") {}
      // this.name = name;
      setState(() {});
    }
  }

  _itemClick(int Index) {}

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget navBar = AppBar(
      elevation: 1.0,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text("消防资源列表"),
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
//                    Container(
//                      color: LIGHT_LINE_COLOR,
//                      height: 12,
//                      width: prefix0.screen_width,
//                    ),

                    GestureDetector(
                      onTap: () {
                        _itemClick(index);
//                        _startManagePage(dataList[index]);
                      },
                      child: Container(
                        height: 50,
                        color: Colors.white,
                        padding: const EdgeInsets.only(
                            top: 0.0, bottom: 0, left: 20, right: 20),
                        child: Row(
                            //Row 中mainAxisAlignment是水平的，Column中是垂直的
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //表示所有的子件都是从左到顺序排列，这是默认值
                            textDirection: TextDirection.ltr,
                            children: <Widget>[
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
                                width: 2,
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

    Widget bottomButton = Container(
      color: prefix0.LIGHT_LINE_COLOR,
      height: 50,
      width: prefix0.screen_width,
      child: new MaterialButton(
        color: Colors.grey,
        child: new Text("+ 添加资源",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 20)),
        onPressed: () {
          _startAddNewFireResourcePage();
        },
      ),
    );
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
        ],
      ),
    );

    return new Scaffold(
      appBar: navBar,
      body: bodyContiner,
      bottomSheet: bottomButton,
    );
  }
}
