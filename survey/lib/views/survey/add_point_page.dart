// @Author: zyg
/// @Date: 2019-07-23
/// @Last Modified by: zyg
/// @Last Modified time: 2019-07-23
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sensoro_survey/widgets/component.dart';
import 'package:sensoro_survey/widgets/text_input.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/const.dart';
import 'package:sensoro_survey/views/survey/editPage/edit_project_name_page.dart';
import 'package:sensoro_survey/model/project_info_model.dart';
import 'package:sensoro_survey/views/survey/sitePages/Model/SitePageModel.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:sensoro_survey/net/api/app_api.dart';
import 'package:sensoro_survey/widgets/component.dart';
import 'package:sensoro_survey/model/component_configure_model.dart';
import 'package:sensoro_survey/net/api/net_config.dart';
import 'package:sensoro_survey/views/survey/utility.dart';
import 'package:sensoro_survey/widgets/progress_hud.dart';
//import 'package:sensoro_survey/views/survey/editPage/edit_project_name_page.dart';
import 'package:sensoro_survey/views/survey/common/save_data_manager.dart';
import 'package:sensoro_survey/views/survey/addPointPages/Model/PointListModel.dart';

class AddPointPage extends StatefulWidget {
  projectInfoModel input;
  PointListModel model;

  bool isEdit;

  AddPointPage({Key key, @required this.input, this.isEdit, this.model})
      : super(key: key);

  @override
  _AddPointPageState createState() => _AddPointPageState(
      input: this.input, isEdit: this.isEdit, model: this.model);
}

class _AddPointPageState extends State<AddPointPage> {
  projectInfoModel input;
  PointListModel model;
  bool isEdit = false;

  _AddPointPageState({this.input, this.isEdit, this.model});

  String name = "";
  String time = "";
  String siteTypeName = "场所层级";
  String siteType = "";
  String siteName = "场所名称";
  String siteUse = "";
  String siteUseName = "场所用途";
  double money = 0;
  double peopleNum = 0;

  String pointId = "";
  String siteId = "";
  String projectId = "";
  String status = "";
  List<dynamic> subList = [];
  bool isCheack = false;

  int managerCount = 1;
  bool _loading = false;
  Map<String, dynamic> admin = {"name": "", "mobile": ""};
  List<Map<String, dynamic>> managerList = [
    {"name": "", "mobile": ""}
  ];
  List<Map<String, dynamic>> siteTypeList = [
    {"key": "area", "name": "区域"},
    {"key": "building", "name": "建筑"},
  ];

  List<Map<String, dynamic>> siteUseList = [
    {"key": "area", "name": "城乡结合部"},
    {"key": "other", "name": "其他"},
  ];
  List<SitePageModel> dataList = [];
  UtilityPage utility = UtilityPage();

  TextEditingController TextController1 = TextEditingController();
  TextEditingController step1TextController = TextEditingController();
  TextEditingController step2TextController = TextEditingController();
  TextEditingController managerTextController1 = TextEditingController();
  TextEditingController managerTextController2 = TextEditingController();
  TextEditingController moneyTextController = TextEditingController();
  TextEditingController peopleTextController = TextEditingController();

  List<TextEditingController> textCList = [];

  FocusNode blankNode = FocusNode();

  @override
  void initState() {
    model = this.model;
    projectId = this.input.projectId;
    subList = this.input.subList;
    isEdit = this.isEdit;

    if (isEdit == true) {
      siteType = model.site_type;
      money = model.total_assets.toDouble();
      peopleNum = model.resident_count.toDouble();
      siteUseName = model.site_use;
    }

    super.initState();
    if (name.length > 0 && projectId.length > 0) {
      this.isEdit = true;
    }
    for (int i = 0; i < siteTypeList.length; i++) {
      Map<String, dynamic> dic = siteTypeList[i];
      if (siteType == dic["key"]) {
        siteTypeName = dic["name"];
      }
    }
    getSiteListNetCall();
    getPointDetailNetCall();
    if (this.model.site_type.length > 0 && this.model != null) {
      getNameListNetCall(this.model.site_type);
    }

    pointId = this.model.id;
    name = this.model.name;

    TextController1.text = this.name;
    TextController1.addListener(() {
      this.name = TextController1.text;
    });

    step1TextController.text = "";
    step1TextController.addListener(() {
      admin["name"] = step1TextController.text;
    });
    step2TextController.text = "";
    step2TextController.addListener(() {
      admin["mobile"] = step2TextController.text;
    });

    managerTextController1.addListener(() {
      Map<String, dynamic> manager = managerList[0];
      manager["name"] = managerTextController1.text;
    });
    managerTextController2.addListener(() {
      Map<String, dynamic> manager = managerList[0];
      manager["mobile"] = managerTextController2.text;
    });
    textCList.add(managerTextController1);
    textCList.add(managerTextController2);
  }

