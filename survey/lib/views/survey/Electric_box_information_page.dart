

//现场情况
import 'package:flutter/material.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/upload_image_page.dart';

 class ElectricboxinformationPage extends StatefulWidget {
   @override
   _State createState() => _State();
 }

 class _State extends State<ElectricboxinformationPage> {

   var location = "";
   var purpose = "";
   var remark = "";

   TextEditingController locationController = TextEditingController();
   //密码的控制器
   TextEditingController purposeController = TextEditingController();

   TextEditingController remarkController = TextEditingController();
   @override
   Widget build(BuildContext context) {

     Widget NavBar = AppBar(
       elevation: 1.0,
       centerTitle:true,
       brightness: Brightness.light,
       backgroundColor: Colors.white,

       title: Text(
         "电箱信息",
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
         color: this.location.length>0? prefix0.GREEN_COLOR :Colors.grey,
         textColor: Colors.white,
         child: new Text('下一步',
             style: TextStyle(
                 color: Colors.white,
                 fontWeight: FontWeight.normal,
                 fontSize: 20)),
         onPressed: () {
           if (this.location.length>0){
             Navigator.push(
               context,
               new MaterialPageRoute(builder: (context) => new UploadImagePage()),
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
              TextField(
                 controller: locationController,
                  keyboardType: TextInputType.text,
                     decoration: InputDecoration(

                      labelText: '电箱位置(必填)',

                    ),
                      autofocus: false,
                   onChanged: (val) {
                      location = val;
                      setState(() {

                       });
                    },
                  ),
              TextField(
                controller: purposeController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(

                  labelText: '电箱用途(选填)',

                ),
                autofocus: false,
                onChanged: (val) {
                  purpose = val;
                  setState(() {

                  });
                },
              ),

              new Padding(
                padding: new EdgeInsets.fromLTRB(0, 30, 0, 20),
                child:  Text("备注"),
              ),



              TextField(
                controller: remarkController,
                keyboardType: TextInputType.text,



                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.transparent)
                  ),
//                  labelText: '备注',
                  hintText: '例如电箱的危险/风险原因；负载压力；问题影响范围等',
                ),
                maxLines: 4,
                autofocus: false,
                onChanged: (val) {
                  remark = val;
                  setState(() {

                  });
                },
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
