import 'package:flutter/material.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;

import 'const.dart';

class SiteManagementPage extends StatefulWidget {
  SiteManagementPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _SiteManagementPageState createState() => _SiteManagementPageState();
}

class _SiteManagementPageState extends State<SiteManagementPage> {


  @override
  Widget build(BuildContext context) {


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
                      onTap: () {

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
                                      Text(dataList[index],
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: prefix0.BLACK_TEXT_COLOR,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 17)),
                                      // ),
                                      new SizedBox(
                                        height: 2,
                                      ),
                                      Text("",
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
                                    color: Colors.lightBlue,
                                    textColor: Colors.white,
                                    child: new Text('编辑'),
                                    onPressed: () {
//                                      _editProject(model);
                                    },
                                  ),
                                  new RaisedButton(
                                    color: Colors.lightBlue,
                                    textColor:  Colors.white,
                                    child: new Text('管理'),
                                    onPressed: () {
//                                      _outputDocument(index);
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


    return new Scaffold(
      appBar: new AppBar(
        title: new Text('场所管理'),
      ),
      body: myListView
    );
  }
}


const dataList = [
  "场所2",
  "场所3",
  "场所4",
  "场所5",
  "场所6",
  "场所7",
  "场所8"
];