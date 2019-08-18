

//现场情况
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensoro_survey/views/survey/SurveyPointInformation/stick_widget.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;






class SurvayElectricalFirePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SurvayElectricalFirePage> {

  var isCheack = false;

  @override
  Widget build(BuildContext context) {

    Widget NavBar = AppBar(
      elevation: 1.0,
      centerTitle:true,
      brightness: Brightness.light,
      backgroundColor: Colors.white,

      title: Text(
        "电器火灾安装",
        style: TextStyle(
            color: Colors.black
        ),

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
      color:  prefix0.LIGHT_LINE_COLOR,
      height: 60,
      width: prefix0.screen_width,
      child: new MaterialButton(
        color: this.isCheack? prefix0.GREEN_COLOR :Colors.grey,
        textColor: Colors.white,
        child: new Text('下一步',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 20)),
        onPressed: () {
          if (this.isCheack){
//            Navigator.push(
//              context,
//              new MaterialPageRoute(builder: (context) => new  SummaryConstructionPage()),
//            );
          }
        },
      ),
    );




    Widget container = Container(
      color: prefix0.LIGHT_LINE_COLOR,
      padding:  EdgeInsets.all(20),
      child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container (
            child: Text("指导说明书") ,
            alignment: Alignment.center,
          )

          ,

          new Padding(
            padding: new EdgeInsets.fromLTRB(0, 20, 0, 20),
            child:  Text("请先根据以下问题了解现场环境，整理需要检测的电箱位置。"),
          ),

          new Padding(
            padding: new EdgeInsets.fromLTRB(0, 0, 0, 20),
            child:  Text("1.了解总电箱和分电箱层级结构"),
          ),
          new Padding(
            padding: new EdgeInsets.fromLTRB(0, 0, 0, 20),
            child:  Text("2.哪些电箱危险/风险系数高"),
          ),
          new Padding(
            padding: new EdgeInsets.fromLTRB(0, 0, 0, 20),
            child:  Text("3.哪些电箱经常出现负载过高的情况？"),
          ),
          new Padding(
            padding: new EdgeInsets.fromLTRB(0, 0, 0, 20),
            child:  Text("4.哪些电箱如果出现问题，影响范围很大？"),
          ),
          new Padding(
            padding: new EdgeInsets.fromLTRB(0, 0, 0, 20),
            child:  Text("5.哪些电箱如果出现问题，将造成很大的财产损失？"),
          ),
          new Padding(
            padding: new EdgeInsets.fromLTRB(0, 0, 0, 20),
            child:  Text("6.是否有重要设备需要监测？"),
          ),


        ],
      ),
    );

    Widget bigContainer = Container(
      color: prefix0.LIGHT_LINE_COLOR,
      padding: new EdgeInsets.fromLTRB(0, 0, 0, 60),
      child: new ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: electricalItems.length,
          itemBuilder: (context, index) {
            return new Container(
              height: 200,
              color:  prefix0.LIGHT_LINE_COLOR,
              child: new StickWidget(
                ///header
                stickHeader: new Container(
                  height: 50.0,
                  color: prefix0.LIGHT_LINE_COLOR,
                  padding: new EdgeInsets.only(left: 20.0),
                  alignment: Alignment.centerLeft,
                  child: new InkWell(
                    onTap: () {
                      print("header");
                    },
                    child: new Text(
                      electricalItems[index],
                      style: TextStyle(color:prefix0.TITLE_TEXT_COLOR),
                    ),
                  ),
                ),

                ///content
                stickContent: new InkWell(
                  onTap: () {
                    print("content");
                  },
                  child: new Container(
                    padding: EdgeInsets.only(left: 20),
                    color: Colors.white,
                    height: 150,
                    child: new Center(
                      child: new Text(
                        '我的$index 内容 啊',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),

    );

    return Scaffold(

      appBar: NavBar,
      body: bigContainer,
      bottomSheet: bottomButton,
    );

  }


}


const electricalItems = [
  "1.电箱信息",
  "2.电箱照片",
  "3.安装环境",
  "4.运作环境",
  "5.设备预选",
];
