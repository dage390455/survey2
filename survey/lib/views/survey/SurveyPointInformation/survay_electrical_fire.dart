//现场情况
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensoro_survey/model/electical_fire_create_model.dart';
import 'package:sensoro_survey/model/electrical_fire_model.dart';
import 'package:sensoro_survey/views/survey/SurveyPointInformation/stick_widget.dart';
import 'package:sensoro_survey/views/survey/comment/data_transfer_manager.dart';
import 'package:sensoro_survey/views/survey/comment/save_data_manager.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/editPage/edit_electrical_address_page.dart';
import 'package:sensoro_survey/views/survey/editPage/edit_electrical_current_page.dart';
import 'package:sensoro_survey/views/survey/editPage/edit_electrical_dangerous_page.dart';
import 'package:sensoro_survey/views/survey/editPage/edit_electrical_purpose_page.dart';

class SurvayElectricalFirePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SurvayElectricalFirePage> {
  BasicMessageChannel<String> _basicMessageChannel =
      BasicMessageChannel("BasicMessageChannelPluginPickImage", StringCodec());

  static PageController _pageController = new PageController();

  ElectricalFireModel fireCreatModel =
      DataTransferManager.shared.fireCreatModel;
  var isCheack = false;

//  var remark = "";
  var imgPath;
  var _groupValue = 0;
  int picImageIndex = 0;
  int editIndex = -1;

  var hisoryKey = "isNeedPresent";

  var currentValue = 1;
  TextEditingController step1remarkController = TextEditingController();
  TextEditingController step3remarkController = TextEditingController();
  TextEditingController step4remarkController = TextEditingController();

  @override
  void initState() {
    _basicMessageChannel.setMessageHandler((message) => Future<String>(() {
          print(message);
          //message为native传递的数据
          _resentpics(message);
          //给Android端的返回值
          return "========================收到Native消息：" + message;
        }));

    _getIsNeedShowPresent();
    step1remarkController.text = fireCreatModel.step1Remak;
    step3remarkController.text = fireCreatModel.step3Remak;
    step4remarkController.text = fireCreatModel.step4Remak;
    updateNextButton();
    super.initState();
  }

  _getIsNeedShowPresent() async {
    List tags = await SaveDataManger.getHistory(hisoryKey);

    if (tags.length > 0) {
      String isNeedDate = tags[0];

      DateTime date = DateTime.parse(isNeedDate);
      var difference = date.difference(DateTime.now());

      if (difference.inDays >= 1) {
        _groupValue = 0;
      } else {
        _groupValue = 1;
      }
    } else {
      _groupValue = 0;
    }
  }

  _resentpics(String urlString) {
    if (urlString.isNotEmpty) {
      setState(() {
        switch (picImageIndex) {
          case 0:
            fireCreatModel.editpic1 = urlString;
            break;
          case 1:
            fireCreatModel.editpic2 = urlString;
            break;
          case 2:
            fireCreatModel.editpic3 = urlString;
            break;
          case 3:
            fireCreatModel.editpic4 = urlString;
            break;
          case 4:
            fireCreatModel.editpic5 = urlString;
            break;
          case 5:
            fireCreatModel.editenvironmentpic1 = urlString;
            break;
          case 6:
            fireCreatModel.editenvironmentpic2 = urlString;
            break;
          case 7:
            fireCreatModel.editenvironmentpic3 = urlString;
            break;
          case 8:
            fireCreatModel.editenvironmentpic4 = urlString;
            break;
          case 9:
            fireCreatModel.editenvironmentpic5 = urlString;
            break;
          case 10:
            fireCreatModel.editOutsinPic = urlString;
            break;
        }
      });
    }
  }

  //向native发送消息
  void _sendToNative() {
    Future<String> future = _basicMessageChannel.send("");
    future.then((message) {
      print("========================" + message);
    });

//    super.initState();
  }

