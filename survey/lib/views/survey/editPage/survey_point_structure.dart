

//现场情况
import 'package:flutter/material.dart';
import 'package:sensoro_survey/views/survey/const.dart' as prefix0;
import 'package:sensoro_survey/views/survey/summary_construction_page.dart';



class SurveyPointStructureEditPage extends StatefulWidget {
  var name = "";
  SurveyPointStructureEditPage({this.name});
  @override
  _State createState() => _State(name: this.name);
}

class _State extends State<SurveyPointStructureEditPage> {

   var name = "";

  _State({this.name});

  TextEditingController locationController = TextEditingController();
   @override
   void initState() {
     // TODO: implement initState
     locationController.text = this.name;
     super.initState();
   }

  @override
  Widget build(BuildContext context) {

    Widget NavBar = AppBar(
      elevation: 1.0,
      centerTitle:true,
      brightness: Brightness.light,
      backgroundColor: Colors.white,

      title: Text(
        "勘察点结构",
        style: TextStyle(
            color: Colors.black
        ),

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
      color:  prefix0.LIGHT_LINE_COLOR,
      height: 60,
      width: prefix0.screen_width,
      child: new MaterialButton(
        color: this.name.length>0? prefix0.GREEN_COLOR :Colors.grey,
        textColor: Colors.white,
        child: new Text('保存',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 20)),
        onPressed: () {
          if (this.name.length>0){
            Navigator.of(context).pop(this.name);
          }
        },
      ),
    );



    Widget container = Container(
      color: prefix0.LIGHT_LINE_COLOR,
      padding:  EdgeInsets.all(20),
      child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: locationController,
            keyboardType: TextInputType.text,

            decoration: InputDecoration(

              labelText: '勘察点结构(选填)',

            ),
            autofocus: false,
             onChanged: (val) {
              name = val;
              setState(() {

              });
            },
          ),

        ],
      ),
    );


    Widget bigContainer = Container(
      color: prefix0.LIGHT_LINE_COLOR,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          container

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
