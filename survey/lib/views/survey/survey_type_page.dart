/// @Author: zyg
/// @Date: 2019-07-23
/// @Last Modified by: zyg
/// @Last Modified time: 2019-07-23
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/services.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/const.dart';
import 'package:sensoro_survey/model/survey_type_model.dart';
import 'package:sensoro_survey/views/survey/survey_point_information.dart';

class SurveyTypePage extends StatefulWidget {
  _SurveyTypePageState createState() => _SurveyTypePageState();
}

class _SurveyTypePageState extends State<SurveyTypePage> {
  _SurveyTypePageState() {}

  static List dataList = new List(); //static才能在build里使用
  static int listTotalCount = 0;

  @override
  void initState() {
    super.initState();

    dataList.clear();
    initDetailList();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        //or set color with: Color(0xFF0000FF)
        // statusBarColor: Colors.blue,
        ));
  }

  void initDetailList() {
    for (int index = 0; index < 1; index++) {
      var name = "测试设备 $index";
      if (index == 0) name = "电气火灾安装点";
      if (index == 1) name = "烟感安装点";
      if (index == 2) name = "摄像头安装点";
      if (index == 3) name = "消防主机安装点";

      var path = " ";
      if (index == 0) path = "assets/images/电气火灾.png";
      if (index == 1) path = "assets/images/电气火灾.png";
      if (index == 2) path = "2019-07-06 15:24";
      if (index == 3) path = "2019-07-22 02:14:09";

      surveyTypeModel model = surveyTypeModel(name, path);
      dataList.add(model);
      // var a = 'dd';
      // a = cityDetailArrays[index].name;
    }
  }

  @override
  Widget build(BuildContext context) {
    void _gotoInformation() async {
      // projectInfoModel model = projectInfoModel("", "", 1, "");
      String input = "";
      String str1 =
          "1. 了解现场的基本信息\n（1）到达现场后，需要先了解现场的配电箱数量，以及其层级之间的连接关系。一级为总配电箱/室，二级为分配电箱/室，三级为末端配电箱。\n（2）了解哪些电箱危险/风险系数高，是否需要监测。\n（3）了解哪些电箱经常出现负载过高的情况，是否需要监测。\n";
      String str2 =
          "（4）了解哪些电箱如果出现问题影响范围将很大，是否需要监测。\n（5）了解哪些电箱如果出现问题将造成很大的财产损失，是否需要监测。\n（6）了解是否有重要设备需要监测。\n";
      String str3 =
          "2. 哪些问题地点适合安装电气火灾/智慧空开？\n（1）推荐安装电气火灾的点位（包括单相和三相的电气火灾）各层级的配电箱的总控开关，末端配电箱的总控开关，重要用电设备的控制开关\n（2）推荐安装智慧空开的点位单相线路的点位。例如：照明线路的监测，插座线路的监测等单相用电线路的场景。\n";
      String str4 =
          "3. 哪些问题地点不适合安装电气火灾/智慧空开？\n（1）设备本身的限制性。\n目前我司设备的测量范围（可调）：单相电设备≤84A（场景中监测点开关额定电流），三相电设备≤400A（场景中监测点开关额定电流），智慧空开≤63A（场景中监测点开关额定电流）。上述三种情况，当监测点开关额定电流大于上述阈值，则不适合安装我司设备。\n（2）场景环境限制\n长期恶劣环境可能对设备造成损坏，或安装空间无法实现安装等情况下，不适合安装我司设备。\n";
      String str5 =
          "4. 其他专业性问题\n（1）场所电源的引入情况。通常会有两种方式：\n① 用电量较小的，从公变变压器直接接入低压380V交流电，或者220v交流电，再进行使用。\n② 用电量较大的，一般从高压10kv引入到自有的变压器（专变变压器），转变成380v再进行使用。\n（2）每月用电电量的多少。\n（3）现行配电设备（开关+线路）已经运行的年限及状况。\n运行时间越长，电气系统老化越严重，越会容易出现故障隐患。\n（4）配电设备，包括开关，线路的运行环境。\n例如：选型是否合理，各级线路布线方式 ，控制节点的安装情况。\n（5）客户在使用上的存在其他问题和需要。\n";
      input = str1 + str2 + str3 + str4 + str5;
      final result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new SurveyPointInformationPage(input: input)),
      );

      if (result != null) {
        String name = result as String;

        if (name == "1") {
          Navigator.of(context).pop("1");
        } else {
          setState(() {});
        }
        // this.name = name;
      }
    }

    Widget NavBar = AppBar(
      elevation: 1.0,
      centerTitle: true,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text(
        "勘察类型",
        style: TextStyle(color: Colors.black),
      ),
      leading: IconButton(
        icon: Image.asset(
          "assets/images/back.png",
          // height: 20,
        ),
        onPressed: () {
          // SendEvent();
          Navigator.pop(context);
        },
      ),
    );

    Widget emptyContainer = Container(
      height: 0,
      width: 0,
    );

    Widget myListView = new ListView.builder(
        physics: new AlwaysScrollableScrollPhysics()
            .applyTo(new BouncingScrollPhysics()), // 这个是用来控制能否在不屏的状态下滚动的属性
        itemCount: dataList.length,
        // separatorBuilder: (BuildContext context, int index) =>
        // Divider(height: 1.0, color: Colors.grey, indent: 20), // 添加分割线
        itemBuilder: (BuildContext context, int index) {
          surveyTypeModel model = dataList[index];
          var name = model.name;
          var imagePath = model.ImagePath;

          return Container(
            color: Colors.white,
            padding:
                const EdgeInsets.only(top: 0.0, bottom: 0, left: 0, right: 0),
            child: new Column(

                //这行决定了左对齐
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  index == 0
                      ? Container(
                          color: LIGHT_LINE_COLOR,
                          height: 12,
                          width: prefix0.screen_width,
                        )
                      : emptyContainer,

                  GestureDetector(
                    onTap: _gotoInformation,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(
                          top: 20.0, bottom: 20, left: 20, right: 20),
                      child: Row(
                          //Row 中mainAxisAlignment是水平的，Column中是垂直的
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //表示所有的子控件都是从左到右顺序排列，这是默认值
                          textDirection: TextDirection.ltr,
                          children: <Widget>[
                            new Image(
                              image: new AssetImage(imagePath),
                              width: 20,
                              height: 20,
                              // fit: BoxFit.fitWidth,
                            ),
                            Text(name,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: prefix0.BLACK_TEXT_COLOR,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 17)),
                            new Image(
                              image: new AssetImage(
                                  "assets/images/right_arrar.png"),
                              width: 20,
                              height: 20,
                              // fit: BoxFit.fitWidth,
                            ),
                          ]),
                    ),
                  ),
                  //分割线
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0.0, bottom: 0, left: 20, right: 0),
                    child: Container(
                        alignment: Alignment.center,
                        width: prefix0.screen_width - 40,
                        height: 1.0,
                        color: FENGE_LINE_COLOR),
                  ),
                ]),
          );
        });

    return Scaffold(
      appBar: NavBar,
      body: myListView,
    );
  }
}
