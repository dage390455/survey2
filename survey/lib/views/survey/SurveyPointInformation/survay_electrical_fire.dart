

//现场情况
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensoro_survey/views/survey/SurveyPointInformation/stick_widget.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;






class SurvayElectricalFirePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SurvayElectricalFirePage> {

  var isCheack = false;
  var remark = "";
  var imgPath;
  var _groupValue=1;
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

  TextEditingController remarkController = TextEditingController();
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
        child: new Text('完成',
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
      color: Colors.white,
      padding:  new EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
//            onTap: editName,//写入方法名称就可以了，但是是无参的
            child: Container (
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("电箱位置"),
                  Expanded (
                    child: Text(
                      "必填",
                      textAlign: TextAlign.right,
                    ),
                  )
                  ,
                  Image.asset(
                    "assets/images/right_arrar.png",
                    width: 20,

                  )
                ],
              ) ,
            ),
          ),



          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),

          GestureDetector(
//            onTap: editPurpose,//写入方法名称就可以了，但是是无参的
            child: Container (

              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("电箱用途"),
                  Expanded (
                    child: Text(
                      "选填",
                      textAlign: TextAlign.right,
                    ),
                  )
                  ,
                  Image.asset(
                    "assets/images/right_arrar.png",
                    width: 20,

                  )
                ],
              ) ,
            ),
          ),


          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),


          GestureDetector(
//            onTap: editAddress,//写入方法名称就可以了，但是是无参的
            child:Container (

              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("备注"),

                ],
              ) ,
            ),
          ),


          TextField(
            controller: remarkController,
            keyboardType: TextInputType.text,



            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.transparent)
              ),
