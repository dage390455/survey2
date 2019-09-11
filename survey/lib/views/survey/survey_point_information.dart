//现场情况
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:sensoro_survey/views/survey/SurveyPointInformation/summary_construction_page.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/const.dart';

import 'Electric_box_information_page.dart';
import 'SurveyPointInformation/survay_electrical_fire_edit.dart';
import 'common/data_transfer_manager.dart';

class SurveyPointInformationPage extends StatefulWidget {
  String input;
  SurveyPointInformationPage({Key key, @required this.input}) : super(key: key);

  @override
  _State createState() => _State(input: this.input);
}

class _State extends State<SurveyPointInformationPage> {
  String input;
  _State({this.input});
  String inputStr = "";

  List<String> descList = [];
  var isCheack = false;
  var isLastPage = false;
  var currentPage = 0;

  static bool _isAddGradient = false;

  @override
  void initState() {
    // insertData();

    inputStr = this.input;
    if (inputStr is Null || inputStr.length == 0) {
      this.initDescList();
    }

    descList = inputStr.split("\n");
    descList.add("                        ");
    descList.add("                        ");
    descList.add("                        ");
  }

  void initDescList() {
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
    inputStr = str1 + str2 + str3 + str4 + str5;
  }

  var decorationBox = DecoratedBox(
    decoration: _isAddGradient
        ? BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.bottomRight,
              end: FractionalOffset.topLeft,
              colors: [
                Color(0x00000000).withOpacity(0.9),
                Color(0xff000000).withOpacity(0.01),
              ],
            ),
          )
        : BoxDecoration(),
  );

  nextStep() async {
    DataTransferManager.shared.isEditModel = false;

    final result = await Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => new SurvayElectricalFireEditPage()),
    );

    if (result != null) {
      String name = result as String;

      if (name == "1") {
        Navigator.of(context).pop("1");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // viewportFraction决定了左右边距有多大
    PageController pageController = PageController(viewportFraction: 1.05);
    pageController.addListener(() {});

    Widget NavBar = AppBar(
      elevation: 1.0,
      centerTitle: true,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text(
        "指导说明书",
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

    Row rightArrawContainer = new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //表示所有的子控件都是从左到右序排列，这是默认值
        textDirection: TextDirection.rtl,
        children: <Widget>[
          IconButton(
            iconSize: 30,
            icon: Icon(Icons.chevron_right),
            onPressed: () {
              currentPage++;
              pageController.jumpToPage(currentPage);
              setState(() {});
            },
          ),
        ]);

    Widget bottomButton = Container(
      color: Colors.white,
      height: !isLastPage ? 0 : 108,
      width: prefix0.screen_width,
      child: Column(
          //这行决定了左对齐
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            !isLastPage
                ? emptyContainer
                : new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //表示所有的子控件都是从左到右序排列，这是默认值
                    textDirection: TextDirection.ltr,
                    children: <Widget>[
                        IconButton(
                          icon: isCheack
                              ? Icon(Icons.check_box)
                              : Icon(Icons.check_box_outline_blank),
                          onPressed: () {
                            setState(() {
                              isCheack ? isCheack = false : isCheack = true;
                            });
                          },
                        ),
                        Text('我已阅读完说明',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 20)),
                      ]),
            !isLastPage
                ? emptyContainer
                : Container(
                    height: 60,
                    width: prefix0.screen_width,
                    child: new MaterialButton(
                      color: this.isCheack ? prefix0.GREEN_COLOR : Colors.grey,
                      textColor: Colors.white,
                      child: new Text('下一步',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 20)),
                      onPressed: () {
                        if (this.isCheack) {
                          nextStep();
//            Navigator.push(
//              context,
//              new MaterialPageRoute(
//                  builder: (context) => new SummaryConstructionPage()),
//            );
                        }
                      },
                    ),
                  ),
          ]),
    );

    Widget bigContainer = Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          emptyContainer,
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Checkbox(
                value: this.isCheack,
                onChanged: (bool value) {
                  setState(() {
                    this.isCheack = value;
                  });
                },
              ),
              Text("我已阅读完说明"),
            ],
          )
        ],
      ),
    );

    final List<Widget> _pages = <Widget>[
      new ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: new Image(
          width: double.infinity,
          height: double.infinity,
          // fit: BoxFit.fitWidth,case 2:
          image: new AssetImage("assets/images/page1.png"),
          // width: 200,
          // height: 200,
          // fit: BoxFit.fitWidth,
        ),
      ),
      new ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: new Image(
          image: new AssetImage("assets/images/page2.png"),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fitWidth,
        ),
      ),
      new Image(
        image: new AssetImage("assets/images/page3.png"),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.fitWidth,
      ),
    ];

    Widget mainScaffold = Scaffold(
      appBar: NavBar,
      backgroundColor: Colors.white,
      body: Container(
        // width: prefix0.screen_width + 200,
        height: 530,
        color: Colors.white,
        child: PageView.builder(
          controller: pageController, //这一句导致有边缘不是全屏
          itemCount: 3,
          onPageChanged: (int index) {
            currentPage = index;
            if (index == 2) {
              setState(() {
                isLastPage = true;
              });
            } else {
              setState(() {
                isLastPage = false;
              });
            }
          },
          itemBuilder: (BuildContext context, int index) {
            return _pages[index];
            String imagePath = "";
            switch (index) {
              case 0:
                imagePath = "assets/images/指导说明书p1.png";
                break;
              case 1:
                imagePath = "assets/images/指导说明书p2.png";
                break;
              case 2:
                imagePath = "assets/images/指导说明书p3.png";
                break;
              case 3:
                imagePath = "assets/images/指导说明书p4.png";
                break;
            }

            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 0.0,
              ),
              child: GestureDetector(
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(8.0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      new Image(
                        image: new AssetImage(imagePath),
                        // width: 200,
                        // height: 200,
                        fit: BoxFit.fitWidth,
                      ),
                      decorationBox,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomSheet: bottomButton,
    );

    // return mainScaffold;

//     Widget container = Container(
//       color: prefix0.LIGHT_LINE_COLOR,
//       padding: EdgeInsets.all(20),
//       child: Column(
// //           mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           for (int i = 0; i < descList.length; i++)
//             {
//               new Padding(
//                 padding: new EdgeInsets.fromLTRB(0, 20, 0, 20),
//                 child: Text(
//                   "1. 了解现场的基本信息。",
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.normal,
//                       fontSize: 20),
//                 ),
//               ),
//             }
//         ],
//       ),
//     );

    bool dataNotification(ScrollNotification notification) {
      if (notification.metrics.axis == Axis.horizontal) {
        return false;
      }

      if (notification is ScrollEndNotification) {
        if (Platform.isIOS) {
          double height = notification.metrics.maxScrollExtent; //step2的高度
          height = height - 80;
          if (notification.metrics.extentBefore > height) {
            //下滑到最底部
            isLastPage = true;
            setState(() {});
          } //滑动到最顶部
          if (notification.metrics.extentAfter > height) {}
        } else if (Platform.isAndroid) {
          //android相关代码
          if (notification is ScrollEndNotification) {
            if (notification.metrics.extentAfter == 0) {
              //下滑到最底部
              isLastPage = true;
              setState(() {});
            } //滑动到最顶部
            if (notification.metrics.extentBefore == 0) {}
          }
        }
      }

      return true;
    }

    Widget myListView = new NotificationListener(
      onNotification: dataNotification,
      child: new ListView.builder(
        physics: new AlwaysScrollableScrollPhysics()
            .applyTo(new BouncingScrollPhysics()), // 这个是用来控制能否在不满屏的状态下滚动的属性
        itemCount: descList.length == 0 ? 0 : descList.length,
        // separatorBuilder: (BuildContext context, int index) =>
        // Divider(height: 1.0, color: Colors.grey, indent: 20), // 添加分割线
        itemBuilder: (BuildContext context, int index) {
          String desc = descList[index];
          bool titleFlag = false;
          if (desc.contains("1.") ||
              desc.contains("2.") ||
              desc.contains("3.") ||
              desc.contains("4.") ||
              desc.contains("5.") ||
              desc.contains("6.") ||
              desc.contains("7.") ||
              desc.contains("8.") ||
              desc.contains("9.") ||
              desc.contains("0.")) {
            titleFlag = true;
          }

          return new Padding(
            padding: new EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(
              desc,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: titleFlag ? FontWeight.bold : FontWeight.normal,
                  fontSize: 19),
            ),
          );
        },
      ),
    );

    return Scaffold(
      appBar: NavBar,
      body: myListView,
      bottomSheet: bottomButton,
    );
  }
}

const electricalItems = [
  "1.电箱信息",
  "2.电箱照����",
  "3.安装环境",
  "4.运作环境",
  "5.设备预选",
];

class Continer {}
