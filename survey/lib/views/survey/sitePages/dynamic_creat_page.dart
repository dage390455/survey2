//现场情况
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensoro_survey/model/component_configure_model.dart';
import 'package:sensoro_survey/model/electrical_fire_model.dart';
import 'package:sensoro_survey/model/mutilcheck_model.dart';
import 'package:sensoro_survey/net/NetService/result_data.dart';
import 'package:sensoro_survey/net/api/app_api.dart';
import 'package:sensoro_survey/net/api/net_config.dart';
import 'package:sensoro_survey/views/survey/SurveyPointInformation/survay_electrical_fire.dart';
import 'package:sensoro_survey/views/survey/common/data_transfer_manager.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/editPage/edit_address_page.dart';
import 'package:sensoro_survey/views/survey/editPage/edit_boss_person_page.dart';
import 'package:sensoro_survey/views/survey/editPage/edit_boss_person_phone_page.dart';
import 'package:sensoro_survey/views/survey/editPage/edit_content_page.dart';
import 'package:sensoro_survey/views/survey/editPage/edit_head_person_page.dart';
import 'package:sensoro_survey/views/survey/editPage/edit_head_person_phone_page.dart';
import 'package:sensoro_survey/views/survey/editPage/edit_name_page.dart';
import 'package:sensoro_survey/views/survey/editPage/edit_purpose_page.dart';
import 'package:sensoro_survey/views/survey/editPage/survey_point_area.dart';
import 'package:sensoro_survey/views/survey/editPage/survey_point_structure.dart';
import 'package:sensoro_survey/views/survey/survey_point_information.dart';
import 'package:sensoro_survey/widgets/component.dart';
import 'package:sensoro_survey/widgets/mutil_check.dart';
import 'package:sensoro_survey/widgets/mutil_check_old.dart';

import '../const.dart';
import '../item_widget.dart';
import '../survey_type_page.dart';
import 'Model/SitePageModel.dart';
import 'Model/Test_configure_model.dart';

class DynamicCreatePage extends StatefulWidget {


  @override
  _State createState() => _State();
}

class _State extends State<DynamicCreatePage> {
  static const riskUrl = "variable_value/list?risk_id=4a997a24-83c7-4129-a09f-ede35bff1a20";
  FocusNode blankNode = FocusNode();
  var isCheack = false;
  TextEditingController remarkController = TextEditingController();
  List<TestComponentModel> dataList = [];
  @override
  void initState() {

    super.initState();
    getConfigureListNetCall();
  }


  void getConfigureListNetCall() async {
    String urlStr = riskUrl;
    Map<String, dynamic> headers = {};
    Map<String, dynamic> params = {};

    ResultData resultData = await AppApi.getInstance()
        .getListNetCall(context, true, urlStr, headers, params);
    if (resultData.isSuccess()) {
      // _stopLoading();
      int code = resultData.response["code"].toInt();
      if (code == 200) {

        if (resultData.response["data"]["records"] is List) {
          List resultList = resultData.response["data"]["records"];
          if (resultList.length > 0) {
              for (int i = 0; i < resultList.length; i++) {
                Map json = resultList[i] as Map;
                TestComponentModel model = TestComponentModel.fromJson(json);
                if (model != null) {
                  dataList.add(model);
                }
              }
              setState(() {
              });
          }
        }

      }
    }
  }




  @override
  Widget build(BuildContext context) {
    Widget NavBar = AppBar(
      elevation: 1.0,
      centerTitle: true,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text(
        "测试动态加载",
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
          padding: new EdgeInsets.fromLTRB(0, 0, 0, 0),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              // 点击空白页面关闭键盘
              if (this.isCheack) {
                Navigator.of(context).pop();
              }
            },
            child: Padding(
              padding: new EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Text(
                "保存",
                style: TextStyle(
                  color: this.isCheack ? prefix0.GREEN_COLOR : Colors.grey,
                ),
              ),
            )
          ),
        ),
      ],
    );
    Widget emptyContainer = Container(
      height: 0,
      width: 0,
    );

//
    Widget getView(TestComponentModel model){
      List<String> optionList = model.options.split(";");

      if (model.comp_code == "check_option" &&
          model.comp_type == "radio") {
        //单选框
        return   MutilCheck1(
          title: model.variable_name,
          dataList: List<MutilCheckModel>.generate(
              optionList.length, (i) => new MutilCheckModel(optionList[i], false)),
          isSingle: true,
        );
      }
      else if (model.comp_code == "check_option" &&
          model.comp_type == "checkbox") {
        //复选框
        return MutilCheck1(
          title: model.variable_name,
          dataList: List<MutilCheckModel>.generate(
              optionList.length, (i) => new MutilCheckModel(optionList[i], false)),
          isSingle: false,
        );
      }
      else {
        return emptyContainer;
      }
    }


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
                Text("暂无控件",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: prefix0.LIGHT_TEXT_COLOR,
                        fontWeight: FontWeight.normal,
                        fontSize: 17)),
              ]),
            );
          }

          return getView(dataList[index]);

        });





    Widget bigContainer = Container(
      color: prefix0.LIGHT_LINE_COLOR,
      padding: new EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: myListView
    );

    return Scaffold(
      appBar: NavBar,
      body: GestureDetector(
        onTap: () {
          // 点击空白页面关闭键盘
          FocusScope.of(context).requestFocus(blankNode);
        },
        child: bigContainer,
      ),
    );
  }


}
