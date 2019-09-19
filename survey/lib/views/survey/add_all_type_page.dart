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
import 'package:sensoro_survey/widgets/text_input.dart';
import 'package:sensoro_survey/model/component_configure_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/services.dart';
import 'package:sensoro_survey/widgets/component.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/const.dart';
import 'package:sensoro_survey/views/survey/item_widget.dart';
import 'package:sensoro_survey/net/api/app_api.dart';
import 'package:sensoro_survey/net/api/net_config.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensoro_survey/generated/customCalendar/default_style_page.dart';
import 'package:sensoro_survey/generated/customCalendar/lib/flutter_custom_calendar.dart';
import 'package:sensoro_survey/generated/customCalendar/lib/model/date_model.dart';
import 'package:sensoro_survey/model/component_configure_model.dart';
import 'package:sensoro_survey/model/mutilcheck_model.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/widgets/mutil_check.dart';
import 'package:sensoro_survey/widgets/text_input.dart';
import '../../pic_swiper.dart';

class AddAllPage1 extends StatefulWidget {
  List<dynamic> input;
  AddAllPage1({Key key, @required this.input}) : super(key: key);

  @override
  _AddAllPageState1 createState() => _AddAllPageState1(input: this.input);
}

class _AddAllPageState1 extends State<AddAllPage1> {
  List<dynamic> input;
  _AddAllPageState1({this.input});
  bool isAllCheck = false;

  bool isCheck = false;
  List<dynamic> dataList = [];
  Timer _changeTimer;
  bool isErrorShowing = false;
  String errorInfo = "";
  String name1 = "";

  TextEditingController step1remarkController = TextEditingController();
  BasicMessageChannel<String> _basicMessageChannel =
      BasicMessageChannel("BasicMessageChannelPlugin", StringCodec());
  BasicMessageChannel<String> _takePicBasicMessageChannel =
      BasicMessageChannel("BasicMessageChannelPluginPickImage", StringCodec());
  var picImagesArray = [
    {"title": "环境照片", "picPath": ""},
    {"title": "环境照片", "picPath": ""},
    {"title": "环境照片", "picPath": ""}
  ];
  int editIndex = -1;
  int picImageIndex = 0;
  Map extraInfo = {};

  //组件即将销毁时调用
  @override
  void dispose() {
//    dataList.clear();
    _changeTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    if (ComponentConfig.confiureList.length > 0) {
      for (int i = 0; i < ComponentConfig.confiureList.length; i++) {
        Map json = ComponentConfig.confiureList[i] as Map;
        componentModel model = componentModel.fromJson(json);
        if (model != null) {
          dataList.add(model);
        }
      }
    }

    // if (this.model.comp_code == "map_location") {
    //   _basicMessageChannel.setMessageHandler((message) => Future<String>(() {
    //         print(message);
    //         //message为native传递的数据
    //         if (message != null && message.isNotEmpty) {
    //           List list = message.split(",");
    //           if (list.length == 3) {
    //             if (this.model.comp_code == "map_location") {
    //               if (extraInfo == null) {
    //                 extraInfo = new Map();
    //               }
    //               extraInfo["editLongitudeLatitude"] = list[0] + "," + list[1];
    //               this.model.variable_value = list[2];

    //               setState(() {});
    //             }
    //           }
    //         }
    //         //给Android端的返回值
    //         return "========================收到Native消息：" + message;
    //       }));
    // }

    // if (this.model.comp_code == "photo") {
    //   _takePicBasicMessageChannel
    //       .setMessageHandler((message) => Future<String>(() {
    //             print(message);
    //             //message为native传递的数据
    //             _resentpics(message);
    //             //给Android端的返回值
    //             return "========================收到Native消息：" + message;
    //           }));
    // }

    super.initState();
  }

  void updateConfigureListNetCall() async {
    String urlStr = NetConfig.updateRiskValueUrl;
    Map<String, dynamic> headers = {"Content-Type": "application/json"};
    //从dataList取数据

    List<Map<String, dynamic>> list = [];
    for (int i = 0; i < dataList.length; i++) {
      componentModel model = dataList[i];
      Map<String, dynamic> json = {};
      json["risk_id"] = model.risk_id;
      json["variable_code"] = model.variable_code;
      json["variable_value"] = model.variable_value;
      // Map<String, dynamic> json = model.toJson();
      list.add(json);
    }
    // Map<String, dynamic> data1 = {
    //   "risk_id": "1",
    //   "variable_code": "name",
    //   "variable_value": "郑家杰"
    // };

    Map<String, dynamic> params = {"data": list};

    ResultData resultData = await AppApi.getInstance()
        .postListNetCall(context, true, urlStr, headers, params);
    if (resultData.isSuccess()) {
      // _stopLoading();
      int code = resultData.response["code"].toInt();
      if (code == 200) {
        var msg = "数据上传成功";
        errorInfo = msg;
        showErrorMsg(errorInfo);
        showToast(errorInfo);
        // Navigator.of(context).pop("");
      } else {
        var msg = resultData.response["msg"];
        errorInfo = msg;
        showErrorMsg(msg);
      }
    }
  }