  editAddress() async {
    final result = await Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => new EditElectricalAdressPage(
                name: this.fireCreatModel.page2editAddress,
              )),
    );

    if (result != null) {
      String name = result as String;

      this.fireCreatModel.page2editAddress = name;
      updateNextButton();
      setState(() {});
    }
  }

  editDangerous() async {
    final result = await Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => new EditElectricalDangerousPage(
                name: this.fireCreatModel.dangerous,
              )),
    );

    if (result != null) {
      String name = result as String;

      this.fireCreatModel.dangerous = name;
      updateNextButton();
      setState(() {});
    }
  }

  editCurrent() async {
    final result = await Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => new EditElectricalCurrentPage(
                name: this.fireCreatModel.current,
              )),
    );

    if (result != null) {
      String name = result as String;

      this.fireCreatModel.current = name;
      updateNextButton();
      setState(() {});
    }
  }

  editPurpose() async {
    final result = await Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => new EditElectricalPurposePage(
                name: this.fireCreatModel.page2editPurpose,
              )),
    );

    if (result != null) {
      String name = result as String;

      this.fireCreatModel.page2editPurpose = name;
      updateNextButton();
      setState(() {});
    }
  }

  updateNextButton() {
    if (fireCreatModel.page2editAddress.length > 0 &&
        fireCreatModel.editpic1.length > 0 &&
        fireCreatModel.editpic2.length > 0 &&
        fireCreatModel.editenvironmentpic1.length > 0 &&
        fireCreatModel.current.length > 0) {
      setState(() {
        isCheack = true;
      });
    }
  }

  showPicDialog() {
    if (_groupValue == 1) {
      openGallery();
    } else {
//        showPicDialog2();
      showPicDialognew();
    }
  }

  showPicDialognew() {
    showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: new Text(
              '电箱环境拍照示例',
              textAlign: TextAlign.center,
            ),
            content:
                new StatefulBuilder(builder: (context, StateSetter setState) {
              return Container(
                  height: 380,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: new EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: new Text("需看到电箱四周墙面情况及离地高度"),
                      ),
                      Image.asset(
                        "assets/images/take_photo_prompt.png",
                        width: 150,
                        height: 150,
                      ),
                      Padding(
                        padding: new EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: new Row(
                          children: <Widget>[
                            Radio(
                                value: 1,
                                groupValue: _groupValue,
                                onChanged: (int e) {
                                  setState(() {
                                    if (_groupValue == 1) {
                                      _groupValue = 0;
                                    } else {
                                      _groupValue = 1;
                                    }
                                  });
                                }),
                            Text("今日不再提示"),
                          ],
                        ),
                      ),
                      new SimpleDialogOption(
                        child: Padding(
                          padding: new EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: GestureDetector(
                            onTap: null, //写入方法名称就可以了，但是是无参的
                            child: Container(
                                color: prefix0.TITLE_TEXT_COLOR,
                                alignment: Alignment.center,
                                height: 50,
                                child: new Text(
                                  "拍照",
                                  style: new TextStyle(color: Colors.white),
                                )),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (_groupValue == 1) {
                            SaveDataManger.saveHistory(
                                [DateTime.now().toString()], hisoryKey);
                          }
                          openGallery();
                        },
                      ),
                    ],
                  ));
            }),
          );
        });
  }

  /*拍照*/
  takePhoto1() async {
    picImageIndex = 0;

    openGallery();
  }

  /*拍照*/
  takePhoto2() async {
    picImageIndex = 1;
    openGallery();
  }

  /*拍照*/
  takePhoto3() async {
    picImageIndex = 2;
    openGallery();
  }

  /*拍照*/
  takePhoto4() async {
    picImageIndex = 3;
    openGallery();
  }

  /*拍照*/
  takePhoto5() async {
    picImageIndex = 4;
    openGallery();
  }

  /*拍照*/
  takePhoto6() async {
    picImageIndex = 5;
    showPicDialog();
  }

  /*拍照*/
  takePhoto7() async {
    picImageIndex = 6;
    showPicDialog();
  }

  /*拍照*/
  takePhoto8() async {
    picImageIndex = 7;
    showPicDialog();
  }

  /*拍照*/
  takePhoto9() async {
    picImageIndex = 8;
    showPicDialog();
  }

  /*拍照*/
  takePhoto10() async {
    picImageIndex = 9;
    showPicDialog();
  }

  /*拍照*/
  takePhoto11() async {
    picImageIndex = 10;
    openGallery();
  }

  Widget buildButton(
    String text,
    Function onPressed, {
    Color color = Colors.white,
  }) {
    return FlatButton(
      color: prefix0.TITLE_TEXT_COLOR,
      child: Text(text),
      onPressed: onPressed,
    );
  }

  /*相册*/
  openGallery() async {
//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//    setState(() {
//      imgPath = image;
//    });
    _sendToNative();
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if(null!=image){

      _resentpics(image.uri.path.toString());

//    setState(() {
//
//      imgPath = image;
//    });
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
        "电器火灾安装点勘察",
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
        child: new Text('完成',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 20)),
        onPressed: () {
          if (this.isCheack) {
            if (DataTransferManager.shared.isEditModel) {
              for (int i = 0;
                  i < DataTransferManager.shared.project.subList.length;
                  i++) {
                Map map = DataTransferManager.shared.project.subList[i];

                ElectricalFireModel model = ElectricalFireModel.fromJson(map);
                if (model.electricalFireId ==
                    DataTransferManager
                        .shared.fireCreatModel.electricalFireId) {
                  DataTransferManager.shared.project.subList.remove(map);
                  break;
                }
              }
              DataTransferManager.shared.project.subList
                  .add(DataTransferManager.shared.fireCreatModel.toJson());
            } else {
              DataTransferManager.shared.project.subList
                  .add(DataTransferManager.shared.fireCreatModel.toJson());
            }

            DataTransferManager.shared.saveProject();

            Navigator.of(context).pop("1");
          }
        },
      ),
    );

    Widget container = Container(
      color: Colors.white,
      padding: new EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: editAddress, //写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("电箱位置"),
                  Expanded(
                    child: Text(
                      fireCreatModel.page2editAddress.length > 0
                          ? fireCreatModel.page2editAddress
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
                  Text("电箱用途"),
                  Expanded(
                    child: Text(
                      fireCreatModel.page2editPurpose.length > 0
                          ? fireCreatModel.page2editPurpose
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
//            onTap: editAddress,//写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("备注"),
                ],
              ),
            ),
          ),
          TextField(
            controller: step1remarkController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.transparent)),
