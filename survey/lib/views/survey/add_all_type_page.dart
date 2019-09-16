/// @Author: zyg
/// @Date: 2019-09-12
/// @Last Modified by: zyg
/// @Last Modified time: 2019-09-12
/// 适配各种类型的增加新勘察数据的主页面
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';
import 'package:sensoro_survey/component/text_input.dart';
import 'package:sensoro_survey/model/component_configure_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/services.dart';
import 'package:sensoro_survey/component/component.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/const.dart';

class AddAllPage1 extends StatefulWidget {
  componentModel input;
  AddAllPage1({Key key, @required this.input}) : super(key: key);

  @override
  _AddAllPageState1 createState() => _AddAllPageState1(input: this.input);
}

class _AddAllPageState1 extends State<AddAllPage1> {
  componentModel input;
  _AddAllPageState1({this.input});

  bool isCheck = false;
  List<componentModel> dataList = [];

  //组件即将销毁时调用
  @override
  void dispose() {
//    dataList.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    componentModel model = componentModel("", "", "", "", {});

    model.name = "输入文本";
    model.type = "textInput";
    dataList.add(model);

    model = componentModel("", "", "", "", {});
    model.name = "大输入框";
    model.type = "textView";
    dataList.add(model);

    model = componentModel("", "", "", "", {});
    model.name = "弹出选择菜单";
    model.type = "popList";
    dataList.add(model);

    model = componentModel("", "", "", "", {});
    model.name = "添加图片";
    model.type = "image";
    dataList.add(model);

    model = componentModel("", "", "", "", {});
    model.name = "跳转地图";
    model.type = "map";
    dataList.add(model);

    model = componentModel("", "", "", "", {});
    model.name = "单选圆按钮";
    model.type = "ratio";
    dataList.add(model);

    model = componentModel("", "", "", "", {});
    model.name = "复选框";
    model.type = "checkBox";
    dataList.add(model);

    model = componentModel("", "", "", "", {});
    model.name = "日期选择器";
    model.type = "datePicker";
    dataList.add(model);

    // initDetailList();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        //or set color with: Color(0xFF0000FF)
        // statusBarColor: Colors.blue,
        ));
  }

  @override
  Widget build(BuildContext context) {
    Widget emptyContainer = Container(
      height: 0,
      width: 0,
    );

    Widget indexContainer = Container(
      height: 0,
      width: 0,
    );

    Widget bottomButton = Container(
      color: prefix0.LIGHT_LINE_COLOR,
      height: 60,
      width: prefix0.screen_width,
      child: new MaterialButton(
        color: isCheck == true ? prefix0.GREEN_COLOR : Colors.grey,
        textColor: Colors.white,
        child: new Text("完成",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 20)),
        onPressed: () {
          // getBookName;
          // if (this.name.length > 0) {
          // saveInfoInLocal();
          // Navigator.of(context).pop("refreshList");
          // }
        },
      ),
    );

    Widget navBar = AppBar(
      elevation: 1.0,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        "项目信息",
        style: TextStyle(color: Colors.black),
      ),
      leading: IconButton(
        icon: Image.asset(
          "assets/images/back.png",
          // height: 20,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );

    Widget step1 = Container(
        color: prefix0.LIGHT_LINE_COLOR,
        child: new Column(
          children: <Widget>[
            new Row(children: <Widget>[
              Padding(
                child: new Text(
                  "电刑",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                padding: new EdgeInsets.fromLTRB(20, 20, 20, 20),
              )
            ]),
            // container,
          ],
        ));

    Widget myListView = new ListView.builder(
        physics: new AlwaysScrollableScrollPhysics()
            .applyTo(new BouncingScrollPhysics()), // 这个是用来控制能否在不满屏的状态下滚动的属性
        itemCount: dataList.length == 0 ? 1 : dataList.length,
        // separatorBuilder: (BuildContext context, int index) =>
        // Divider(height: 1.0, color: Colors.grey, indent: 20), // 添加分割线
        itemBuilder: (BuildContext context, int index) {
          componentModel model = dataList[index];

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
                Text("没有已创建的",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: prefix0.LIGHT_TEXT_COLOR,
                        fontWeight: FontWeight.normal,
                        fontSize: 17)),
              ]),
            );
          }

          var gestureDetector = GestureDetector(
            //zyg onTap带参数事件
            onTap: () {
              // addAttribute(index);
            },

            child: itemClass(model: model),
          );
          return new Container(
            padding:
                const EdgeInsets.only(top: 0.0, bottom: 0, left: 20, right: 20),
            child: new Column(children: <Widget>[
              gestureDetector,

              //分割线
              Container(
                  width: prefix0.screen_width - 40,
                  height: 1.0,
                  color: FENGE_LINE_COLOR),
            ]),
          );
        });

    return Scaffold(
        appBar: navBar,
        body: myListView,
        bottomNavigationBar: BottomAppBar(
          child: bottomButton,
        )
        // bottomSheet: bottomButton,
        );
    // TODO: implement build
    return null;
  }
}

