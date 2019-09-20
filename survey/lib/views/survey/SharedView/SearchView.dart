import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sensoro_survey/views/survey/const.dart' as prefix0;



class SearchView extends StatefulWidget {
  var hitText = "";
  final searchAction;
  String searchStr = "";
  TextEditingController searchController = TextEditingController();
  SearchView({this.hitText, this.searchAction});

  @override
  _State createState() =>
      _State(hisoryKey: this.hitText, editParentText: searchAction);
}

class _State extends State<SearchView> {
  var editParentText;
  var hisoryKey = "";
  List<String> tags = [];

  _State({this.hisoryKey, this.editParentText});

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    Widget bigContainer =TextField(
      //文本输入控件
      onSubmitted: (String str) {
        //提交监听
        // searchStr = val;
        // print('用户提变更');
      },
      onChanged: (val) {
        widget.searchStr = val;
        editParentText(widget.searchStr);
        setState(() {});
      },
      controller: widget.searchController,
      cursorWidth: 0,
      cursorColor: Colors.white,
      keyboardType: TextInputType.text,
      //设置输入框文本类型
      textAlign: TextAlign.left,
      //设置内容显示位置是否居中等
      style: new TextStyle(
        fontSize: 13.0,
        color: prefix0.BLACK_TEXT_COLOR,
      ),
      autofocus: false,
      //自动获取焦点
      decoration: new InputDecoration(
        border: InputBorder.none,
        hintText: hisoryKey,
        icon: new Container(
          padding: EdgeInsets.all(0.0),
          child: new Image(
            image: new AssetImage("assets/images/search.png"),
            width: 20,
            height: 20,
            // fit: BoxFit.fitWidth,
          ),
        ),

        suffixIcon: new IconButton(
            icon: Image.asset(
              "assets/images/close_black.png",
              // height: 20,
            ),

            onPressed: () {
              editParentText("");
              widget.searchController.text = "";
              widget.searchStr = "";


              setState(() {});
            }),

        contentPadding: EdgeInsets.fromLTRB(3.0, 20.0, 3.0, 10.0), //设置显示本的一个内边距
// //                border: InputBorder.none,//取默认的下划线边框
      ),
    );


    Widget search =  Container(
      height: 40,
      width: prefix0.screen_width,
      // color: prefix0.LIGHT_LINE_COLOR,
      decoration: BoxDecoration(
        color: prefix0.FENGE_LINE_COLOR,
        borderRadius: BorderRadius.circular(20.0),
      ),
      // height: 140, //高度不填会适应
      padding:
      const EdgeInsets.only(top: 0.0, bottom: 0, left: 20, right: 10),
      child: bigContainer,
    );


    return search;
  }
}