//                  labelText: '备注',
              hintText: '例如电箱的危险/风险原因；负载压力；问题影响范围等',
            ),
            maxLines: 5,
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

    Widget step1 =  Container(
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
              electricalItems[0],
              style: TextStyle(color:prefix0.TITLE_TEXT_COLOR),
            ),
          ),
        ),

        ///content
        stickContent: new InkWell(
          onTap: () {
            print("content");
          },
          child: container
        ),
      ),
    );





    Widget takepice1 = Container(
      color: Colors.white,
      padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
      height: 150,
      child: new ListView(
//           mainAxisAlignment: MainAxisAlignment.start,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          GestureDetector(
            onTap: takePhoto, //写入方法名称就可以了，但是是无参的
            child: new Padding(
              padding: new EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Container(
                alignment: Alignment.center,
                child: imgPath == null ? Text('+总开关照片') : Image.file(imgPath),
                decoration: new BoxDecoration(
                  border: new Border.all(width: 1.0, color: prefix0.LINE_COLOR),
                  borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                ),
                width: 150,
                height: 150,
              ),
            ),
          ),
          new Padding(
            padding: new EdgeInsets.fromLTRB(10, 0, 20, 0),
            child: Container(
              alignment: Alignment.center,
              child: imgPath == null ? Text('+分开关照片') : Image.file(imgPath),
              decoration: new BoxDecoration(
                border: new Border.all(width: 1.0, color: prefix0.LINE_COLOR),
                borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
              ),
              width: 150,
              height: 150,
            ),
          ),
          new Padding(
            padding: new EdgeInsets.fromLTRB(10, 0, 20, 0),
            child: Container(
              alignment: Alignment.center,
              child: imgPath == null ? Text('+分开关照片') : Image.file(imgPath),
              decoration: new BoxDecoration(
                border: new Border.all(width: 1.0, color: prefix0.LINE_COLOR),
                borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
              ),
              width: 150,
              height: 150,
            ),
          ),
        ],
      ),
    );

    Widget takepice2 = Container(
      color: Colors.white,
      padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
      height: 150,
      child: new ListView(
//           mainAxisAlignment: MainAxisAlignment.start,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: Container(
              alignment: Alignment.center,
              child: imgPath == null ? Text('+环境照片') : Image.file(imgPath),
              decoration: new BoxDecoration(
                border: new Border.all(width: 1.0, color: prefix0.LINE_COLOR),
                borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
              ),
              width: 150,
              height: 150,
            ),
          ),
          new Padding(
            padding: new EdgeInsets.fromLTRB(10, 0, 20, 0),
            child: Container(
              alignment: Alignment.center,
              child: imgPath == null ? Text('+环境照片') : Image.file(imgPath),
              decoration: new BoxDecoration(
                border: new Border.all(width: 1.0, color: prefix0.LINE_COLOR),
                borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
              ),
              width: 150,
              height: 150,
            ),
          ),
          new Padding(
            padding: new EdgeInsets.fromLTRB(10, 0, 20, 0),
            child: Container(
              alignment: Alignment.center,
              child: imgPath == null ? Text('+环境照片') : Image.file(imgPath),
              decoration: new BoxDecoration(
                border: new Border.all(width: 1.0, color: prefix0.LINE_COLOR),
                borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
              ),
              width: 150,
              height: 150,
            ),
          ),
        ],
      ),
    );
    void updateGroupValue(int e){
      setState(() {
        _groupValue= e;
      });
    }

    Widget takePhones = Container(
      color: Colors.white,
      child: Column(
//        scrollDirection: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          Row(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.fromLTRB(20, 20, 0, 20),
                child: Text(
                  "电箱照片",
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[takepice1],
          ),
          new Padding(
            padding: new EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Text("至少拍摄2张清晰的电箱及开关照片，能看清空开上面的数字及信息。"),
          ),

          Row(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.fromLTRB(20, 20, 0, 20),
                child: Text(
                  "环境照片",
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),


          new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[takepice2],
          ),
          new Padding(
            padding: new EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Text("至少拍摄正面，左侧，右侧等不同方向3张照片，距离至少5m以上。"),
          ),
        ],
      ),
    );



    Widget step2 =  Container(
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
              electricalItems[1],
              style: TextStyle(color:prefix0.TITLE_TEXT_COLOR),
            ),
          ),
        ),

        ///content
        stickContent: new InkWell(
            onTap: () {
              print("content");
            },
            child: takePhones
        ),
      ),
    );



    Widget installationEnvironment = Container(
      color: Colors.white,
      padding:  new EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
//            onTap: editName,//写入方法名称就可以了，但是是无参的
            child: Container (
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("配备外箱"),
                  new Radio(value: 1, groupValue: _groupValue, onChanged: (int e)=>updateGroupValue(e)),
                  Text("不需要\n(电箱空间足够)"),
                  new Radio(value: 2, groupValue: _groupValue, onChanged: (int e)=>updateGroupValue(e)),
                  Text("需要\n(电箱空间不够)"),

                ],
              ) ,
            ),
          ),



          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),

          GestureDetector(
//            onTap: editPurpose,//写入方法名称就可以了，但是是无参的
            child: Container (

              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("电箱位置"),
                  new Radio(value: 3, groupValue: _groupValue, onChanged: (int e)=>updateGroupValue(e)),
                  Text("户外"),
                  new Radio(value: 4, groupValue: _groupValue, onChanged: (int e)=>updateGroupValue(e)),
                  Text("户内"),
                ],
              ) ,
            ),
          ),


          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),

          GestureDetector(
//            onTap: editPurpose,//写入方法名称就可以了，但是是无参的
            child: Container (

              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("是否需要梯子"),

                  new Radio(value: 5, groupValue: _groupValue, onChanged: (int e)=>updateGroupValue(e)),
                  Text("不需要"),
                  new Radio(value: 6, groupValue: _groupValue, onChanged: (int e)=>updateGroupValue(e)),
                  Text("需要"),
//                  RadioListTile<String>(
//                    value: '不需要',
//                    title: Text('不需要'),
//                    groupValue: _groupValue,
//                    onChanged: (value){
//                      setState(() {
//                        _groupValue=value;
//                      });
//                    },
//                  ),
//
//                  RadioListTile<String>(
//                    value: '需要',
//                    title: Text('需要'),
//                    groupValue: _groupValue,
//                    onChanged: (value){
//                      setState(() {
//                        _groupValue=value;
//                      });
//                    },
//                  ),
                ],
              ) ,
            ),
          ),


          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),

          new Padding(
            padding: new EdgeInsets.fromLTRB(10, 20, 20, 0),
            child: Container(
              alignment: Alignment.center,
              child: imgPath == null ? Text('+外箱安装位置图片') : Image.file(imgPath),
              decoration: new BoxDecoration(
                border: new Border.all(width: 1.0, color: prefix0.LINE_COLOR),
                borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
              ),
              width: 150,
              height: 150,
            ),
          ),


          GestureDetector(
//            onTap: editAddress,//写入方法名称就可以了，但是是无参的
            child:Container (

              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("备注"),

                ],
              ) ,
            ),
          ),


          TextField(
            controller: remarkController,
            keyboardType: TextInputType.text,



            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.transparent)
              ),