  void showErrorMsg(String str) {
    setState(() {
      isErrorShowing = true;
    });

    _changeTimer = new Timer(Duration(milliseconds: 2000), () {
      isErrorShowing = false;
      errorInfo = "";
    });

    _changeTimer = new Timer(Duration(milliseconds: 2300), () {
      setState(() {});
    });
  }

  void updateConfigureList() {
    for (int i = 0; i < dataList.length; i++) {
      componentModel model = dataList[i];
      if (model.is_required == 'YES' && model.variable_value.length == 0) {
        setState(() {
          isAllCheck = false;
          errorInfo = "请填写${model.variable_name}";
          showErrorMsg(errorInfo);
        });
      }
    }

    updateConfigureListNetCall();
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

  //向native发送消息
  void _sendtakePicToNative() {
    Future<String> future = _takePicBasicMessageChannel.send("");
    future.then((message) {
      print("========================" + message);
    });

//    super.initState();
  }

  openGallery() async {
    _sendtakePicToNative();
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (null != image) {
      _resentpics(image.uri.path.toString());
    }
  }

  _resentpics(String urlString) {
    if (urlString.isNotEmpty) {
      Map item = picImagesArray[picImageIndex];

      String picPath = item["picPath"];
      String picTitle = item["title"];
      item["picPath"] = urlString;
      setState(() {});
    }
  }

  /*拍照*/
  takePhoto(int index) async {
    Map item = picImagesArray[index];

    String picPath = item["picPath"];
    if (picPath.length > 0) {
      List<PicSwiperItem> list = new List();
      PicSwiperItem picSwiperItem = PicSwiperItem("");
      list.clear();
      picSwiperItem.picUrl = picPath;

      list.add(picSwiperItem);
      if (picSwiperItem.picUrl.isNotEmpty) {
        final result = await Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new PicSwiper(index: 0, pics: list)),
        );
      }
    } else {
      picImageIndex = index;
      openGallery();
    }
  }

  bool isHaveSelectPic(int index) {
    Map item = picImagesArray[index];

    String picPath = item["picPath"];
    String picTitle = item["title"];
    if (picPath.length > 0) {
      return true;
    } else {
      return false;
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

    Widget indexContainer = Container(
      height: 0,
      width: 0,
    );

    gotoTextInput(componentModel model) async {
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
          name1 = name;
          model.variable_value = name;
        });
      }
    }

    List<PopupMenuItem<String>> popItemList(componentModel model) {
      List<PopupMenuItem<String>> list = [];
      List<String> optionList = model.options.split(";");
      for (int i = 0; i < optionList.length; i++) {
        list.add(new PopupMenuItem<String>(
            child: new Text(optionList[i]), value: i.toString()));
      }

      return list;
    }

    itemDraw(componentModel model) {
      List<String> optionList = model.options.split(";");

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
        padding: new EdgeInsets.fromLTRB(20, 0, 20, 10),
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: picImagesArray.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  takePhoto(index);
                },
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
                            offstage: isHaveSelectPic(index) ? false : true,
                            child: new IconButton(
                              icon: new Image.asset(
                                  "assets/images/picture_del.png"),
                              tooltip: 'Increase volume by 10%',
                              onPressed: () {
                                setState(() {
                                  Map item = picImagesArray[index];
                                  item["picPath"] = "";
                                });
                              },
                            )),
                      ],
                    )
                  ],
                ));
          },
        ),
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
            model.variable_value = "${dateModel.year}." +
                "${dateModel.month}." +
                "${dateModel.day}";
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
                  model.variable_name,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
                Expanded(
                  child: Text(
                    model.variable_value.length > 0
                        ? model.variable_value
                        : model.is_required == "YES" ? "必填" : "",
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

      List<PopupMenuItem<String>> popItemList() {
        List<PopupMenuItem<String>> list = [];

        for (int i = 0; i < optionList.length; i++) {
          list.add(new PopupMenuItem<String>(
              child: new Text(optionList[i]), value: i.toString()));
        }

        return list;
      }

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
                        : model.is_required == "YES" ? "必填" : "",
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

            itemBuilder: (context) =>
                <PopupMenuItem<String>>[]..addAll(popItemList()),

            onSelected: (String s) {
              setState(() {
                model.variable_value = optionList[int.parse(s)];
                // choosedModel = cars[int.parse(action)];
              });
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
                          model.variable_name,
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
                    hintText: model.variable_value.length > 0
                        ? model.variable_value
                        : model.is_required == "YES" ? "必填" : "",
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
            model.variable_value = name;
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
            // child: Expanded(
            child: new Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  model.variable_name,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
                Expanded(
                  child: Text(
                    // model.variable_value.length > 0
                    //     ? model.variable_value
                    //     : model.is_required == "YES" ? "必填" : "",

                    model.variable_value.length > 0 ? model.variable_value : "",
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
            // ),
          ));
      MutilCheck ratioContainer = MutilCheck(
        title: model.variable_name,
        dataList: List<MutilCheckModel>.generate(optionList.length,
            (i) => new MutilCheckModel(optionList[i], false)),
        isSingle: true,
        model: model,
      );
      MutilCheck mutilCheck = MutilCheck(
        title: model.variable_name,
        dataList: List<MutilCheckModel>.generate(optionList.length,
            (i) => new MutilCheckModel(optionList[i], false)),
        isSingle: false,
        model: model,
      );

      if (model.comp_code == "select_list") {
        return popView;
      } else if (model.comp_code == "text_view") {
        return textView;
      } else if (model.comp_code == "text_field") {
        return textInput;
      } else if (model.comp_code == "check_option" &&
          model.comp_type == "radio") {
        //单选框
        return ratioContainer;
      } else if (model.comp_code == "check_option" &&
          model.comp_type == "checkbox") {
        //复选框
        return mutilCheck;
      } else if (model.comp_code == "photo") {
        //添加图片
        return imageContainer;
      } else if (model.comp_code == "map_location") {
        //高德地图或百度地图
        return mapContainer;
      } else if (model.comp_code == "date_picker") {
        //日期选择
        return datePickerContainer;
      } else {
        return emptyContainer;
      }
    }

    Widget bottomButton = Container(
      color: prefix0.LIGHT_LINE_COLOR,
      height: 60,
      width: prefix0.screen_width,
      child: new MaterialButton(
        color: prefix0.GREEN_COLOR,
        textColor: Colors.white,
        child: new Text("完成",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 20)),
        onPressed: () {
          // Fluttertoast.showToast(msg: "成功获取本周天气, 显示周一天气");
          this.updateConfigureList();
        },
      ),
    );

    Widget navBar = AppBar(
      elevation: 1.0,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        "勘察点信息",
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

    Widget errorC = Container(
        // color: Colors.white,
        child: new Column(
      children: <Widget>[
        Padding(
          child: new Text(
            this.errorInfo,
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
          padding: new EdgeInsets.fromLTRB(20, 20, 20, 20),
        ),

        //分割线
        Container(
            width: prefix0.screen_width - 40,
            height: 1.0,
            color: FENGE_LINE_COLOR),

        // container,
      ],
    ));

    Widget myListView = new ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        // physics: new AlwaysScrollableScrollPhysics()
        //     .applyTo(new BouncingScrollPhysics()), // 这个是用来控制能否在不满屏的状态下滚动的属性
        itemCount: dataList.length == 0 ? 1 : dataList.length + 1,
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
                Text("没有已创建的",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: prefix0.LIGHT_TEXT_COLOR,
                        fontWeight: FontWeight.normal,
                        fontSize: 17)),
              ]),
            );
          }

          if (index == 0) {
            return isErrorShowing == true ? errorC : emptyContainer;
          }
          componentModel model = dataList[index - 1];
          // this.model = model1;

          return new Container(
            // height: 61,
            padding:
                const EdgeInsets.only(top: 0.0, bottom: 0, left: 20, right: 20),
            child: new Column(children: <Widget>[
              itemDraw(model),
              //由于绘制顺序的问题，单独类绘制的方式有BUG，放弃,绘制都写在同一个build里
              // itemClass(model: model),

              //   //分割线
              Container(
                  width: prefix0.screen_width - 40,
                  height: 1.0,
                  color: FENGE_LINE_COLOR),
            ]),
          );
        });

    Scaffold scaffold = new Scaffold(
        appBar: navBar,
        body: myListView,
        bottomNavigationBar: BottomAppBar(
          child: bottomButton,
        )
        // bottomSheet: bottomButton,
        );

    return NotificationListener(
      onNotification: (ScrollNotification notification) {},
      child: scaffold,
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
