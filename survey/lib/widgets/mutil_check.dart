import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sensoro_survey/model/mutilcheck_model.dart';
import 'package:sensoro_survey/model/component_configure_model.dart';

///传入标题* item集合* 是否单选
class MutilCheck extends StatefulWidget {
  List<MutilCheckModel> dataList;

  ///单选true、多选false
  bool isSingle;
  String title;
  componentModel model;
  // const MutilCheck({this.title, this.dataList, this.isSingle, this.model})
  //     : super();

  MutilCheck(
      {Key key, @required this.title, this.dataList, this.isSingle, this.model})
      : super(key: key);

  ///获取选中的集合
  getSelecedList() {
    List<String> selectedList = [];

    for (int i = 0; i < dataList.length; i++) {
      if (dataList[i].isChecked) {
        selectedList.add(dataList[i].name);
      }
    }

    return selectedList;
  }

  @override
  State createState() =>
      _mutilCheckState(this.title, this.dataList, this.isSingle, this.model);

  // State<StatefulWidget> createState() {
  //   return new _mutilCheckState(this.title, this.dataList, this.isSingle, this.model);
  // }
}

class _mutilCheckState extends State<MutilCheck> {
  List<MutilCheckModel> dataList;

  ///单选true、多选false
  bool isSingle;
  String title;
  componentModel model;

  _mutilCheckState(this.title, this.dataList, this.isSingle, this.model);

  @override
  void initState() {
    this.model = model;
    this.title = title;
    this.dataList = dataList;
    this.isSingle = this.isSingle;

    // List<String> optionList = this.model.options.split(";");

    // widget.dataList = List<MutilCheckModel>.generate(
    //     optionList.length, (i) => new MutilCheckModel(optionList[i], false));

    // for (int i = 0; i < widget.dataList.length; i++) {
    //   if (this.model.variable_value.contains(widget.dataList[i].name)) {
    //     widget.dataList[i].isChecked = true;
    //   }
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> optionList = this.model.options.split(";");

    widget.dataList = List<MutilCheckModel>.generate(
        optionList.length, (i) => new MutilCheckModel(optionList[i], false));

    for (int i = 0; i < widget.dataList.length; i++) {
      if (this.model.variable_value.contains(widget.dataList[i].name)) {
        widget.dataList[i].isChecked = true;
      }
    }

    return Container(
      child: Padding(
        padding: new EdgeInsets.fromLTRB(0, 10, 20, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 17),
              ),
              padding: EdgeInsets.fromLTRB(0, 13, 20, 0),
            ),
            Expanded(
              child: Wrap(
                  children: List.generate(widget.dataList.length, (index) {
                return Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(widget.dataList[index].name),
                      Checkbox(
                          tristate: false,
                          activeColor: Colors.blue,
                          value: widget.dataList[index].isChecked,
                          onChanged: (bool bol) {
                            if (this.isSingle) {
                              for (int i = 0; i < widget.dataList.length; i++) {
                                widget.dataList[i].isChecked = false;
                              }
                            }
                            setState(() {
                              widget.dataList[index].isChecked = bol;
                              if (this.isSingle) {
                                model.variable_value =
                                    widget.dataList[index].name;
                              } else {
                                model.variable_value = "";
                                for (int i = 0;
                                    i < widget.dataList.length;
                                    i++) {
                                  if (widget.dataList[i].isChecked == true) {
                                    if (model.variable_value.length == 0) {
                                      model.variable_value =
                                          widget.dataList[i].name;
                                    } else {
                                      model.variable_value =
                                          model.variable_value +
                                              ',' +
                                              widget.dataList[i].name;
                                    }
                                  }
                                }
                              }
                            });
                          })
                    ],
                  ),
                );
              })),
            ),
          ],
        ),
      ),
    );
  }
}
