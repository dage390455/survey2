//现场情况
import 'package:flutter/material.dart';
import 'package:sensoro_survey/views/survey/common/save_data_manager.dart';
import 'package:sensoro_survey/views/survey/common/history_page.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;

class EditBossPersonPage extends StatefulWidget {
  var name = "";

  EditBossPersonPage({this.name});
  @override
  _State createState() => _State(name: this.name);
}

class _State extends State<EditBossPersonPage> {
  var historyKey = "histroyBosspersonKey";
  var name = "";
  FocusNode blankNode = FocusNode();
  var isHighHistory = false;
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
        "老板姓名",
        style: TextStyle(color: Colors.black),
      ),
      leading: Container(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            // 点击空白页面关闭键盘
            Navigator.pop(context);
          },
          child:   Text("取消",
            style: TextStyle(
                color: Colors.black
            ),

          ),
        ),

      ),
      actions: <Widget>[
        Container(
          padding:  new EdgeInsets.fromLTRB(0, 0, 20, 0),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              // 点击空白页面关闭键盘
              if (this.name.length > 0) {
                SaveDataManger.addHistory(this.name, historyKey);
                Navigator.of(context).pop(this.name);
              }
            },
            child:   Text("保存",
              style: TextStyle(
                color: this.name.length > 0 ? prefix0.GREEN_COLOR : Colors.grey,
              ),

            ),
          ),

        ),
      ],
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
      padding: new EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: locationController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: InputBorder.none,

//                  labelText: '备注',
              hintText: '请输入该勘察点责任主体负责人姓名',
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
        body: GestureDetector(
          onTap: () {
            // 点击空白页面关闭键盘
            FocusScope.of(context).requestFocus(blankNode);
          },
          child: bigContainer,
        ),
       );
  }
}