//                  labelText: '备注',
              hintText: '例如电箱的危险/风险原因；负载压力；问题影响范围等',
            ),
            maxLines: 5,
            autofocus: false,
            onChanged: (val) {
              fireCreatModel.step1Remak = val;
              setState(() {});
            },
          ),
        ],
      ),
    );

    Widget step1 = Container(
        color: prefix0.LIGHT_LINE_COLOR,
        child: new Column(
          children: <Widget>[
            new Row(children: <Widget>[
              Padding(
                child: new Text(
                  electricalItems[0],
                  style: TextStyle(color: prefix0.TITLE_TEXT_COLOR),
                ),
                padding: new EdgeInsets.fromLTRB(20, 20, 20, 20),
              )
            ]),
            container,
          ],
        ));

    Widget takepice1 = Container(
      color: Colors.white,
      padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
      height: 150,
      child: new ListView(
//           mainAxisAlignment: MainAxisAlignment.start,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          GestureDetector(
              onTap: takePhoto1,
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
                alignment: const Alignment(0.9, -1.1),
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0, 10, 20, 0),
                    child: Container(
                      alignment: Alignment.center,
                      child: fireCreatModel.editpic1.length == 0
                          ? Text('       上传\n电箱整体照片')
                          : Image.file(File(fireCreatModel.editpic1)),
                      decoration: new BoxDecoration(
                        border: new Border.all(
                            width: 1.0,
                            color: (editIndex == 1
                                ? Colors.green
                                : prefix0.LINE_COLOR)),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(5.0)),
                      ),
                      width: 150,
                      height: 150,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      new Offstage(
                          offstage: (fireCreatModel.editpic1.length > 0)
                              ? false
                              : true,
                          child: new IconButton(
                            icon: new Image.asset(
                                "assets/images/picture_del.png"),
                            tooltip: 'Increase volume by 10%',
                            onPressed: () {
                              setState(() {
                                fireCreatModel.editpic1 = "";
                              });
                            },
                          )),
                    ],
                  )
                ],
              )),
          GestureDetector(
            onTap: takePhoto2,
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
                editIndex = 2;
              });
            },
            child: Stack(
              alignment: const Alignment(0.9, -1.1),
              children: <Widget>[
                new Padding(
                    padding: new EdgeInsets.fromLTRB(0, 10, 20, 0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          child: fireCreatModel.editpic2.length == 0
                              ? Text('     上传\n总开关照片')
                              : Image.file(File(fireCreatModel.editpic2)),
                          decoration: new BoxDecoration(
                            border: new Border.all(
                                width: 1.0,
                                color: (editIndex == 2
                                    ? Colors.green
                                    : prefix0.LINE_COLOR)),
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(5.0)),
                          ),
                          width: 150,
                          height: 150,
                        ),
                      ],
                    )),
                Row(
                  children: <Widget>[
                    new Offstage(
                        offstage:
                            (fireCreatModel.editpic2.length > 0) ? false : true,
                        child: new IconButton(
                          icon:
                              new Image.asset("assets/images/picture_del.png"),
                          tooltip: 'Increase volume by 10%',
                          onPressed: () {
                            setState(() {
                              fireCreatModel.editpic2 = "";
                            });
                          },
                        )),
                  ],
                )
              ],
            ),
          ),
          GestureDetector(
              onTap: takePhoto3,
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
                  editIndex = 3;
                });
              },
              child: Stack(
                alignment: const Alignment(0.9, -1.1),
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0, 10, 20, 0),
                    child: Container(
                      alignment: Alignment.center,
                      child: fireCreatModel.editpic3.length == 0
                          ? Text('+')
                          : Image.file(File(fireCreatModel.editpic3)),
                      decoration: new BoxDecoration(
                        border: new Border.all(
                            width: 1.0,
                            color: (editIndex == 3
                                ? Colors.green
                                : prefix0.LINE_COLOR)),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(5.0)),
                      ),
                      width: 150,
                      height: 150,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      new Offstage(
                          offstage: (fireCreatModel.editpic3.length > 0)
                              ? false
                              : true,
                          child: new IconButton(
                            icon: new Image.asset(
                                "assets/images/picture_del.png"),
                            tooltip: 'Increase volume by 10%',
                            onPressed: () {
                              setState(() {
                                fireCreatModel.editpic3 = "";
                              });
                            },
                          )),
                    ],
                  )
                ],
              )),
          GestureDetector(
              onTap: takePhoto4,
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
                  editIndex = 4;
                });
              },
              child: Stack(
                alignment: const Alignment(0.9, -1.1),
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(10, 10, 20, 0),
                    child: Container(
                      alignment: Alignment.center,
                      child: fireCreatModel.editpic4.length == 0
                          ? Text('+')
                          : Image.file(File(fireCreatModel.editpic4)),
                      decoration: new BoxDecoration(
                        border: new Border.all(
                            width: 1.0,
                            color: (editIndex == 4
                                ? Colors.green
                                : prefix0.LINE_COLOR)),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(5.0)),
                      ),
                      width: 150,
                      height: 150,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      new Offstage(
                          offstage: (fireCreatModel.editpic4.length > 0)
                              ? false
                              : true,
                          child: new IconButton(
                            icon: new Image.asset(
                                "assets/images/picture_del.png"),
                            tooltip: 'Increase volume by 10%',
                            onPressed: () {
                              setState(() {
                                fireCreatModel.editpic4 = "";
                              });
                            },
                          )),
                    ],
                  )
                ],
              )),
          GestureDetector(
              onTap: takePhoto5,
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
                  editIndex = 5;
                });
              },
              child: Stack(
                alignment: const Alignment(0.9, -1.1),
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(10, 10, 20, 0),
                    child: Container(
                      alignment: Alignment.center,
                      child: fireCreatModel.editpic5.length == 0
                          ? Text('+')
                          : Image.file(File(fireCreatModel.editpic5)),
                      decoration: new BoxDecoration(
                        border: new Border.all(
                            width: 1.0,
                            color: (editIndex == 5
                                ? Colors.green
                                : prefix0.LINE_COLOR)),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(5.0)),
                      ),
                      width: 150,
                      height: 150,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      new Offstage(
                          offstage: (fireCreatModel.editpic5.length > 0)
                              ? false
                              : true,
                          child: new IconButton(
                            icon: new Image.asset(
                                "assets/images/picture_del.png"),
                            tooltip: 'Increase volume by 10%',
                            onPressed: () {
                              setState(() {
                                fireCreatModel.editpic5 = "";
                              });
                            },
                          )),
                    ],
                  )
                ],
              )),
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
          GestureDetector(
              onTap: takePhoto6,
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
                  editIndex = 6;
                });
              },
              child: Stack(
                alignment: const Alignment(0.9, -1.1),
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0, 10, 20, 0),
                    child: Container(
                      alignment: Alignment.center,
                      child: fireCreatModel.editenvironmentpic1.length == 0
                          ? Text('   上传\n环境照片')
                          : Image.file(
                              File(fireCreatModel.editenvironmentpic1)),
                      decoration: new BoxDecoration(
                        border: new Border.all(
                            width: 1.0,
                            color: (editIndex == 6
                                ? Colors.green
                                : prefix0.LINE_COLOR)),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(5.0)),
                      ),
                      width: 150,
                      height: 150,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      new Offstage(
                          offstage:
                              (fireCreatModel.editenvironmentpic1.length > 0)
                                  ? false
                                  : true,
                          child: new IconButton(
                            icon: new Image.asset(
                                "assets/images/picture_del.png"),
                            tooltip: 'Increase volume by 10%',
                            onPressed: () {
                              setState(() {
                                fireCreatModel.editenvironmentpic1 = "";
                              });
                            },
                          )),
                    ],
                  )
                ],
              )),
          GestureDetector(
              onTap: takePhoto7,
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
                  editIndex = 7;
                });
              },
              child: Stack(
                alignment: const Alignment(0.9, -1.1),
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0, 10, 20, 0),
                    child: Container(
                      alignment: Alignment.center,
                      child: fireCreatModel.editenvironmentpic2.length == 0
                          ? Text('+')
                          : Image.file(
                              File(fireCreatModel.editenvironmentpic2)),
                      decoration: new BoxDecoration(
                        border: new Border.all(
                            width: 1.0,
                            color: (editIndex == 7
                                ? Colors.green
                                : prefix0.LINE_COLOR)),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(5.0)),
                      ),
                      width: 150,
                      height: 150,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      new Offstage(
                          offstage:
                              (fireCreatModel.editenvironmentpic2.length > 0)
                                  ? false
                                  : true,
                          child: new IconButton(
                            icon: new Image.asset(
                                "assets/images/picture_del.png"),
                            tooltip: 'Increase volume by 10%',
                            onPressed: () {
                              setState(() {
                                fireCreatModel.editenvironmentpic2 = "";
                              });
                            },
                          )),
                    ],
                  )
                ],
              )),
          GestureDetector(
              onTap: takePhoto8,
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
                  editIndex = 8;
                });
              },
              child: Stack(
                alignment: const Alignment(0.9, -1.1),
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0, 10, 20, 0),
                    child: Container(
                      alignment: Alignment.center,
                      child: fireCreatModel.editenvironmentpic3.length == 0
                          ? Text('+')
                          : Image.file(
                              File(fireCreatModel.editenvironmentpic3)),
                      decoration: new BoxDecoration(
                        border: new Border.all(
                            width: 1.0,
                            color: (editIndex == 8
                                ? Colors.green
                                : prefix0.LINE_COLOR)),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(5.0)),
                      ),
                      width: 150,
                      height: 150,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      new Offstage(
                          offstage:
                              (fireCreatModel.editenvironmentpic3.length > 0)
                                  ? false
                                  : true,
                          child: new IconButton(
                            icon: new Image.asset(
                                "assets/images/picture_del.png"),
                            tooltip: 'Increase volume by 10%',
                            onPressed: () {
                              setState(() {
                                fireCreatModel.editenvironmentpic3 = "";
                              });
                            },
                          )),
                    ],
                  )
                ],
              )),
          GestureDetector(
              onTap: takePhoto9,
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
                  editIndex = 9;
                });
              },
              child: Stack(
                alignment: const Alignment(0.9, -1.1),
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0, 10, 20, 0),
                    child: Container(
                      alignment: Alignment.center,
                      child: fireCreatModel.editenvironmentpic4.length == 0
                          ? Text('+')
                          : Image.file(
                              File(fireCreatModel.editenvironmentpic4)),
                      decoration: new BoxDecoration(
                        border: new Border.all(
                            width: 1.0,
                            color: (editIndex == 9
                                ? Colors.green
                                : prefix0.LINE_COLOR)),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(5.0)),
                      ),
                      width: 150,
                      height: 150,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      new Offstage(
                          offstage:
                              (fireCreatModel.editenvironmentpic4.length > 0)
                                  ? false
                                  : true,
                          child: new IconButton(
                            icon: new Image.asset(
                                "assets/images/picture_del.png"),
                            tooltip: 'Increase volume by 10%',
                            onPressed: () {
                              setState(() {
                                fireCreatModel.editenvironmentpic4 = "";
                              });
                            },
                          )),
                    ],
                  )
                ],
              )),
          GestureDetector(
              onTap: takePhoto10,
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
                  editIndex = 10;
                });
              },
              child: Stack(
                alignment: const Alignment(0.9, -1.1),
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0, 10, 20, 0),
                    child: Container(
                      alignment: Alignment.center,
                      child: fireCreatModel.editenvironmentpic5.length == 0
                          ? Text('+')
                          : Image.file(
                              File(fireCreatModel.editenvironmentpic5)),
                      decoration: new BoxDecoration(
                        border: new Border.all(
                            width: 1.0,
                            color: (editIndex == 10
                                ? Colors.green
                                : prefix0.LINE_COLOR)),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(5.0)),
                      ),
                      width: 150,
                      height: 150,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      new Offstage(
                          offstage:
                              (fireCreatModel.editenvironmentpic5.length > 0)
                                  ? false
                                  : true,
                          child: new IconButton(
                            icon: new Image.asset(
                                "assets/images/picture_del.png"),
                            tooltip: 'Increase volume by 10%',
                            onPressed: () {
                              setState(() {
                                fireCreatModel.editenvironmentpic5 = "";
                              });
                            },
                          )),
                    ],
                  )
                ],
              )),
        ],
      ),
    );

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
            child: Text("至少拍摄2张清晰的电箱及空开照片，能看清空开上的数字及信息。"),
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
            padding: new EdgeInsets.fromLTRB(20, 10, 20, 100),
            child: Text("至少拍摄1张环境照片，可以清楚的看到电箱周围的墙面情况和离地高度。"),
          ),
        ],
      ),
    );

    ScrollController _controller2 = TrackingScrollController();

    bool dataNotification(ScrollNotification notification) {

      if (Platform.isIOS) {
        double height = notification.metrics.maxScrollExtent; //step2的高度
        height = height + 80;
        if (notification.metrics.extentBefore > height) {
          //下滑到最底部
          _pageController.animateToPage(2,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        } //滑动到最顶部
        if (notification.metrics.extentAfter > height) {
          _pageController.animateToPage(0,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        }
      } else if (Platform.isAndroid) {
        //android相关代码
        if (notification is ScrollEndNotification) {
          if (notification.metrics.extentAfter == 0) {
            //下滑到最底部
            _pageController.animateToPage(2,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
          } //滑动到最顶部
          if (notification.metrics.extentBefore == 0) {
            _pageController.animateToPage(0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
          }
        }

      }
      return true;
    }

    Widget step2 = Container(
        color: prefix0.LIGHT_LINE_COLOR,
        padding: new EdgeInsets.fromLTRB(0, 0, 0, 60),
        child: new NotificationListener(
            onNotification: dataNotification,
            child: new ListView(
//          physics: NeverScrollableScrollPhysics(),
//          shrinkWrap: true,

              controller: _controller2,
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    new Row(children: <Widget>[
                      Padding(
                        child: new Text(
                          electricalItems[1],
                          style: TextStyle(color: prefix0.TITLE_TEXT_COLOR),
                        ),
                        padding: new EdgeInsets.fromLTRB(20, 20, 20, 20),
                      )
                    ]),
                    takePhones,
                  ],
                )
              ],
            )));

    Widget installationEnvironment = Container(
      color: Colors.white,
      padding: new EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
//            onTap: editName,//写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("配备外箱"),
                  Expanded(
                    child: new Radio(
                        value: 0,
                        groupValue: fireCreatModel.isNeedCarton,
                        onChanged: (int e) {
                          setState(() {
                            fireCreatModel.isNeedCarton = e;
                          });
                        }),
                  ),
                  Text("不需要\n(电箱空间足够)"),
                  Expanded(
                    child: new Radio(
                        value: 1,
                        groupValue: fireCreatModel.isNeedCarton,
                        onChanged: (int e) {
                          setState(() {
                            fireCreatModel.isNeedCarton = e;
                          });
                        }),
                  ),
                  Text("需要\n(电箱空间不够)"),
                ],
              ),
            ),
          ),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
          GestureDetector(
//            onTap: editPurpose,//写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("电箱位置"),
                  new Radio(
                      value: 1,
                      groupValue: fireCreatModel.isOutSide,
                      onChanged: (int e) {
                        setState(() {
                          fireCreatModel.isOutSide = e;
                        });
                      }),
                  Text("户外"),
                  new Radio(
                      value: 0,
                      groupValue: fireCreatModel.isOutSide,
                      onChanged: (int e) {
                        setState(() {
                          fireCreatModel.isOutSide = e;
                        });
                      }),
                  Text("户内"),
                ],
              ),
            ),
          ),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
          GestureDetector(
//            onTap: editPurpose,//写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("是否需要梯子"),
                  new Radio(
                      value: 0,
                      groupValue: fireCreatModel.isNeedLadder,
                      onChanged: (int e) {
                        setState(() {
                          fireCreatModel.isNeedLadder = e;
                        });
                      }),
                  Text("不需要"),
                  new Radio(
                      value: 1,
                      groupValue: fireCreatModel.isNeedLadder,
                      onChanged: (int e) {
                        setState(() {
                          fireCreatModel.isNeedLadder = e;
                        });
                      }),
                  Text("需要"),
                ],
              ),
            ),
          ),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
          GestureDetector(
            onTap: takePhoto11,
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
                editIndex = 11;
              });
            },
            child: new Padding(
              padding: new EdgeInsets.fromLTRB(10, 20, 20, 0),
              child: Container(
                alignment: Alignment.center,
                child: fireCreatModel.editOutsinPic.length == 0
                    ? Text('+外箱安装位置图片')
                    : Image.file(File(fireCreatModel.editOutsinPic)),
                decoration: new BoxDecoration(
                  border: new Border.all(
                      width: 1.0,
                      color: (editIndex == 11
                          ? Colors.green
                          : prefix0.LINE_COLOR)),
                  borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                ),
                width: 150,
                height: 150,
              ),
            ),
          ),
          GestureDetector(
//            onTap: editAddress,//写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("备注"),
                ],
              ),
            ),
          ),
          TextField(
            controller: step3remarkController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.transparent)),
