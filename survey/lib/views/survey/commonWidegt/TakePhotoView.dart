import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sensoro_survey/views/survey/const.dart' as prefix0;



class TakePhotoView extends StatefulWidget {
  var hitText = "";
  var defineText = "";
  final searchAction;
  String searchStr = "";

  TakePhotoView({this.hitText, this.searchAction,this.defineText});

  @override
  _State createState() =>
      _State(hisoryKey: this.hitText, editParentText: searchAction);
}

class _State extends State<TakePhotoView> {
  var editParentText;
  var hisoryKey = "";
  List<String> tags = [];
  String imgPath = "";
  int editIndex = -1;
  _State({this.hisoryKey, this.editParentText});
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    searchController.text = widget.defineText;
  }



  @override
  Widget build(BuildContext context) {


    _takePhone(){
      showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: new Text('选择'),
            children: <Widget>[
              new SimpleDialogOption(
                child: new Text('拍照'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new SimpleDialogOption(
                child: new Text('相册'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      ).then((val) {
        print(val);
      });
    }


    Widget imageContainer = Container(
      color: Colors.white,
      padding: new EdgeInsets.fromLTRB(20, 0, 20, 10),
      height: 150,
      child: GestureDetector(
          onTap: () {
            _takePhone();
          },
          //写入方法名称就可以了，但是是无参的
          onTapUp: (_) {
            setState(() {
              editIndex = -1;
            });
          },
          onTapCancel: () {
            setState(() {
              editIndex = -1;
            });
          },
          onTapDown: (_) {
            setState(() {
              editIndex = 1;
            });
          },
          child: Stack(
            alignment: const Alignment(0, -1.0),
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.fromLTRB(0, 10, 20, 0),
                child: Container(
                  alignment: Alignment.center,
                  child:imgPath.length==0? Text("+照片"):Image.file(File(imgPath)),
                  decoration: new BoxDecoration(
                    border: new Border.all(
                        width: 1.0,
                        color: (editIndex != -1
                            ? Colors.green
                            : prefix0.LINE_COLOR)),
                    borderRadius:
                    new BorderRadius.all(new Radius.circular(5.0)),
                  ),
//                  width: 150,
//                  height: 320,
                ),
              ),
//              Row(
//                children: <Widget>[
                  new Offstage(
                      offstage: false ,
                      child: new IconButton(
                        icon: new Image.asset(
                            "assets/images/picture_del.png"),
                        tooltip: 'Increase volume by 10%',
                        onPressed: () {
                          setState(() {
//                            Map item = picImagesArray[index];
//                            item["picPath"] = "";
                          });
                        },
                      )),
//                ],
//              )
            ],
          ))
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
      child: imageContainer,
    );


    return imageContainer;
  }
}

