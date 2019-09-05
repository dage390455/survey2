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
import 'package:sensoro_survey/views/survey/editPage/edit_head_person_page.dart';
import 'package:sensoro_survey/views/survey/editPage/edit_head_person_phone_page.dart';
import 'package:sensoro_survey/views/survey/editPage/edit_name_page.dart';
import 'package:sensoro_survey/views/survey/editPage/edit_purpose_page.dart';
import 'package:sensoro_survey/views/survey/editPage/survey_point_area.dart';
import 'package:sensoro_survey/views/survey/editPage/survey_point_structure.dart';
import 'package:sensoro_survey/views/survey/survey_point_information.dart';

class SummaryConstructionPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SummaryConstructionPage> {
  BasicMessageChannel<String> _basicMessageChannel =
      BasicMessageChannel("BasicMessageChannelPlugin", StringCodec());

  ElectricalFireModel fireModel = DataTransferManager.shared.fireCreatModel;

  var isCheack = false;

  @override
  void initState() {
    updateNextButton();
    _basicMessageChannel.setMessageHandler((message) => Future<String>(() {
          print(message);
          //message为native传递的数据
          if(message!=null&&message.isNotEmpty){
            List list = message.split(",");
            if (list.length ==3){
              setState(() {
                fireModel.editLongitudeLatitude = list[0] + "," + list[1];
                fireModel.editPosition = list[2];
              });
            }

          }
          //给Android端的返回值
          return "========================收到Native消息：" + message;
        }));

    super.initState();
  }

  //向native发送消息
  void _sendToNative() {

    var location = "0," + fireModel.editLongitudeLatitude +","+ fireModel.editAddress;

    Future<String> future = _basicMessageChannel.send(location);
    future.then((message) {
      print("========================" + message);
    });


  }

