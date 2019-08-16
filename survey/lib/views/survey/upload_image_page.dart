

//现场情况
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;

import 'Electric_box_information_page.dart';

 class UploadImagePage extends StatefulWidget {
   @override
   _State createState() => _State();
 }

 class _State extends State<UploadImagePage> {

   var isCheack = false;

   var imgPath;
   /*拍照*/
   takePhoto() async {
     var image = await ImagePicker.pickImage(source: ImageSource.camera);

     setState(() {
       imgPath = image;
     });
   }

   /*相册*/
   openGallery() async {
     var image = await ImagePicker.pickImage(source: ImageSource.gallery);
     setState(() {
       imgPath = image;
     });
   }

   @override
   Widget build(BuildContext context) {

     Widget NavBar = AppBar(
       elevation: 1.0,
       centerTitle:true,
       brightness: Brightness.light,
       backgroundColor: Colors.white,

       title: Text(
         "上传图片",
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
               new MaterialPageRoute(builder: (context) => new ElectricboxinformationPage()),
             );
           }
         },
       ),
     );




     Widget container = Container(
        color: prefix0.LIGHT_LINE_COLOR,
        padding:  new EdgeInsets.fromLTRB(20, 0, 20, 0),
        height: 150,
        child: new ListView(
//           mainAxisAlignment: MainAxisAlignment.start,
            scrollDirection:Axis.horizontal,
            children: <Widget>[

              GestureDetector(
                onTap: takePhoto,//写入方法名称就可以了，但是是无参的
                child: new Padding(
                  padding: new EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child:  Container(
                    alignment: Alignment.center,
                    child: imgPath == null ? Text('+总开关照片'):Image.file(imgPath),
                    decoration: new BoxDecoration(
                      border: new Border.all(width: 2.0, color: Colors.grey),

                      borderRadius: new BorderRadius.all(new Radius.circular(5.0)),

                    ),
                    width: 150,
                    height: 150,
                  ),
                ),
              ),




              new Padding(
                padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
                child:  Container(
                  alignment: Alignment.center,
                  child: imgPath == null ? Text('+分开关照片'):Image.file(imgPath),
                  decoration: new BoxDecoration(
                    border: new Border.all(width: 2.0, color: Colors.grey),

                    borderRadius: new BorderRadius.all(new Radius.circular(5.0)),

                  ),
                  width: 150,
                  height: 150,
                ),
              ),

              new Padding(
                padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
                child:  Container(
                  alignment: Alignment.center,
                  child: imgPath == null ? Text('+分开关照片'):Image.file(imgPath),
                  decoration: new BoxDecoration(
                    border: new Border.all(width: 2.0, color: Colors.grey),

                    borderRadius: new BorderRadius.all(new Radius.circular(5.0)),

                  ),
                  width: 150,
                  height: 150,
                ),
              ),


            ],
        ),
     );

     Widget container2 = Container(
       color: prefix0.LIGHT_LINE_COLOR,
       padding:  new EdgeInsets.fromLTRB(20, 0, 20, 0),
       height: 150,
       child: new ListView(
//           mainAxisAlignment: MainAxisAlignment.start,
         scrollDirection:Axis.horizontal,
         children: <Widget>[
           new Padding(
             padding: new EdgeInsets.fromLTRB(0, 0, 20, 0),
             child:  Container(
               alignment: Alignment.center,
               child: imgPath == null ? Text('+环境照片'):Image.file(imgPath),
               decoration: new BoxDecoration(
                 border: new Border.all(width: 2.0, color: Colors.grey),

                 borderRadius: new BorderRadius.all(new Radius.circular(5.0)),

               ),
               width: 150,
               height: 150,
             ),
           ),


           new Padding(
             padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
             child:  Container(
               alignment: Alignment.center,
               child: imgPath == null ? Text('+环境照片'):Image.file(imgPath),
               decoration: new BoxDecoration(
                 border: new Border.all(width: 2.0, color: Colors.grey),

                 borderRadius: new BorderRadius.all(new Radius.circular(5.0)),

               ),
               width: 150,
               height: 150,
             ),
           ),

           new Padding(
             padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
             child:  Container(
               alignment: Alignment.center,
               child: imgPath == null ? Text('+环境照片'):Image.file(imgPath),
               decoration: new BoxDecoration(
                 border: new Border.all(width: 2.0, color: Colors.grey),

                 borderRadius: new BorderRadius.all(new Radius.circular(5.0)),

               ),
               width: 150,
               height: 150,
             ),
           ),


         ],
       ),
     );

     Widget bigContainer = Container(
       color: prefix0.LIGHT_LINE_COLOR,

       child: new ListView(

         scrollDirection:Axis.vertical,
         children: <Widget>[

           new Padding(
             padding: new EdgeInsets.fromLTRB(20, 20, 0, 20),
             child:  Text("电箱照片"),
           ),

           new Column (

             mainAxisAlignment: MainAxisAlignment.start,
             children: <Widget>[



               container

             ],

           ),

           new Padding(
             padding: new EdgeInsets.fromLTRB(20, 10, 0, 20),
             child:  Text("至少拍摄2张清晰的电箱及开关照片，能看清空开上面的数字及信息。"),
           ),

           new Padding(
             padding: new EdgeInsets.fromLTRB(20, 20, 0, 20),
             child:  Text("环境照片"),
           ),

           new Column (

             mainAxisAlignment: MainAxisAlignment.start,
             children: <Widget>[



               container2

             ],

           ),

           new Padding(
             padding: new EdgeInsets.fromLTRB(20, 10, 0, 20),
             child:  Text("至少拍摄正面，左侧，右侧等不同方向3张照片，距离至少5m以上。"),
           ),


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
