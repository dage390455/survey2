//现场情况
import 'package:flutter/material.dart';
import 'package:sensoro_survey/views/survey/comment/save_data_manager.dart';
import 'package:sensoro_survey/views/survey/comment/history_page.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;

class EditBossPersonPhonePage extends StatefulWidget {
  var name = "";

  EditBossPersonPhonePage({this.name});
  @override
  _State createState() => _State(name: this.name);
}

class _State extends State<EditBossPersonPhonePage> {
  var historyKey = "histroyBosspersonphoneKey";
  var name = "";
  var isHighHistory = true;
  _State({this.name});

  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    locationController.text = this.name;
    locationController.addListener(() {
      isHighHistory = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget NavBar = AppBar(
      elevation: 1.0,
      centerTitle: true,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text(
        "老板电话",
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
        color: this.name.length > 0 ? prefix0.GREEN_COLOR : Colors.grey,
        textColor: Colors.white,
        child: new Text('保存',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 20)),
        onPressed: () {
          if (this.name.length > 0) {
            SaveDataManger.addHistory(this.name, historyKey);
            Navigator.of(context).pop(this.name);
          }
        },
      ),
    );

    _editParentText(editText) {
      setState(() {
        this.name = editText;
        locationController.text = editText;
//        locationController.selection(TextSelection.fromPosition(TextPosition(
//            affinity: TextAffinity.downstream,
//            offset: this.name.length)));
//        locationController.selection(new TextSelection.fromPosition(new TextPosition()));
      });

      print(editText);
    }

    Widget container = Container(
      color: Colors.white,
      padding: new EdgeInsets.fromLTRB(20, 10, 0, 20),
      child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: locationController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              border: InputBorder.none,

//                  labelText: '备注',
              hintText: '请输入该勘察点责任主体负责人电话。',
            ),
            autofocus: false,
            onChanged: (val) {
              name = val;

              setState(() {});
            },
          ),
        ],
      ),
    );

    Widget backContainer = Container(
        color: Colors.white,
        padding: EdgeInsets.all(0),
//        height: 70,
        child: container);

    Widget bigContainer = Container(
      color: prefix0.LIGHT_LINE_COLOR,
      padding: new EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          backContainer,
          new Offstage(
            offstage: isHighHistory,
            child: HistoryPage(
                hisoryKey: historyKey,
                editParentText: (editText) => _editParentText(editText)),
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