  Future getSiteListNetCall() async {
    String urlStr = NetConfig.siteListUrl + "0";
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
        setState(() {});
      } else {
        utility.showToast("网络请求失败，请检查网络");
      }
    }
  }

  Future getNameListNetCall(String type) async {
    String urlStr = NetConfig.siteListUrl + "0";
    urlStr = urlStr + "&type=" + type;
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
              if (siteId == model.id) {
                siteName = model.name;
              }

              if (model != null) {
                dataList.add(model);
              }
            }
          }
        }
        setState(() {});
      } else {
        utility.showToast("网络请求失败，请检查网络");
      }
    }
  }

  void addPointNetCall() async {
    if (name.length == 0) {
      utility.showToast("勘察点名称不能为空");
      return;
    }
    if (siteType.length == 0) {
      utility.showToast("场所类型不能为空");
      return;
    }
    if (siteName.length == 0) {
      utility.showToast("场所名称不能为空");
      return;
    }
    if (siteUse.length == 0) {
      utility.showToast("场所用途不能为空");
      return;
    }
    String name1 = admin["name"];
    if (name1.length == 0) {
      utility.showToast("责任人名字不能为空");
      return;
    }
    String mobile = admin["mobile"];
    if (mobile.length == 0) {
      utility.showToast("责任人电话不能为空");
      return;
    }

    List<Map<String, dynamic>> list = [];
    list.add({
      "type": "fire_admin",
      "user_name": admin["name"],
      "mobile": admin["mobile"]
    });

    for (int i = 0; i < managerList.length; i++) {
      Map<String, dynamic> dic = managerList[i];
      list.add({
        "type": "fire_responsor",
        "user_name": dic["name"],
        "mobile": dic["mobile"]
      });
    }

    String urlStr = NetConfig.addPointUrl;
    Map<String, dynamic> headers = {"Content-Type": "application/json"};
    //从dataList取数据

    Map<String, dynamic> json = {};
    json["site_id"] = siteId;
    json["site_type"] = siteType;
    json["site_use"] = siteUseName;
    json["name"] = name;
    json["total_assets"] = money.toString();
    json["resident_count"] = peopleNum.toString();
    json["project_id"] = projectId;
    json["contact_list"] = list;

    _startLoading();
    Map<String, dynamic> params = {"data": json};

    ResultData resultData = await AppApi.getInstance()
        .postListNetCall(context, true, urlStr, headers, params);
    if (resultData.isSuccess()) {
      // _stopLoading();
      int code = resultData.response["code"].toInt();
      _stopLoading();
      if (code == 200) {
        var msg = "创建勘察点成功";
        utility.showToast(msg);

        Navigator.of(context).pop("refreshList");
      } else {
        var msg = resultData.response["msg"];
        utility.showToast(msg);
      }
    }
  }

  void getPointDetailNetCall() async {
    String urlStr = NetConfig.pointDetailUrl + model.id;
    Map<String, dynamic> headers = {};
    Map<String, dynamic> params = {};
    // limit=5&offset=5

    ResultData resultData = await AppApi.getInstance()
        .getListNetCall(context, true, urlStr, headers, params);
    if (resultData.isSuccess()) {
      // _stopLoading();
      int code = resultData.response["code"].toInt();
      if (code == 200) {
        if (resultData.response["data"] is Map) {
          Map resultMap = resultData.response["data"];

          name = resultMap["name"];
          status = resultMap["status"];
          siteId = resultMap["site_id"];
          siteType = resultMap["site_type"];
          siteUseName = resultMap["site_use"];
          money = resultMap["total_assets"].toDouble();
          peopleNum = resultMap["resident_count"].toDouble();
          moneyTextController.text = money.toString();
          peopleTextController.text = peopleNum.toString();

          List<dynamic> subList = resultMap["contact_list"];
          if (subList.length > 0) {
            for (int i = 0; i < subList.length; i++) {
              if (subList[0] is Map && i == 0) {
                Map dic = subList[0];
                admin["name"] = dic["user_name"];
                admin["mobile"] = dic["mobile"];
                step1TextController.text = admin["name"];
                step2TextController.text = admin["mobile"];
                continue;
              }

              if (subList[i] is Map) {
                Map dic = subList[i];
                Map<String, dynamic> dic1 = {};
                dic1["name"] = dic["user_name"];
                dic1["mobile"] = dic["mobile"];
                if (i == 1) {
                  managerTextController1.text = dic1["name"];
                  managerTextController2.text = dic1["mobile"];
                }

                SitePageModel model = SitePageModel.fromJson(dic1);
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
  }

//必须加 async才会能进返回
  deletePointNetCall() async {
    String urlStr = NetConfig.baseUrl + NetConfig.deletePointUrl + model.id;
    Map<String, dynamic> headers = {"Content-Type": "application/json"};
    Map<String, dynamic> params = {};

    ResultData resultData = await AppApi.getInstance()
        .delete(urlStr, params: params, context: context, showLoad: true);

    if (resultData.isSuccess()) {
      // _stopLoading();

      int code = resultData.response["code"].toInt();
      if (code == 200) {
        utility.showToast("勘察点已删除");
        Navigator.of(context).pop("refreshList");

        // await Navigator.popUntil(context, ModalRoute.withName('projectList'));
      } else {
        utility.showToast("网络请求失败，请检查网络");
      }
    } else {}
  }

  updatePointNetCall() async {
    String urlStr =
        NetConfig.baseUrl + NetConfig.updateProjectUrl + input.projectId;

    if (name.length == 0) {
      utility.showToast("勘察点名称不能为空");
      return;
    }
    if (siteType.length == 0) {
      utility.showToast("场所类型不能为空");
      return;
    }
    if (siteName.length == 0) {
      utility.showToast("场所名称不能为空");
      return;
    }
    String name1 = admin["name"];
    if (name1.length == 0) {
      utility.showToast("责任人名字不能为空");
      return;
    }
    String mobile = admin["mobile"];
    if (mobile.length == 0) {
      utility.showToast("责任人电话不能为空");
      return;
    }

    List<Map<String, dynamic>> list = [];
    list.add({
      "type": "fire_admin",
      "user_name": admin["name"],
      "mobile": admin["mobile"]
    });

    for (int i = 0; i < managerList.length; i++) {
      Map<String, dynamic> dic = managerList[i];
      list.add({
        "type": "fire_responsor",
        "user_name": dic["name"],
        "mobile": dic["mobile"]
      });
    }
    Map<String, dynamic> headers = {"Content-Type": "application/json"};
    //从dataList取数据

    Map<String, dynamic> json = {};
    json["site_id"] = siteId;
    json["site_type"] = siteType;
    json["name"] = name;
    json["site_use"] = siteUseName;

    json["contact_list"] = list;
    json["total_assets"] = money.toString();
    json["resident_count"] = peopleNum.toString();
    // _startLoading();
    Map<String, dynamic> params = {"data": json};

    ResultData resultData = await AppApi.getInstance()
        .put(urlStr, params: params, context: context, showLoad: true);
    if (resultData.isSuccess()) {
      // _stopLoading();

      int code = resultData.response["code"].toInt();
      if (code == 200) {
        Navigator.of(context).pop("refreshList");
        utility.showToast("勘察点信息已更新");
      } else {
        utility.showToast("网络请求失败，请检查网络");
      }
    }
  }

  //小菊花
  Future<Null> _stopLoading() async {
    setState(() {
      _loading = false;
    });
  }

  Future<Null> _startLoading() async {
    setState(() {
      _loading = true;
    });
  }

  void saveInfoInLocal() {
    int currentTimeMillis = prefix0.currentTimeMillis();
    DateTime _dateTime = DateTime.now();
    String monthStr =
        _dateTime.month < 10 ? "0${_dateTime.month}" : "${_dateTime.month}";
    String dayStr =
        _dateTime.day < 10 ? "0${_dateTime.day}" : "${_dateTime.day}";
    String hourStr =
        _dateTime.hour < 10 ? "0${_dateTime.hour}" : "${_dateTime.hour}";
    String minuteStr =
        _dateTime.minute < 10 ? "0${_dateTime.minute}" : "${_dateTime.minute}";

    if (this.subList == null) {
      this.subList = [];
    }
    String datestr =
        "${_dateTime.year}-${monthStr}-${dayStr} ${hourStr}:${minuteStr}";
    input.createTime = datestr;
    input.projectName = this.name;
    input.subList = this.subList;
    if (!isEdit) {
      // input.projectId = currentTimeMillis;
    }

    String historyKey = 'projectList';
    Map<String, dynamic> map = input.toJson();
    String jsonStr = json.encode(map);
    // jsonStr = jsonStr.replaceAll(',', ';');
    if (isEdit) {
      SaveDataManger.replaceHistory(
        jsonStr,
        historyKey,
        input.projectId,
      );
    } else {
      SaveDataManger.addHistory(jsonStr, historyKey);
    }
  }

  void _addManager() async {
    // this.name = name;
    managerCount++;
    managerList.add({"name": "", "mobile": ""});

    int count = managerList.length;
    TextEditingController managerTextController1 = TextEditingController();
    TextEditingController managerTextController2 = TextEditingController();

    managerTextController1.addListener(() {
      Map<String, dynamic> manager = managerList[count - 1];
      manager["name"] = managerTextController1.text;
    });
    managerTextController2.addListener(() {
      Map<String, dynamic> manager = managerList[count - 1];
      manager["mobile"] = managerTextController2.text;
    });
    textCList.add(managerTextController1);
    textCList.add(managerTextController2);

    setState(() {});
  }

  void addorEdit() async {
    if (isEdit == true) {
      updatePointNetCall();
    } else {
      addPointNetCall();
    }
  }

  @override
  Widget build(BuildContext context) {
    editName() async {
      final result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new EditProjectNamePage(
                  name: this.name,
                )),
      );

      if (result != null) {
        String name = result as String;

        // updateNextButton();
        setState(() {
          this.name = name;
        });
      }
    }

    Widget emptyContainer = Container(
      height: 0,
      width: 0,
    );

    Widget bottomButton = Container(
      color: prefix0.LIGHT_LINE_COLOR,
      height: 60,
      width: prefix0.screen_width,
      child: new MaterialButton(
        color: Colors.red,
        textColor: Colors.white,
        child: new Text('删除',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 20)),
        onPressed: () {
          deletePointNetCall();
        },
      ),
    );

    List<PopupMenuItem<String>> siteTypePopList() {
      List<PopupMenuItem<String>> list = [];
      for (int i = 0; i < siteTypeList.length; i++) {
        Map<String, dynamic> dic = siteTypeList[i];
        list.add(new PopupMenuItem<String>(
            child: new Text(dic["name"]), value: i.toString()));
      }

      return list;
    }

    List<PopupMenuItem<String>> siteNamePopList() {
      List<PopupMenuItem<String>> list = [];

      for (int i = 0; i < dataList.length; i++) {
        SitePageModel model = dataList[i];
        list.add(new PopupMenuItem<String>(
            child: new Text(model.name), value: i.toString()));
      }

      return list;
    }

    List<PopupMenuItem<String>> siteUsePopList() {
      List<PopupMenuItem<String>> list = [];
      for (int i = 0; i < siteUseList.length; i++) {
        Map<String, dynamic> dic = siteUseList[i];
        list.add(new PopupMenuItem<String>(
            child: new Text(dic["name"]), value: i.toString()));
      }

      return list;
    }

    //弹出的选择LIST
    Container popTypeView = new Container(
      alignment: Alignment.center,
      height: 60,
      width: 200,
      child: Center(
        child: PopupMenuButton(
//              icon: Icon(Icons.home),
          child: new Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  siteTypeName,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
              Image.asset(
                "assets/images/arrow_folddown.png",
                width: 20,
              )
            ],
          ),
          tooltip: "长按提示",
          initialValue: "hot",
          offset: Offset(0.2, 0),
          padding: EdgeInsets.only(top: 0.0, bottom: 0, left: 100, right: 0),

          itemBuilder: (context) =>
              <PopupMenuItem<String>>[]..addAll(siteTypePopList()),

          onSelected: (String s) {
            Map<String, dynamic> dic = siteTypeList[int.parse(s)];
            siteTypeName = dic["name"];
            siteType = dic["key"];
            getNameListNetCall(siteType);
            siteName = "场所名称";
            setState(() {
              // model.variable_value = optionList[int.parse(s)];
              // choosedModel = cars[int.parse(action)];
            });
          },
          onCanceled: () {
            print("onCanceled");
          },
        ),
      ),
    );

    //弹出的选择LIST
    Container popNameView = new Container(
      alignment: Alignment.center,
      height: 60,
      width: 200,
      child: Center(
        child: PopupMenuButton(
//              icon: Icon(Icons.home),
          child: new Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  siteName,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
              Image.asset(
                "assets/images/arrow_folddown.png",
                width: 20,
              )
            ],
          ),
          tooltip: "长按提示",
          initialValue: "hot",
          offset: Offset(0.2, 0),
          padding: EdgeInsets.only(top: 0.0, bottom: 0, left: 100, right: 0),

          itemBuilder: (context) =>
              <PopupMenuItem<String>>[]..addAll(siteNamePopList()),

          onSelected: (String s) {
            SitePageModel model = dataList[int.parse(s)];
            siteName = model.name;
            siteId = model.id;
            setState(() {
              // model.variable_value = optionList[int.parse(s)];
              // choosedModel = cars[int.parse(action)];
            });
          },
          onCanceled: () {
            print("onCanceled");
          },
        ),
      ),
    );

    //弹出的选择LIST
    Container popUseView = new Container(
      alignment: Alignment.center,
      height: 60,
      width: 200,
      child: Center(
        child: PopupMenuButton(
//              icon: Icon(Icons.home),
          child: new Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  siteUseName == null ? "" : siteUseName,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              ),
              Image.asset(
                "assets/images/arrow_folddown.png",
                width: 20,
              )
            ],
          ),
          tooltip: "长按提示",
          initialValue: "hot",
          offset: Offset(0.2, 0),
          padding: EdgeInsets.only(top: 0.0, bottom: 0, left: 100, right: 0),

          itemBuilder: (context) =>
              <PopupMenuItem<String>>[]..addAll(siteUsePopList()),

          onSelected: (String s) {
            Map<String, dynamic> dic = siteUseList[int.parse(s)];
            siteUseName = dic["name"];
            siteUse = dic["key"];
            // getNameListNetCall(siteType);
            // siteName = "场所名称";
            setState(() {
              // model.variable_value = optionList[int.parse(s)];
              // choosedModel = cars[int.parse(action)];
            });
          },
          onCanceled: () {
            print("onCanceled");
          },
        ),
      ),
    );

    Widget listView1 = Container(
      padding: const EdgeInsets.only(top: 20.0, bottom: 0, left: 20, right: 20),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Row(children: <Widget>[
                  Text(
                    "*",
                    style: TextStyle(color: Colors.red),
                  ),
                  new SizedBox(
                    width: 10,
                  ),
                  Text(
                    "勘察点名称",
                    style: new TextStyle(fontSize: prefix0.fontsSize),
                  ),
                ]),
                Container(
                  height: 50,
                  width: 150,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: TextController1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '勘察点名称(必填)',
                    ),
                    maxLines: 1,
                    autofocus: false,
                    onChanged: (val) {
                      name = val;
                      setState(() {});
                    },
                  ),
                ),
              ]),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
          GestureDetector(
            // onTap: editName, //写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Row(children: <Widget>[
                    Text(
                      "*",
                      style: TextStyle(color: Colors.red),
                    ),
                    new SizedBox(
                      width: 10,
                    ),
                    Text(
                      "场所层级",
                      style: new TextStyle(fontSize: prefix0.fontsSize),
                    ),
                  ]),
                  popTypeView,
                ],
              ),
            ),
          ),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
          GestureDetector(
            // onTap: editName, //写入方����名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Row(children: <Widget>[
                    Text(
                      "*",
                      style: TextStyle(color: Colors.red),
                    ),
                    new SizedBox(
                      width: 10,
                    ),
                    Text(
                      "场所名称",
                      style: new TextStyle(fontSize: prefix0.fontsSize),
                    ),
                  ]),
                  popNameView,
                ],
              ),
            ),
          ),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
          GestureDetector(
            // onTap: editName, //写入方����名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Row(children: <Widget>[
                    Text(
                      "*",
                      style: TextStyle(color: Colors.red),
                    ),
                    new SizedBox(
                      width: 10,
                    ),
                    Text(
                      "场所用途",
                      style: new TextStyle(fontSize: prefix0.fontsSize),
                    ),
                  ]),
                  popUseView,
                ],
              ),
            ),
          ),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Row(children: <Widget>[
                  Text(
                    " ",
                    style: TextStyle(color: Colors.red),
                  ),
                  new SizedBox(
                    width: 10,
                  ),
                  Text(
                    "资产总值",
                    style: new TextStyle(fontSize: prefix0.fontsSize),
                  ),
                ]),
                Container(
                  height: 50,
                  width: 80,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: moneyTextController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixText: '元',
                    ),
                    maxLines: 1,
                    autofocus: false,
                    onChanged: (val) {
                      money = double.parse(val);
                      setState(() {});
                    },
                  ),
                ),
              ]),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Row(children: <Widget>[
                  Text(
                    " ",
                    style: TextStyle(color: Colors.red),
                  ),
                  new SizedBox(
                    width: 10,
                  ),
                  Text(
                    "常驻人口",
                    style: new TextStyle(fontSize: prefix0.fontsSize),
                  ),
                ]),
                Container(
                  height: 50,
                  width: 80,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: peopleTextController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: false),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      // hintText: '',
                      suffixText: '万',
                    ),
                    maxLines: 1,
                    autofocus: false,
                    onChanged: (val) {
                      peopleNum = double.parse(val);
                      setState(() {});
                    },
                  ),
                ),
              ]),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
        ],
      ),
    );

    Widget reflust = new RefreshIndicator(
        displacement: 10.0, child: listView1, onRefresh: getSiteListNetCall);

    Widget MainlistView = new ListView.builder(
        physics: new AlwaysScrollableScrollPhysics()
            .applyTo(new BouncingScrollPhysics()), // 这个是用来控制能否在不满屏的状态下滚动的属性
        itemCount: managerList.length == 0 ? 5 : managerList.length * 2 + 7,
        // separatorBuilder: (BuildContext context, int index) =>
        // Divider(height: 1.0, color: Colors.grey, indent: 20), // 添加分割���
        itemBuilder: (BuildContext context, int index) {
          // Map modelMap = managerList[index];
          if (index == 0) {
            return listView1;
          }

          if (index == 1) {
            return Container(
              color: prefix0.FENGE_LINE_COLOR,
              height: 10,
            );
          }
          if (index == 2) {
            return new Container(
              color: Colors.white,
              height: 60,
              padding: const EdgeInsets.only(
                  top: 0.0, bottom: 0, left: 20, right: 20),
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Row(children: <Widget>[
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            ),
                            new SizedBox(
                              width: 10,
                            ),
                            Text(
                              "消防责任人姓名",
                              style: new TextStyle(fontSize: prefix0.fontsSize),
                            ),
                          ]),
                          Container(
                            height: 59,
                            width: 100,
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: step1TextController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '必填',
                              ),
                              maxLines: 1,
                              autofocus: false,
                              onChanged: (val) {
                                admin["name"] = val;
                                setState(() {});
                              },
                            ),
                          ),
                        ]),
                    Container(color: prefix0.FENGE_LINE_COLOR, height: 1),
                  ]),
            );
          }

          if (index == 3) {
            return new Container(
              color: Colors.white,
              height: 60,
              padding: const EdgeInsets.only(
                  top: 0.0, bottom: 0, left: 20, right: 20),
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Row(children: <Widget>[
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            ),
                            new SizedBox(
                              width: 10,
                            ),
                            Text(
                              "消防责任人电话",
                              style: new TextStyle(fontSize: prefix0.fontsSize),
                            ),
                          ]),
                          Container(
                            height: 59,
                            width: 100,
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: step2TextController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '必填',
                              ),
                              maxLines: 1,
                              autofocus: false,
                              onChanged: (val) {
                                admin["mobile"] = val;
                                setState(() {});
                              },
                            ),
                          ),
                        ]),
                    Container(color: prefix0.FENGE_LINE_COLOR, height: 1),
                  ]),
            );
          }

          if (index >= 4 &&
              index <= managerList.length * 2 + 3 &&
              managerList.length > 0 &&
              index % 2 == 0) {
            double a = (index - 2) / 2;
            int item = a.toInt();
            return new Container(
              color: Colors.white,
              height: 60,
              padding: const EdgeInsets.only(
                  top: 0.0, bottom: 0, left: 20, right: 20),
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "消防管理人姓名",
                            style: new TextStyle(fontSize: prefix0.fontsSize),
                          ),
                          Container(
                            height: 59,
                            width: 100,
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.text,
                              controller: textCList[item * 2 - 2],
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '选填',
                              ),
                              maxLines: 1,
                              autofocus: false,
                              onChanged: (val) {
                                setState(() {});
                              },
                            ),
                          ),
                        ]),
                    Container(color: prefix0.FENGE_LINE_COLOR, height: 1),
                  ]),
            );
          }

          if (index >= 4 &&
              index <= managerList.length * 2 + 3 &&
              managerList.length > 0 &&
              index % 2 == 1) {
            double a = (index - 2) / 2;
            int item = a.toInt();
            return new Container(
              color: Colors.white,
              height: 60,
              padding: const EdgeInsets.only(
                  top: 0.0, bottom: 0, left: 20, right: 20),
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "消防管理人电话",
                            style: new TextStyle(fontSize: prefix0.fontsSize),
                          ),
                          Container(
                            height: 59,
                            width: 100,
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.phone,
                              controller: textCList[item * 2 - 1],
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '选填',
                              ),
                              maxLines: 1,
                              autofocus: false,
                              onChanged: (val) {
                                setState(() {});
                              },
                            ),
                          ),
                        ]),
                    Container(color: prefix0.FENGE_LINE_COLOR, height: 1),
                  ]),
            );
          }

          if (index == managerList.length * 2 + 4) {
            return new Container(
              height: 80,
              width: prefix0.screen_width,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: _addManager,
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
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(
                        "+ 消防管理人",
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          if (index == managerList.length * 2 + 5) {
            return new Container(
              width: prefix0.screen_width,
              padding: const EdgeInsets.only(
                  top: 0.0, bottom: 0, left: 20, right: 20),
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: prefix0.screen_width,
                      child: Text("备注",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: prefix0.LIGHT_TEXT_COLOR,
                              fontWeight: FontWeight.normal,
                              fontSize: 15)),
                    ),
                    new SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        border:
                            new Border.all(color: LIGHT_TEXT_COLOR, width: 0.5),
                      ),
                      child: TextField(
                        //文本输入控件
                        onSubmitted: (String str) {
                          //提交监听
                          // searchStr = val;
                          // print('用户提交变更');
                        },

                        textAlign: TextAlign.start,
                        minLines: 1,
                        maxLines: 10,
                        style: new TextStyle(
                          fontSize: 13.0,
                          color: prefix0.BLACK_TEXT_COLOR,
                        ),
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          // border: new Border.all(color: LIGHT_TEXT_COLOR, width: 0.5),
                          hintText: "点击输入",
                          contentPadding: EdgeInsets.fromLTRB(
                              20.0, 20.0, 10.0, 10.0), //设置显示��本的一个内边距
// //                border: InputBorder.none,//取消默认的下划线边框
                        ),
                      ),
                    ),
                    new SizedBox(
                      height: 60,
                    ),
                  ]),
            );
          }
        });

    Column body = Column(children: <Widget>[
      MainlistView,
      Expanded(
        child: reflust,
      ),
    ]);

    return Scaffold(
        appBar: AppBar(
          elevation: 1.0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "新建勘察点",
            style: TextStyle(color: Colors.black),
          ),
          leading: Container(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                // 点击空白页面关闭键盘
                Navigator.pop(context);
              },
              child: Text(
                "取消",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),

          actions: <Widget>[
            Container(
              padding: new EdgeInsets.fromLTRB(0, 0, 20, 0),
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  addorEdit();
                  // Navigator.of(context).pop("");
                },
                child: Text(
                  "保存",
                  style: TextStyle(
                    color: this.name.length > 0
                        ? prefix0.GREEN_COLOR
                        : Colors.grey,
                  ),
                ),
              ),
            ),
          ],
          // IconButton(
          //   icon: Image.asset(
          //     "assets/images/back.png",
          //     // height: 20,
          //   ),
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
        ),
        body: GestureDetector(
          onTap: () {
            // 点击空白页�������键盘
            FocusScope.of(context).requestFocus(blankNode);
          },
          child: Container(
            padding:
                const EdgeInsets.only(top: 0.0, bottom: 0, left: 0, right: 0),
            child: MainlistView,
          ),
        ),
        bottomNavigationBar:
            this.isEdit == true ? bottomButton : emptyContainer);
  }
}
