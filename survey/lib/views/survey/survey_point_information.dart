//现场情况
import 'package:flutter/material.dart';
import 'package:sensoro_survey/views/survey/SurveyPointInformation/summary_construction_page.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;

import 'Electric_box_information_page.dart';

class SurveyPointInformationPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SurveyPointInformationPage> {
  var isCheack = false;

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
          builder: (context) =>  new SummaryConstructionPage()),
    );

    if (result != null) {
      String name = result as String;

      if(name == "1"){
        Navigator.of(context).pop("1");
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(viewportFraction: 0.8);
    controller.addListener(() {});

    Widget NavBar = AppBar(
      elevation: 1.0,
      centerTitle: true,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text(
        "现场情况",
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

    Widget bottomButton = Container(
      color: prefix0.LIGHT_LINE_COLOR,
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

    Widget mainScaffold = Scaffold(
      appBar: NavBar,
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox.fromSize(
          size: Size.fromHeight(550.0),
          child: PageView.builder(
            controller: controller,
            itemCount: 3,
            onPageChanged: (int index) {
              if (index == 2) {
                setState(() {
                  isCheack = true;
                });
              }
            },
            itemBuilder: (BuildContext context, int index) {
              String imagePath = "";
              switch (index) {
                case 0:
                  imagePath = "assets/images/page1.png";
                  break;
                case 1:
                  imagePath = "assets/images/page2.png";
                  break;
                case 2:
                  imagePath = "assets/images/page3.png";
                  isCheack = true;
                  break;
              }

              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 4.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.white,
                      duration: Duration(milliseconds: 20000),
                      content: Center(
                        child: new Image(
                          image: new AssetImage(imagePath),
                          width: prefix0.screen_width + 300,
                          height: (prefix0.screen_width + 300) * 1.3,
                          // width: 20,
                          // height: 20,
                          // fit: BoxFit.fitWidth,
                        ),
                      ),
                    ));
                  },
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(8.0),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        new Image(
                          image: new AssetImage(imagePath),
                          width: 20,
                          height: 20,
                          // fit: BoxFit.fitWidth,
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