//                  labelText: '备注',
              hintText: '箱子型号，有几个什么类型的设备需要放在外箱中',
            ),
            maxLines: 5,
            autofocus: false,
            onChanged: (val) {
              fireCreatModel.step3Remak = val;
              setState(() {});
            },
          ),
          Padding(
            padding: new EdgeInsets.fromLTRB(0, 0, 0, 100),
          )
        ],
      ),
    );

    ScrollController _controller3 = TrackingScrollController();

    bool dataNotification3(ScrollNotification notification) {
      if (Platform.isIOS) {
        double height = notification.metrics.maxScrollExtent; //step2的高度
        height = height + 80;
        if (notification.metrics.extentBefore > height) {
          //下滑到最底部
          _pageController.animateToPage(3,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        } //滑动到最顶部
        if (notification.metrics.extentAfter > height) {
          _pageController.animateToPage(1,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        }
      } else if (Platform.isAndroid) {
        //android相关代码
        if (notification is ScrollEndNotification) {
          if (notification.metrics.extentAfter == 0) {
            //下滑到最底部
            _pageController.animateToPage(3,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
          } //滑动到最顶部
          if (notification.metrics.extentBefore == 0) {
            _pageController.animateToPage(1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
          }
        }
      }
      return true;
    }

    Widget step3 = Container(
        color: prefix0.LIGHT_LINE_COLOR,
        padding: new EdgeInsets.fromLTRB(0, 0, 0, 60),
        child: new NotificationListener(
            onNotification: dataNotification3,
            child: new ListView(
//          physics: NeverScrollableScrollPhysics(),
//          shrinkWrap: true,
              controller: _controller3,
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    new Row(children: <Widget>[
                      Padding(
                        child: new Text(
                          electricalItems[2],
                          style: TextStyle(color: prefix0.TITLE_TEXT_COLOR),
                        ),
                        padding: new EdgeInsets.fromLTRB(20, 20, 20, 20),
                      )
                    ]),
                    installationEnvironment,
                  ],
                )
              ],
            )));

    int _getProbeCount() {
      if (fireCreatModel.isSingle == 1) {
        if (fireCreatModel.isZhiHui == 1) {
          fireCreatModel.probeNumber = "0";
          return 0;
        } else {
          fireCreatModel.probeNumber = "2";
          return 2;
        }
      } else {
        fireCreatModel.probeNumber = "4";
        return 4;
      }
    }

    String _getRatedCurrent() {
      if (fireCreatModel.isSingle == 1) {
        if (fireCreatModel.isZhiHui == 1) {
          fireCreatModel.currentSelect = "63A";
          return "63A";
        } else {
          fireCreatModel.currentSelect = "63A";
          return "60A";
        }
      } else {
        if (currentValue == 0) {
          fireCreatModel.currentSelect = "250A";
        } else {
          fireCreatModel.currentSelect = "400A";
        }
        return "";
      }
    }

    String _getLeakageCurrent() {
      if (fireCreatModel.isSingle == 1) {
        if (fireCreatModel.isZhiHui == 1) {
          fireCreatModel.recommendedTransformer = "";
          return "";
        } else {
          fireCreatModel.recommendedTransformer = "L16K";
          return "L16K";
        }
      } else {
        if (fireCreatModel.isMolded == 1) {
          fireCreatModel.recommendedTransformer = "L45K";
          return "L45K";
        } else {
          fireCreatModel.recommendedTransformer = "L80K";
          return "L80K";
        }
      }
    }

    Widget installationEnvironment2 = Container(
      color: Colors.white,
      padding: new EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
//            onTap: editName,//写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("报警音可否有效传播"),
                  Expanded(
                    child: new Radio(
                        value: 1,
                        groupValue: fireCreatModel.isEffectiveTransmission,
                        onChanged: (int e) {
                          setState(() {
                            fireCreatModel.isEffectiveTransmission = e;
                          });
                        }),
                  ),
                  Text("是"),
                  Expanded(
                    child: new Radio(
                        value: 0,
                        groupValue: fireCreatModel.isEffectiveTransmission,
                        onChanged: (int e) {
                          setState(() {
                            fireCreatModel.isEffectiveTransmission = e;
                          });
                        }),
                  ),
                  Text("否"),
                ],
              ),
            ),
          ),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
          GestureDetector(
//            onTap: editPurpose,//写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("报警是否扰民"),
                  new Radio(
                      value: 1,
                      groupValue: fireCreatModel.isNuisance,
                      onChanged: (int e) {
                        setState(() {
                          fireCreatModel.isNuisance = e;
                        });
                      }),
                  Text("是"),
                  new Radio(
                      value: 0,
                      groupValue: fireCreatModel.isNuisance,
                      onChanged: (int e) {
                        setState(() {
                          fireCreatModel.isNuisance = e;
                        });
                      }),
                  Text("否"),
                ],
              ),
            ),
          ),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
          GestureDetector(
//            onTap: editPurpose,//写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("是否有专人消音"),
                  new Radio(
                      value: 1,
                      groupValue: fireCreatModel.isNoiseReduction,
                      onChanged: (int e) {
                        setState(() {
                          fireCreatModel.isNoiseReduction = e;
                        });
                      }),
                  Text("是"),
                  new Radio(
                      value: 0,
                      groupValue: fireCreatModel.isNoiseReduction,
                      onChanged: (int e) {
                        setState(() {
                          fireCreatModel.isNoiseReduction = e;
                        });
                      }),
                  Text("否"),
                ],
              ),
            ),
          ),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
          GestureDetector(
//            onTap: editAddress,//写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("备注"),
                ],
              ),
            ),
          ),
          TextField(
            controller: step4remarkController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: BorderSide(color: Colors.transparent)),