// class AddAllPage1 extends StatefulWidget {
//   componentModel input;
//   AddAllPage1({Key key, @required this.input}) : super(key: key);

//   @override
//   _AddAllPageState1 createState() => _AddAllPageState1(input: this.input);
// }

// class _AddAllPageState1 extends State<AddAllPage1> {
//   componentModel input;
//   _AddAllPageState1({this.input});

//适配多种控件的配置
class itemClass extends StatefulWidget {
  componentModel model;
  itemClass({Key key, @required this.model}) : super(key: key);

  @override
  itemClassState createState() => itemClassState(this.model);
}

class itemClassState extends State<itemClass> {
  componentModel model;
  itemClassState(this.model);

  TextEditingController step1remarkController = TextEditingController();
  BasicMessageChannel<String> _basicMessageChannel =
  BasicMessageChannel("BasicMessageChannelPlugin", StringCodec());
  @override
  void initState() {

    _basicMessageChannel.setMessageHandler((message) => Future<String>(() {
      print(message);
      //message为native传递的数据
      if(message!=null&&message.isNotEmpty){
        List list = message.split(",");
        if (list.length ==3){
          setState(() {
            model.extraInfo["editLongitudeLatitude"] = list[0] + "," + list[1];
            model.extraInfo["editPosition"] = list[2];
          });
        }

      }
      //给Android端的返回值
      return "========================收到Native消息：" + message;
    }));

    super.initState();
  }


  void _sendToNative() {

    var location = "0," + "," +","+ "";
    if(model.extraInfo["editLongitudeLatitude"]!=null){
      location = "0," + model.extraInfo["editLongitudeLatitude"] +","+ "";
    }


    Future<String> future = _basicMessageChannel.send(location);
    future.then((message) {
      print("========================" + message);
    });


  }

  editLoction() async {
    _sendToNative();
  }

