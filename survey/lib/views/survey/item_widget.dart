import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensoro_survey/generated/customCalendar/default_style_page.dart';
import 'package:sensoro_survey/generated/customCalendar/lib/flutter_custom_calendar.dart';
import 'package:sensoro_survey/generated/customCalendar/lib/model/date_model.dart';
import 'package:sensoro_survey/model/component_configure_model.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/const.dart';
import 'package:sensoro_survey/component/text_input.dart';

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

  var picImagesArray = [
    {"title": "环境照片", "picPath": ""},
    {"title": "环境照片", "picPath": ""},
    {"title": "环境照片", "picPath": ""}
  ];
  int editIndex = -1;
  int picImageIndex = 0;
  Map extraInfo = {};

  @override
  void initState() {
    this.model = model;
    if (model.variable_value != null && model.variable_value.length > 0) {
      extraInfo = json.decode(model.variable_value);
    }

    if (model.type == "map") {
      return;
      _basicMessageChannel.setMessageHandler((message) => Future<String>(() {
            print(message);
            //message为native传递的数据
            if (message != null && message.isNotEmpty) {
              List list = message.split(",");
              if (list.length == 3) {
                if (model.type == "map") {
                  if (extraInfo == null) {
                    extraInfo = new Map();
                  }
                  extraInfo["editLongitudeLatitude"] = list[0] + "," + list[1];
                  model.variable_value = list[2];

                  setState(() {});
                }
              }
            }
            //给Android端的返回值
            return "========================收到Native消息：" + message;
          }));
    }

    super.initState();
  }

  Widget getItembyIndex(int index) {
    Map item = picImagesArray[index];

    String picPath = item["picPath"];
    String picTitle = item["title"];
    if (picPath.length > 0) {
      return Image.file(File(picPath));
    } else {
      return Text(
        picTitle,
        textAlign: TextAlign.center,
      );
    }
  }

  void _sendToNative() {
    var location = "0," + "," + "," + "";
    if (extraInfo["editLongitudeLatitude"] != null) {
      location = "0," + extraInfo["editLongitudeLatitude"] + "," + "";
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
    Widget emptyContainer = Container(
      height: 0,
      width: 0,
    );

    Widget mapContainer = GestureDetector(
      onTap: editLoction, //写入方法名称就可以了，但是是无参的
      child: Container(
        alignment: Alignment.center,
        height: 60,
        child: new Row(
          children: <Widget>[
            Text(
              model.variable_name,
              style: TextStyle(color: Colors.black, fontSize: 17),
            ),
            Expanded(
              child: Text(
                model.variable_value.length > 0 ? model.variable_value : "",
                textAlign: TextAlign.right,
                style: new TextStyle(fontSize: prefix0.fontsSize),
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
      color: Colors.white,
      padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: picImagesArray.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: null,
              //写入方法名称就可以了，但是是无参的
              onTapUp: (_) {
                setState(() {
                  editIndex = -1;
                });
              },
              onTapCancel: () {
                setState(() {
                  editIndex = -1;
                });
              },
              onTapDown: (_) {
                setState(() {
                  editIndex = index;
                });
              },
              child: Stack(
                alignment: const Alignment(0.9, -1.1),
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0, 10, 20, 0),
                    child: Container(
                      alignment: Alignment.center,
                      child: getItembyIndex(index),
                      decoration: new BoxDecoration(
                        border: new Border.all(
                            width: 1.0,
                            color: (editIndex == index
                                ? Colors.green
                                : prefix0.LINE_COLOR)),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(5.0)),
                      ),
                      width: 150,
                      height: 150,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      new Offstage(
                          offstage: false,
                          child: new IconButton(
                            icon: new Image.asset(
                                "assets/images/picture_del.png"),
                            tooltip: 'Increase volume by 10%',
                            onPressed: () {
//                              setState(() {
//                                fireCreatModel.editenvironmentpic1 = "";
//                              }
//                              );
                            },
                          )),
                    ],
                  )
                ],
              ));
        },
      ),
    );

    Widget ratioContainer = Container(
      height: 0,
      width: 0,
    );

    Widget checkBoxContainer = Container(
      height: 0,
      width: 0,
    );

    //调用日历
    _showCalendar() async {
      //调用flutter日历控件
      final result = await Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new DefaultStylePage()),
      );

      if (result != null) {
        if (result is DateModel) {
          DateModel dateModel = result;
          model.variable_value =
              "${dateModel.year}." + "${dateModel.month}." + "${dateModel.day}";
          setState(() {});
        }
      }
      return;
    }

    Widget datePickerContainer = GestureDetector(
        //zyg onTap带参数事件
        onTap: () {
          _showCalendar();
        },
        child: new Container(
          alignment: Alignment.center,
          height: 60,
          child: new Row(
            children: <Widget>[
              Text(
                this.model.variable_name,
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.black, fontSize: 17),
              ),
              Expanded(
                child: Text(
                  model.variable_value.length > 0
                      ? model.variable_value
                      : "点击选择",
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

//弹出的选择LIST
    Container popView = new Container(
      alignment: Alignment.center,
      height: 60,
      child: Center(
        child: PopupMenuButton(
//              icon: Icon(Icons.home),
          child: new Row(
            children: <Widget>[
              Text(
                model.variable_name,
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.black, fontSize: 17),
              ),
              Expanded(
                child: Text(
                  model.variable_value.length > 0
                      ? model.variable_value
                      : "点击选择",
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
                this.model.variable_value = "热度";
                setState(() {});
                break;
              case "new":
                print("最新");
                this.model.variable_value = "最新";
                setState(() {});
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
                  model.variable_value = val;
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
          this.model.variable_value = name;
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
                this.model.variable_name,
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.black, fontSize: 17),
              ),
              Expanded(
                child: Text(
                  model.variable_value.length > 0 ? model.variable_value : "必填",
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

    if (this.model.comp_code == "select_list") {
      return popView;
    } else if (this.model.comp_code == "text_view") {
      return textView;
    } else if (this.model.comp_code == "text_field") {
      return textInput;
    } else if (this.model.comp_code == "ratio") {
      //单选框
      return ratioContainer;
    } else if (this.model.comp_code == "check_option") {
      //复选框
      return checkBoxContainer;
    } else if (this.model.comp_code == "photo") {
      //添加图片
      return imageContainer;
    } else if (this.model.comp_code == "map_location") {
      //高德地图或百度地图
      return mapContainer;
    } else if (this.model.comp_code == "date_picker") {
      //日期选择
      return datePickerContainer;
    } else {
      return emptyContainer;
    }
  }
}
