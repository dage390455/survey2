//现场情况
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensoro_survey/model/electrical_fire_model.dart';
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

import '../const.dart';
import '../survey_type_page.dart';
import 'Model/SitePageModel.dart';

class DynamicCreatePage extends StatefulWidget {


  @override
  _State createState() => _State();
}

class _State extends State<DynamicCreatePage> {
  BasicMessageChannel<String> _basicMessageChannel =
      BasicMessageChannel("BasicMessageChannelPlugin", StringCodec());

  FocusNode blankNode = FocusNode();
  var isCheack = false;
  TextEditingController remarkController = TextEditingController();

  @override
  void initState() {

    super.initState();
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




    Widget bigContainer = Container(
      color: prefix0.LIGHT_LINE_COLOR,
      padding: new EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: new ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[


        ],
      ),
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