  @override
  Widget build(BuildContext context) {
    //弹出的选择LIST
    Widget emptyContainer = Container(
      height: 0,
      width: 0,
    );

    Widget mapContainer =  GestureDetector(
      onTap: editLoction, //写入方法名称就可以了，但是是无参的
      child: Container(
        alignment: Alignment.center,
        height: 60,
        child: new Row(
          children: <Widget>[
            Text("定位地址",
              style: new TextStyle(
                  fontSize: prefix0.fontsSize
              ),
            ),
            Expanded(
              child: Text(
                this.model.extraInfo["editPosition"] !=null
                    ? this.model.extraInfo["editPosition"]
                    : "",
                textAlign: TextAlign.right,
                style: new TextStyle(
                    fontSize: prefix0.fontsSize
                ),
              ),
            ),
            Image.asset(
              "assets/images/right_arrar.png",
              width: 20,
            )
          ],
        ),
      ),
    );

    Widget imageContainer = Container(
      height: 0,
      width: 0,
    );

    Widget ratioContainer = Container(
      height: 0,
      width: 0,
    );

    Widget checkBoxContainer = Container(
      height: 0,
      width: 0,
    );

    Widget datePickerContainer = Container(
      height: 0,
      width: 0,
    );

    Container popView = new Container(
      alignment: Alignment.center,
      height: 60,
      child: Center(
        child: PopupMenuButton(
//              icon: Icon(Icons.home),
          child: new Row(
            children: <Widget>[
              Text(
                model.name,
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.black, fontSize: 17),
              ),
              Expanded(
                child: Text(
                  model.value.length > 0 ? model.value : "点击选择",
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
              Image.asset(
                "assets/images/right_arrar.png",
                width: 20,
              )
            ],
          ),
          tooltip: "长按提示",
          initialValue: "hot",
          offset: Offset(0.2, 0),
          padding: EdgeInsets.only(top: 0.0, bottom: 0, left: 100, right: 0),
          itemBuilder: (BuildContext context) {
            return <PopupMenuItem<String>>[
              PopupMenuItem<String>(
                child: Text("热度"),
                value: "hot",
              ),
              PopupMenuItem<String>(
                child: Text("最新"),
                value: "new",
              ),
              PopupMenuItem<String>(
                child: Text("对对对"),
                value: "new",
              ),
            ];
          },
          onSelected: (String action) {
            switch (action) {
              case "hot":
                print("热度");
                break;
              case "new":
                print("最新");
                break;
            }
          },
          onCanceled: () {
            print("onCanceled");
          },
        ),
      ),
    );

    Container textView = new Container(
        alignment: Alignment.center,
        // height: 60,
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
//            onTap: editAddress,//写入方法名称就可以了，但是是无参的
                child: Container(
                  alignment: Alignment.center,
                  height: 60,
                  child: new Row(
                    children: <Widget>[
                      Text(
                        "备注",
                        style: new TextStyle(fontSize: prefix0.fontsSize),
                      ),
                    ],
                  ),
                ),
              ),
              TextField(
                enabled: true,
                controller: step1remarkController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      borderSide: BorderSide(color: Colors.transparent)),
//                  labelText: '备注',
                  hintText: '无',
                ),
                maxLines: 5,
                autofocus: false,
                onChanged: (val) {
                  model.value = val;
                  // setState(() {});
                },
              ),
            ]));

    _gotoTextInput(componentModel model) async {
      // componentModel model = componentModel(
      //     "项目名称", "projectName", this.name, "text", {"placeHoder": "默认输入这些"});
      final result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new TextInputPage(
                  model: model,
                )),
      );

      if (result != null) {
        String name = result as String;
        setState(() {
          this.model.value = name;
        });
      }
    }

    var textInput = GestureDetector(
        //zyg onTap带参数事件
        onTap: () {
          _gotoTextInput(model);
        },
        child: new Container(
          alignment: Alignment.center,
          height: 60,
          child: new Row(
            children: <Widget>[
              Text(
                this.model.name,
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.black, fontSize: 17),
              ),
              Expanded(
                child: Text(
                  model.value.length > 0 ? model.value : "必填",
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
              Image.asset(
                "assets/images/right_arrar.png",
                width: 20,
              )
            ],
          ),
        ));

    if (this.model.type == "popList") {
      return popView;
    } else if (this.model.type == "textView") {
      return textView;
    } else if (this.model.type == "textInput") {
      return textInput;
    } else if (this.model.type == "ratio") {
      //单选框
      return ratioContainer;
    } else if (this.model.type == "checkbox") {
      //复选框
      return checkBoxContainer;
    } else if (this.model.type == "image") {

      //添加图片
      return imageContainer;
    } else if (this.model.type == "map") {


      //高德地图或百度地图
      return mapContainer;
    } else if (this.model.type == "dataPicker") {
      //日期选择
      return datePickerContainer;
    } else {
      return emptyContainer;
    }
    return Container(
      child: Center(
        child: Text(""),
      ),
    );
  }
}
