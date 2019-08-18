

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

   @override
   Widget build(BuildContext context) {

     Widget NavBar = AppBar(
       elevation: 1.0,
       centerTitle:true,
       brightness: Brightness.light,
       backgroundColor: Colors.white,

       title: Text(
         "现场情况",
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
             Navigator.push(
               context,
               new MaterialPageRoute(builder: (context) => new  SummaryConstructionPage()),
             );
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

       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,

         children: <Widget>[

           container,

           new Row (

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

     return Scaffold(

       appBar: NavBar,
        body: bigContainer,
        bottomSheet: bottomButton,
     );

   }





 }
