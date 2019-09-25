import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sensoro_survey/views/survey/const.dart' as prefix0;

import '../../../pic_swiper.dart';

class TakePhotoView extends StatefulWidget {
  var defineText = "";
  final takePhoneImageAction;
  String searchStr = "";
  String imagePath = "";

  TakePhotoView({this.takePhoneImageAction, this.defineText,this.imagePath});

  @override
  _State createState() => _State();
}

class _State extends State<TakePhotoView> {
  List<String> tags = [];

  int editIndex = -1;
  BasicMessageChannel<String> _basicMessageChannel =
      BasicMessageChannel("BasicMessageChannelPluginPickImage", StringCodec());

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _basicMessageChannel.setMessageHandler((message) => Future<String>(() {
          print(message);
          //message为native传递的数据

          widget.imagePath = message;
          widget.takePhoneImageAction(widget.imagePath);
          setState(() {});
          //给Android端的返回值
          return "========================收到Native消息：" + message;
        }));

    super.initState();

    searchController.text = widget.defineText;
  }

  @override
  Widget build(BuildContext context) {
    //向native发送消息
    void _sendToNative(String string) {
      Future<String> future = _basicMessageChannel.send(string);
      future.then((message) {
        print("========================" + message);
      });

//    super.initState();
    }

    takePhoto1() async {
      _sendToNative("");
      var image = await ImagePicker.pickImage(source: ImageSource.camera);
      if (null != image) {
        widget.imagePath = image.uri.path.toString();
        widget.takePhoneImageAction(widget.imagePath);
        setState(() {});
      }
    }

    takePhoto2() async {
      _sendToNative("1");
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (null != image) {
        widget.imagePath = image.uri.path.toString();
        widget.takePhoneImageAction(widget.imagePath);
        setState(() {});
      }
    }

    openPhoto1() async {
      List<PicSwiperItem> list = new List();
      PicSwiperItem picSwiperItem = PicSwiperItem("");
      list.clear();
      picSwiperItem.picUrl = widget.imagePath;

      list.add(picSwiperItem);
      if (picSwiperItem.picUrl.isNotEmpty) {
        final result = await Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new PicSwiper(index: 0, pics: list)),
        );
      }
    }

   Widget _getImageWight(){
      if(widget.imagePath.startsWith("http")){
        return Image.network(widget.imagePath);
      }else{
        return Image.file(File(widget.imagePath));
      }
    }

    _takePhone() {
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
                  takePhoto1();
                },
              ),
              new SimpleDialogOption(
                child: new Text('相册'),
                onPressed: () {
                  Navigator.of(context).pop();
                  takePhoto2();
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
        padding: new EdgeInsets.fromLTRB(0, 0, 0, 0),
        height: 150,
        child: GestureDetector(
            onTap: () {
              if (widget.imagePath.length > 0) {
                openPhoto1();
              } else {
                _takePhone();
              }
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
              alignment: const Alignment(1.0, -1.1),
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Container(
                    alignment: Alignment.center,
                    child: widget.imagePath.length == 0
                        ? Text(widget.defineText)
                        : _getImageWight(),
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
                    offstage: widget.imagePath.length > 0 ? false : true,
                    child: new IconButton(
                      icon: new Image.asset("assets/images/picture_del.png"),
                      tooltip: 'Increase volume by 10%',
                      onPressed: () {
                        setState(() {
                          widget.imagePath = "";
                          widget.takePhoneImageAction(widget.imagePath);
                          setState(() {});
//                            Map item = picImagesArray[index];
//                            item["picPath"] = "";
                        });
                      },
                    )),
//                ],
//              )
              ],
            )));

    Widget search = Container(
      height: 40,
      width: prefix0.screen_width,
      // color: prefix0.LIGHT_LINE_COLOR,
      decoration: BoxDecoration(
        color: prefix0.FENGE_LINE_COLOR,
        borderRadius: BorderRadius.circular(20.0),
      ),
      // height: 140, //高度不填会适应
      padding: const EdgeInsets.only(top: 0.0, bottom: 0, left: 20, right: 10),
      child: imageContainer,
    );

    return imageContainer;
  }
}