//                  labelText: '备注',
              hintText: '箱子型号，有几个什么类型的设备需要放在外箱中',
            ),
            maxLines: 5,
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


    Widget step3 =  Container(
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
              electricalItems[2],
              style: TextStyle(color:prefix0.TITLE_TEXT_COLOR),
            ),
          ),
        ),

        ///content
        stickContent: new InkWell(
            onTap: () {
              print("content");
            },
            child: installationEnvironment,
        ),
      ),
    );


    Widget perationEnvironment = Container(
      color: Colors.white,
      padding:  new EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
//            onTap: editName,//写入方法名称就可以了，但是是无参的
            child: Container (
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("报警音可否有效传播"),
                  new Radio(value: 7, groupValue: _groupValue, onChanged: (int e)=>updateGroupValue(e)),
                  Text("是"),
                  new Radio(value: 8, groupValue: _groupValue, onChanged: (int e)=>updateGroupValue(e)),
                  Text("否"),

                ],
              ) ,
            ),
          ),



          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),

          GestureDetector(
//            onTap: editPurpose,//写入方法名称就可以了，但是是无参的
            child: Container (

              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("报警是否扰民"),
                  new Radio(value: 9, groupValue: _groupValue, onChanged: (int e)=>updateGroupValue(e)),
                  Text("是"),
                  new Radio(value: 10, groupValue: _groupValue, onChanged: (int e)=>updateGroupValue(e)),
                  Text("否"),
                ],
              ) ,
            ),
          ),


          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),

          GestureDetector(
//            onTap: editPurpose,//写入方法名称就可以了，但是是无参的
            child: Container (

              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("是否有专人消音"),

                  new Radio(value: 11, groupValue: _groupValue, onChanged: (int e)=>updateGroupValue(e)),
                  Text("是"),
                  new Radio(value: 12, groupValue: _groupValue, onChanged: (int e)=>updateGroupValue(e)),
                  Text("否"),
//                  RadioListTile<String>(
//                    value: '不需要',
//                    title: Text('不需要'),
//                    groupValue: _groupValue,
//                    onChanged: (value){
//                      setState(() {
//                        _groupValue=value;
//                      });
//                    },
//                  ),
//
//                  RadioListTile<String>(
//                    value: '需要',
//                    title: Text('需要'),
//                    groupValue: _groupValue,
//                    onChanged: (value){
//                      setState(() {
//                        _groupValue=value;
//                      });
//                    },
//                  ),
                ],
              ) ,
            ),
          ),


          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),


          GestureDetector(
//            onTap: editAddress,//写入方法名称就可以了，但是是无参的
            child:Container (

              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("备注"),

                ],
              ) ,
            ),
          ),


          TextField(
            controller: remarkController,
            keyboardType: TextInputType.text,



            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.transparent)
              ),
//                  labelText: '备注',
              hintText: '其他环境影响备注',
            ),
            maxLines: 5,
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


    Widget step4 =  Container(
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
              electricalItems[3],
              style: TextStyle(color:prefix0.TITLE_TEXT_COLOR),
            ),
          ),
        ),

        ///content
        stickContent: new InkWell(
          onTap: () {
            print("content");
          },
          child: perationEnvironment,
        ),
      ),
    );


    Widget step5 =  Container(
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
              electricalItems[4],
              style: TextStyle(color:prefix0.TITLE_TEXT_COLOR),
            ),
          ),
        ),

        ///content
        stickContent: new InkWell(
          onTap: () {
            print("content");
          },
          child: perationEnvironment,
        ),
      ),
    );


    Widget bigContainer = Container(
      color: prefix0.LIGHT_LINE_COLOR,
      padding: new EdgeInsets.fromLTRB(0, 0, 0, 60),
      child: new ListView(
        scrollDirection:Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          step1,
          step2,
          step3,
          step4,
          step5,
        ],
      )
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
