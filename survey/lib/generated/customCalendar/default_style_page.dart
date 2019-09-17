import 'package:flutter/material.dart';
import 'package:sensoro_survey/generated/customCalendar/lib/flutter_custom_calendar.dart';

class DefaultStylePage extends StatefulWidget {
  DefaultStylePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DefaultStylePageState createState() => _DefaultStylePageState();
}

class _DefaultStylePageState extends State<DefaultStylePage> {
  String text;

  CalendarController controller;

  @override
  void initState() {
    text = "${DateTime.now().year}年${DateTime.now().month}月";

    controller = new CalendarController();

    controller.addMonthChangeListener(
      (year, month) {
        setState(() {
          text = "$year年$month月";
        });
      },
    );

    controller.addOnCalendarSelectListener((dateModel) {
      //刷新选择的时间
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "日期选择",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Image.asset(
            "assets/images/back.png",
            // height: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new IconButton(
                    icon: Icon(Icons.navigate_before),
                    onPressed: () {
                      controller.moveToPreviousMonth();
                    }),
                // new Text(text),
                new IconButton(
                    icon: Icon(Icons.navigate_next),
                    onPressed: () {
                      controller.moveToNextMonth();
                    }),
              ],
            ),
            CalendarViewWidget(
              calendarController: controller,
            ),
            // new Text(
            //     "单选模式\n选中的时间:\n${controller.getSingleSelectCalendar().toString()}"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop(controller.getSingleSelectCalendar());
        },
        tooltip: 'Increment',
        child: Icon(Icons.done),
      ),
    );
  }
}
