import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sensoro_survey/model/mutilcheck_model.dart';

///传入标题* item集合* 是否单选
class MutilCheck1 extends StatefulWidget {
  const MutilCheck1({
    this.title,
    this.dataList,
    this.isSingle,
  }) : super();

  final List<MutilCheckModel> dataList;

  ///单选true、多选false
  final bool isSingle;
  final String title;


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
  State<StatefulWidget> createState() {
    return new _mutilCheckState1();
  }
}

class _mutilCheckState1 extends State<MutilCheck1> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                            if (widget.isSingle) {
                              for (int i = 0; i < widget.dataList.length; i++) {
                                widget.dataList[i].isChecked = false;
                              }
                            }
                            setState(() {
                              widget.dataList[index].isChecked = bol;
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
