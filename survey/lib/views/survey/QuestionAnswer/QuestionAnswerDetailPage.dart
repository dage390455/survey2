import 'dart:math' as prefix1;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sensoro_survey/generated/customCalendar/lib/controller.dart';
import 'package:sensoro_survey/net/api/app_api.dart';
import 'package:sensoro_survey/net/api/net_config.dart';
import 'package:sensoro_survey/views/survey/common/data_transfer_manager.dart';
import 'package:sensoro_survey/views/survey/commonWidegt/SearchView.dart';
import 'package:sensoro_survey/views/survey/commonWidegt/TakePhotoView.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/sitePages/Model/SitePageModel.dart';
import 'package:sensoro_survey/views/survey/sitePages/buildinglist_page.dart';
import 'package:sensoro_survey/views/survey/sitePages/creat_site_page.dart';
import 'package:sensoro_survey/views/survey/sitePages/dynamic_creat_page.dart';
import 'package:sensoro_survey/views/survey/sitePages/sqflite_page.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;

import '../const.dart';

class QuestionAnswerDetailPage extends StatefulWidget {
  QuestionAnswerDetailPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _QuestionAnswerDetailPageState createState() =>
      _QuestionAnswerDetailPageState();
}

class _QuestionAnswerDetailPageState extends State<QuestionAnswerDetailPage> {
  BasicMessageChannel _locationBasicMessageChannel = BasicMessageChannel(
      "BasicMessageChannelPluginGetCity", StandardMessageCodec());
  FocusNode blankNode = FocusNode();

  var _groupValue = 1;
  String imagePath = "";
  String inputNumber = "";
  bool isCheak = false;

  List<SitePageModel> dataList = [];
  TextEditingController locationController = TextEditingController();
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


  void _textSql() async {
    final result = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute(builder: (BuildContext context) {
      return new DynamicCreatePage();
    }));

    if (result != null) {
      String name = result as String;
      if (name == "refreshList") {}
      // this.name = name;
      setState(() {});
    }
  }

  Future getListNetCall() async {
    String urlStr = NetConfig.siteListUrl + "parent_id=0" + "&keyword=" + "";
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
              SitePageModel model = SitePageModel.fromJson(json);
              if (model != null) {
                dataList.add(model);
              }
            }
          }
        }
      }
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

    _cheakAllMustInput(){
      if(locationController.text.length>0&&imagePath.length>0){
        isCheak = true;
      }else{
        isCheak = false;
      }
      setState(() {});
    }
    _searchAction(String text) {
      imagePath = text;
      _cheakAllMustInput();
    }

    Widget headerView = new Container(
      padding: new EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Text("我是头.........",
        style: new TextStyle(
            fontSize: prefix0.fontsSize),
      ),

    );

    Widget footerView = new Container(
      padding: new EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        children: <Widget>[
        Padding(
          child:   Row(
            children: <Widget>[
              Text("请输入评分"),
            ],
          ),
          padding: new EdgeInsets.fromLTRB(0, 20, 0, 20),
        ),

          Container(
            height: 50,
            decoration: BoxDecoration(
              border: new Border.all(color: LIGHT_TEXT_COLOR, width: 0.5),
            ),
            child: TextField(
              onSubmitted: (String str) {},
              textAlign: TextAlign.start,
              keyboardType: TextInputType.number,


              inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9]"))],
              onChanged: (text){
                inputNumber = text;
                _cheakAllMustInput();
                setState(() {
                });
              },
              controller: locationController,
              maxLines: 1,
              style: new TextStyle(
                fontSize: 15.0,
                color: prefix0.BLACK_TEXT_COLOR,
              ),
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "请输入60-100的分值",
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 10.0, 10.0),
              ),
            ),
          ),
          Container(
            padding: new EdgeInsets.fromLTRB(0, 20, 0, 40),
            child:  TakePhotoView(
                defineText: "+拍照\n(必填)",
                imagePath: imagePath,
                takePhoneImageAction:(editText) => _searchAction(editText)) ,

          )

        ],
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
      title: Text("建筑风险比例"),
      actions: <Widget>[
        Container(
          padding: new EdgeInsets.fromLTRB(0, 0, 0, 0),
          alignment: Alignment.center,
          child: GestureDetector(
              onTap: () {
                // 点击空白页面关闭键盘
                _textSql();
              },
              child: Padding(
                padding: new EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Text(
                  "保存",
                  style: TextStyle(
                    color: isCheak? prefix0.GREEN_COLOR : Colors.grey,
                  ),
                ),
              )),
        ),
      ],
    );

    Widget myListView = new ListView.builder(
        physics: new AlwaysScrollableScrollPhysics()
            .applyTo(new BouncingScrollPhysics()), // 这个是用来控制能否在不屏的状态下滚动的属性
        itemCount: dataList.length == 0 ? 1 : dataList.length+2,
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
                Text("暂无题目",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: prefix0.LIGHT_TEXT_COLOR,
                        fontWeight: FontWeight.normal,
                        fontSize: 17)),
              ]),
            );
          }
          if(index==0){
            return headerView;
          }

          if(index==dataList.length+1){
            return footerView;
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
//                        _startManagePage(dataList[index-1]);
                      },
                      child: Container(

                        color: Colors.white,
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 20, right: 20),
                        child: Row(
                            //Row 中mainAxisAlignment是水平的，Column中是垂直的
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //表示所有的子件都是从左到顺序排列，这是默认值
                            textDirection: TextDirection.ltr,
                            children: <Widget>[
                              //这决定了左对齐
                              new Radio(
                                    value: index,
                                    groupValue: _groupValue,
                                    onChanged: (int e) {
                                      _groupValue = e;
                                      setState(() {});
                                    }),

                              Expanded(
                                child: Text(
                                  dataList[index-1].name + "望京费家村-非机动车停车场望京费家村-非机动车停车场望京费家村-非机动车停车场望京费家村-非机动车停车场望京费家村-非机动车停车场望京费家村-非机动车停车场望京费家村-非机动车停车场",
                                  style: new TextStyle(
                                      fontSize: prefix0.fontsSize),
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
            secondaryActions: <Widget>[],
          );
        });

    Widget reflust = new RefreshIndicator(
        displacement: 10.0, child: myListView, onRefresh: getListNetCall);

    Widget bodyContiner = new Container(
      color: Colors.white,
      // height: 140, //高度不填会自适应
      padding: const EdgeInsets.only(top: 0.0, bottom: 0, left: 0, right: 0),
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
            child: reflust,
          ),
          // bottomButton,
        ],
      ),
    );

    return new Scaffold(
      appBar: navBar,
      body: GestureDetector(
        onTap: () {
          // 点击空白页面关闭键盘
          FocusScope.of(context).requestFocus(blankNode);
        },
        child: bodyContiner,
      ),
    );
  }
}