  nextStep() async {
    final result = await Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => new SurvayElectricalFirePage()),
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
    Widget NavBar = AppBar(
      elevation: 1.0,
      centerTitle: true,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text(
        "勘察点信息",
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
          }
        },
      ),
    );

    editName() async {
      final result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new EditNamePage(
                  name: this.fireModel.editName,
                )),
      );

      if (result != null) {
        String name = result as String;

        this.fireModel.editName = name;
        updateNextButton();
        setState(() {});
      }
    }

    editPurpose() async {
      final result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new EditPurposePage(
                  name: this.fireModel.editPurpose,
                )),
      );

      if (result != null) {
        String name = result as String;

        this.fireModel.editPurpose = name;
        updateNextButton();
        setState(() {});
      }
    }

    editAddress() async {
      final result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new EditAdressPage(
                  name: this.fireModel.editAddress,
                )),
      );

      if (result != null) {
        String name = result as String;

        this.fireModel.editAddress = name;
        updateNextButton();
        setState(() {});
      }
    }

    editLoction() async {
//       final result = await Navigator.push(
//         context,
//         new MaterialPageRoute(builder: (context) => new EditLoctionPage(name: this.location,)),
//       );
//
//       if (result!=null){
//         String name = result as String;
//
//         this.location = name;
//         updateNextButton();
//         setState(() {
//
//         });
//       }
      _sendToNative();
    }

    editStructure() async {
      final result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new SurveyPointStructureEditPage(
                  name: this.fireModel.editPointStructure,
                )),
      );

      if (result != null) {
        String name = result as String;

        this.fireModel.editPointStructure = name;
        updateNextButton();
        setState(() {});
      }
    }

    editAre() async {
      final result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new SurveyPointAreaEditPage(
                  name: this.fireModel.editPointArea,
                )),
      );

      if (result != null) {
        String name = result as String;

        this.fireModel.editPointArea = name;
        updateNextButton();
        setState(() {});
      }
    }

    editheadName() async {
      final result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new EditHeadPersonPage(
                  name: this.fireModel.headPerson,
                )),
      );

      if (result != null) {
        String name = result as String;

        this.fireModel.headPerson = name;
        updateNextButton();
        setState(() {});
      }
    }

    editheadPhone() async {
      final result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new EditHeadPersonPhonePage(
                  name: this.fireModel.headPhone,
                )),
      );

      if (result != null) {
        String name = result as String;

        this.fireModel.headPhone = name;
        updateNextButton();
        setState(() {});
      }
    }

    editBossName() async {
      final result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new EditBossPersonPage(
                  name: this.fireModel.bossName,
                )),
      );

      if (result != null) {
        String name = result as String;

        this.fireModel.bossName = name;
        updateNextButton();
        setState(() {});
      }
    }

    editBossPhone() async {
      final result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new EditBossPersonPhonePage(
                  name: this.fireModel.bossPhone,
                )),
      );

      if (result != null) {
        String name = result as String;

        this.fireModel.bossPhone = name;
        updateNextButton();
        setState(() {});
      }
    }

    Widget container = Container(
      color: Colors.white,
      padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: editName, //写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("勘察点名称"),
                  Expanded(
                    child: Text(
                      this.fireModel.editName.length > 0
                          ? this.fireModel.editName
                          : "必填",
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Image.asset(
                    "assets/images/right_arrar.png",
                    width: 20,
                  )
                ],
              ),
            ),
          ),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
          GestureDetector(
            onTap: editPurpose, //写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("勘察点用途"),
                  Expanded(
                    child: Text(
                      this.fireModel.editPurpose.length > 0
                          ? this.fireModel.editPurpose
                          : "选填",
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Image.asset(
                    "assets/images/right_arrar.png",
                    width: 20,
                  )
                ],
              ),
            ),
          ),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
          GestureDetector(
            onTap: editAddress, //写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("具体地址"),
                  Expanded(
                    child: Text(
                      this.fireModel.editAddress.length > 0
                          ? this.fireModel.editAddress
                          : "选填",
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Image.asset(
                    "assets/images/right_arrar.png",
                    width: 20,
                  )
                ],
              ),
            ),
          ),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
          GestureDetector(
            onTap: editLoction, //写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("定位地址"),
                  Expanded(
                    child: Text(
                      this.fireModel.editPosition.length > 0
                          ? this.fireModel.editPosition
                          : "选填",
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Image.asset(
                    "assets/images/right_arrar.png",
                    width: 20,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );

    Widget container2 = Container(
      color: Colors.white,
      padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: editStructure, //写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("勘察点结构"),
                  Expanded(
                    child: Text(
                      this.fireModel.editPointStructure.length > 0
                          ? this.fireModel.editPointStructure
                          : "选填",
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Image.asset(
                    "assets/images/right_arrar.png",
                    width: 20,
                  )
                ],
              ),
            ),
          ),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
          GestureDetector(
            onTap: editAre, //写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("勘察点面积(㎡)"),
                  Expanded(
                    child: Text(
                      this.fireModel.editPointArea.length > 0
                          ? this.fireModel.editPointArea
                          : "选填",
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Image.asset(
                    "assets/images/right_arrar.png",
                    width: 20,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );

    Widget container3 = Container(
      color: Colors.white,
      padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: editheadName, //写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("现场负责人姓名"),
                  Expanded(
                    child: Text(
                      this.fireModel.headPerson.length > 0
                          ? this.fireModel.headPerson
                          : "必填",
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Image.asset(
                    "assets/images/right_arrar.png",
                    width: 20,
                  )
                ],
              ),
            ),
          ),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
          GestureDetector(
            onTap: editheadPhone, //写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("现场负责人电话"),
                  Expanded(
                    child: Text(
                      this.fireModel.headPhone.length > 0
                          ? this.fireModel.headPhone
                          : "必填",
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Image.asset(
                    "assets/images/right_arrar.png",
                    width: 20,
                  )
                ],
              ),
            ),
          ),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
          GestureDetector(
            onTap: editBossName, //写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("老板姓名"),
                  Expanded(
                    child: Text(
                      this.fireModel.bossName.length > 0
                          ? this.fireModel.bossName
                          : "选填",
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Image.asset(
                    "assets/images/right_arrar.png",
                    width: 20,
                  )
                ],
              ),
            ),
          ),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
          GestureDetector(
            onTap: editBossPhone, //写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("老板电话"),
                  Expanded(
                    child: Text(
                      this.fireModel.bossPhone.length > 0
                          ? this.fireModel.bossPhone
                          : "选填",
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Image.asset(
                    "assets/images/right_arrar.png",
                    width: 20,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );

    Widget bigContainer = Container(
      color: prefix0.LIGHT_LINE_COLOR,
      padding: new EdgeInsets.fromLTRB(0, 0, 0, 60),
      child: new ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: container,
          ),
          new Padding(
            padding: new EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: container2,
          ),
          new Padding(
            padding: new EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: container3,
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

  updateNextButton() {
    if (fireModel.editName.length > 0 &&
        fireModel.headPerson.length > 0 &&
        fireModel.headPhone.length > 0) {
      this.isCheack = true;
    } else {
      this.isCheack = false;
    }
  }
}