//                  labelText: '备注',
              hintText: '请输入其他环境影响因素。',
            ),
            maxLines: 5,
            autofocus: false,
            onChanged: (val) {
              fireCreatModel.step4Remak = val;
              setState(() {});
            },
          ),
          Padding(
            padding: new EdgeInsets.fromLTRB(0, 0, 0, 100),
          )
        ],
      ),
    );

    Widget perationEnvironment = Container(
      color: Colors.white,
      padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
//            onTap: editName,//写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("空开层级"),
                  new Radio(
                      value: 1,
                      groupValue: fireCreatModel.allOpenValue,
                      onChanged: (int e) {
                        setState(() {
                          fireCreatModel.allOpenValue = e;
                        });
                      }),
                  Text("总空开"),
                  new Radio(
                      value: 0,
                      groupValue: fireCreatModel.allOpenValue,
                      onChanged: (int e) {
                        setState(() {
                          fireCreatModel.allOpenValue = e;
                        });
                      }),
                  Text("分空开"),
                ],
              ),
            ),
          ),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
          GestureDetector(
//            onTap: editPurpose,//写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("空开类型"),
                  new Radio(
                      value: 1,
                      groupValue: fireCreatModel.isSingle,
                      onChanged: (int e) {
                        setState(() {
                          fireCreatModel.isSingle = e;
                          fireCreatModel.isZhiHui = 0;
                        });
                      }),
                  Text("单相电"),
                  new Radio(
                      value: 0,
                      groupValue: fireCreatModel.isSingle,
                      onChanged: (int e) {
                        setState(() {
                          fireCreatModel.isSingle = e;
                          fireCreatModel.isZhiHui = 0;
                        });
                      }),
                  Text("三相电"),
                ],
              ),
            ),
          ),
          new Offstage(
            offstage: (fireCreatModel.isSingle == 1) ? true : false,
            child: Container(
              padding: new EdgeInsets.fromLTRB(72, 0, 0, 0),
              child: Container(
                color: prefix0.LINE_COLOR,
                height: 1,
              ),
            ),
          ),
          new Offstage(
            offstage: (fireCreatModel.isSingle == 1) ? true : false,
            child: GestureDetector(
//            onTap: editPurpose,//写入方法名称就可以了，但是是无参的
              child: Container(
                alignment: Alignment.center,
                height: 60,
                child: new Row(
                  children: <Widget>[
                    Text("              "),
                    new Radio(
                        value: 1,
                        groupValue: fireCreatModel.isMolded,
                        onChanged: (int e) {
                          setState(() {
                            fireCreatModel.isMolded = e;
                          });
                        }),
                    Text("微断"),
                    new Radio(
                        value: 0,
                        groupValue: fireCreatModel.isMolded,
                        onChanged: (int e) {
                          setState(() {
                            fireCreatModel.isMolded = e;
                          });
                        }),
                    Text("塑壳"),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
          GestureDetector(
            onTap: editCurrent, //写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("额定电流"),
                  Expanded(
                    child: Text(
                      fireCreatModel.current.length > 0
                          ? (fireCreatModel.current + "A")
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
            onTap: editDangerous, //写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("危险线路数"),
                  Expanded(
                    child: Text(
                      fireCreatModel.dangerous.length > 0
                          ? (fireCreatModel.dangerous + "条")
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

    Widget perationEnvironment2 = Container(
      color: Colors.white,
      padding: new EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
//            onTap: editPurpose,//写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("适用类型"),
                  new Radio(
                    value: 1,
                    groupValue: fireCreatModel.isZhiHui,
                    onChanged: (int e) {
                      if (fireCreatModel.isSingle == 1) {
                        setState(() {
                          fireCreatModel.isZhiHui = e;
                        });
                      }
                    },
                  ),
                  Expanded(
                    child: Text(
                      "智慧空开\n(支持通断)",
                      style: new TextStyle(
                          color: fireCreatModel.isSingle == 1
                              ? Colors.black
                              : Colors.grey),
                    ),
                  ),
                  new Radio(
                      value: 0,
                      groupValue: fireCreatModel.isZhiHui,
                      onChanged: (int e) {
                        if (fireCreatModel.isSingle == 1) {
                          setState(() {
                            fireCreatModel.isZhiHui = e;
                          });
                        }
                      }),
                  Expanded(
                    child: Text("电气火灾\n(不支持通断)"),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
          GestureDetector(
//            onTap: editPurpose,//写入方法名称就可以了，但是是无参的
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
                  Text("温度探头数"),
                  Expanded(
                    child: Text(
                      _getProbeCount().toString() + "个",
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
          new Offstage(
            offstage: (fireCreatModel.isSingle == 0) ? true : false,
            child: GestureDetector(
//            onTap: editPurpose,//写入方法名称就可以了，但是是无参的
              child: Container(
                alignment: Alignment.center,
                height: 60,
                child: new Row(
                  children: <Widget>[
                    Text("额定电流"),
                    Expanded(
                      child: Text(
                        _getRatedCurrent(),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          new Offstage(
            offstage: (fireCreatModel.isSingle == 1) ? true : false,
            child: GestureDetector(
//            onTap: editName,//写入方法名称就可以了，但是是无参的
              child: Container(
                alignment: Alignment.center,
                height: 60,
                child: new Row(
                  children: <Widget>[
                    Text("额定电流"),
                    Expanded(
                      child: new Radio(
                          value: 1,
                          groupValue: currentValue,
                          onChanged: (int e) {
                            setState(() {
                              currentValue = 1;
                              fireCreatModel.currentSelect = "250A";
                            });
                          }),
                    ),
                    Text("250A"),
                    Expanded(
                      child: new Radio(
                          value: 0,
                          groupValue: currentValue,
                          onChanged: (int e) {
                            setState(() {
                              currentValue = 0;
                              fireCreatModel.currentSelect = "400A";
                            });
                          }),
                    ),
                    Text("400A"),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: prefix0.LINE_COLOR,
            height: 1,
          ),
          new Offstage(
            offstage:
                (fireCreatModel.isSingle == 1 && fireCreatModel.isZhiHui == 1)
                    ? true
                    : false,
            child: GestureDetector(
//            onTap: editPurpose,//写入方法名称就可以了，但是是无参的
              child: Container(
                alignment: Alignment.center,
                height: 60,
                child: new Row(
                  children: <Widget>[
                    Text("漏电互感器规格"),
                    Expanded(
                      child: Text(
                        _getLeakageCurrent(),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    ScrollController _controller4 = TrackingScrollController();

    bool dataNotification4(ScrollNotification notification) {
      if (Platform.isIOS) {
        double height = notification.metrics.maxScrollExtent; //step2的高度
        height = height + 80;
        if (notification.metrics.extentBefore > height) {
          //下滑到最底部
          _pageController.animateToPage(4,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        } //滑动到最顶部
        if (notification.metrics.extentAfter > height) {
          _pageController.animateToPage(2,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        }
      } else if (Platform.isAndroid) {
        //android相关代码
        if (notification is ScrollEndNotification) {
          if (notification.metrics.extentAfter == 0) {
            //下滑到最底部
            _pageController.animateToPage(4,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
          } //滑动到最顶部
          if (notification.metrics.extentBefore == 0) {
            _pageController.animateToPage(2,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
          }
        }
      }
      return true;
    }

    Widget step4 = Container(
        color: prefix0.LIGHT_LINE_COLOR,
        padding: new EdgeInsets.fromLTRB(0, 0, 0, 60),
        child: new NotificationListener(
            onNotification: dataNotification4,
            child: new ListView(
//          physics: NeverScrollableScrollPhysics(),
//          shrinkWrap: true,
              controller: _controller4,
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    new Row(children: <Widget>[
                      Padding(
                        child: new Text(
                          electricalItems[3],
                          style: TextStyle(color: prefix0.TITLE_TEXT_COLOR),
                        ),
                        padding: new EdgeInsets.fromLTRB(20, 20, 20, 20),
                      )
                    ]),
                    installationEnvironment2,
                  ],
                )
              ],
            )));

    ScrollController _controller5 = TrackingScrollController();

    bool dataNotification5(ScrollNotification notification) {
      if (Platform.isIOS) {
        double height = notification.metrics.maxScrollExtent; //step2的高度
        height = height + 80;
        if (notification.metrics.extentAfter > height) {
          _pageController.animateToPage(3,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        }
      } else if (Platform.isAndroid) {
        //android相关代码
        if (notification is ScrollEndNotification) {
          if (notification.metrics.extentBefore == 0) {
            _pageController.animateToPage(3,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
          }
        }
      }
      return true;
    }

    Widget step5 = Container(
        color: prefix0.LIGHT_LINE_COLOR,
        padding: new EdgeInsets.fromLTRB(0, 0, 0, 60),
        child: new NotificationListener(
            onNotification: dataNotification5,
            child: new ListView(
//          physics: NeverScrollableScrollPhysics(),
//          shrinkWrap: true,
              controller: _controller5,
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    new Row(children: <Widget>[
                      Padding(
                        child: new Text(
                          electricalItems[4],
                          style: TextStyle(color: prefix0.TITLE_TEXT_COLOR),
                        ),
                        padding: new EdgeInsets.fromLTRB(20, 20, 20, 20),
                      )
                    ]),
                    perationEnvironment,
                    new Padding(padding: new EdgeInsets.fromLTRB(0, 0, 0, 20)),
                    perationEnvironment2,
                  ],
                )
              ],
            )));

    Widget bigContainer = Container(
        color: prefix0.LIGHT_LINE_COLOR,
        padding: new EdgeInsets.fromLTRB(0, 0, 0, 60),
        child: new ListView(
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            step1,
            step2,
            step3,
            step4,
            step5,
          ],
        ));

    var mPageView = new PageView.builder(
      controller: _pageController,
      itemCount: 5,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return step1;
        } else if (index == 1) {
          return step2;
        } else if (index == 2) {
          return step3;
        } else if (index == 3) {
          return step4;
        } else {
          return step5;
        }
      },
    );

    return Scaffold(
      appBar: NavBar,
      body: mPageView,
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
