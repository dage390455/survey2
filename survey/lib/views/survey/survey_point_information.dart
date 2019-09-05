//现场情况
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sensoro_survey/views/survey/SurveyPointInformation/summary_construction_page.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/const.dart';

import 'Electric_box_information_page.dart';
import 'SurveyPointInformation/survay_electrical_fire_edit.dart';

class SurveyPointInformationPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SurveyPointInformationPage> {
  var isCheack = false;
  var isLastPage = false;
  var currentPage = 0;

  static bool _isAddGradient = false;

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
      height: !isLastPage ? 108 : 108,
      width: prefix0.screen_width,
      child: Column(
          //这行决定了左对齐
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            !isLastPage
                ? rightArrawContainer
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
            Container(
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

    Widget container = Container(
      color: prefix0.LIGHT_LINE_COLOR,
      padding: EdgeInsets.all(20),
      child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text("指导说明书"),
            alignment: Alignment.center,
          ),
          new Padding(
            padding: new EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Text("请先根据以下问题了解现场环境，整理需要检测的电箱位置。"),
          ),
          new Padding(
            padding: new EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Text("1.了解总电箱和分电箱层级结构"),
          ),
          new Padding(
            padding: new EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Text("2.哪些电箱危险/风险系数高"),
          ),
          new Padding(
            padding: new EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Text("3.哪些电箱经常出现负载过高的情况？"),
          ),
          new Padding(
            padding: new EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Text("4.哪些电箱如果出现问题，影响范围很大？"),
          ),
          new Padding(
            padding: new EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Text("5.哪些电箱如果出现问题，将造成很大的财产损失？"),
          ),
          new Padding(
            padding: new EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Text("6.是否有重要设备需要监测？"),
          ),
        ],
      ),
    );

    Widget bigContainer = Container(
      color: prefix0.LIGHT_LINE_COLOR,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          container,
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
      // new ConstrainedBox(
      //   constraints: const BoxConstraints.expand(),
      //   child: new Image(
      //     image: new AssetImage("assets/images/指导说明书p4.png"),
      //     width: double.infinity,
      //     height: double.infinity,
      //     fit: BoxFit.fitWidth,
      //   ),
      // ),
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
          // pageSnapping: true,
          // reverse: false,
          // physics: PageScrollPhysics(parent: BouncingScrollPhysics()),
          // dragStartBehavior: DragStartBehavior.down,
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
                // onTap: () {
                //   Scaffold.of(context).showSnackBar(SnackBar(
                //     backgroundColor: Colors.white,
                //     duration: Duration(milliseconds: 20000),
                //     content: Center(
                //       child: new Image(
                //         image: new AssetImage(imagePath),
                //         width: prefix0.screen_width + 300,
                //         height: (prefix0.screen_width + 300) * 1.3,
                //         // width: 20,
                //         // height: 20,
                //         // fit: BoxFit.fitWidth,
                //       ),
                //     ),
                //   ));
                // },
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

    return mainScaffold;

    return Scaffold(
      appBar: NavBar,
      body: bigContainer,
      bottomSheet: bottomButton,
    );
  }
}

class Continer {}
