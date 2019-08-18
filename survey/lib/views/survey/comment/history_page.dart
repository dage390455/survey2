

//现场情况
import 'package:flutter/material.dart';
import 'package:sensoro_survey/views/survey/comment/SaveDataManger.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;




class HistoryPage extends StatefulWidget {
  var hisoryKey = "";
  final editParentText;
  HistoryPage({this.hisoryKey,this.editParentText});

  @override
  _State createState() => _State(hisoryKey: this.hisoryKey,editParentText: editParentText);
}

class _State extends State<HistoryPage> {
   var editParentText;
   var hisoryKey = "";
    List<String> tags = [];
  _State({this.hisoryKey,this.editParentText});



   @override
   void initState() {
     // TODO: implement initState
     getHistory();
     super.initState();
   }

   getHistory()async{
     tags =  await SaveDataManger.getHistory(hisoryKey);
     setState(() {

     });
   }

   clearHistory(){

     tags.clear();

     SaveDataManger.saveHistory(tags, hisoryKey);
     setState(() {

     });
   }

   @override
  Widget build(BuildContext context) {





    Widget bigContainer = Container(
      color: prefix0.LIGHT_LINE_COLOR,
//      color: prefix0.blueLogin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
//
//          new Container(
//            child: new Row(
//               children: <Widget>[
//                 new Text("历史记录"),
//                 Expanded(
//                   child:  new Text("清除"),
//                 )
//
//               ],
//            ),
//
//          ),

          Container (
              padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
              alignment: Alignment.center,
              height: 60,
              child: new Row(
                children: <Widget>[
//                  new Padding(
//                    padding: new EdgeInsets.fromLTRB(0, 0, 0, 0),
//                    child:  Text("历史记录"),
//                  ),

                  Expanded(
                    child: Text("历史记录"),
                  ),

                  GestureDetector(
                    onTap: clearHistory,//写入方法名称就可以了，但是是无参的
                    child:
                    Text(
                      "清除",
                      textAlign: TextAlign.right,

                    ),

                  ),


                ],
              ) ,
            ),


          new Container(
              padding: new EdgeInsets.fromLTRB(10, 0, 0, 10),
              child: new Wrap(children: <Widget>[

              for (var item in tags) new TagItem(item,editParentText),


        ]),
    ),

        ],

      ),

    );

    return bigContainer;

  }


}




class TagItem extends StatelessWidget {
  final String text;
  var editParentText;
  TagItem(this.text,this.editParentText);

  test(){
     editParentText(text);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: test ,//写入方法名称就可以了，但是是无参的
        child:Container (
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.grey.withAlpha(60),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: new Text(text),

        ),
      );
  }
}
