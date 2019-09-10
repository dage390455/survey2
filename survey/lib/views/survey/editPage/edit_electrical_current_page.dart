//现场情况
import 'package:flutter/material.dart';
import 'package:sensoro_survey/views/survey/common/save_data_manager.dart';
import 'package:sensoro_survey/views/survey/common/history_page.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;

class EditElectricalCurrentPage extends StatefulWidget {
  var name = "";

  EditElectricalCurrentPage({this.name});
  @override
  _State createState() => _State(name: this.name);
}

class _State extends State<EditElectricalCurrentPage> {
  var historyKey = "histroyEditElectricalCurrentPagekey";
  var name = "";
  var isHighHistory = false;
  _State({this.name});
  FocusNode blankNode = FocusNode();
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
        "额定电流",
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
      padding: new EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: locationController,
            maxLines: 2,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,

//                  labelText: '备注',
              hintText: '请输入额定电流值。',
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
      child: ListView(
//        crossAxisAlignment: CrossAxisAlignment.start,
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
