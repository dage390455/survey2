import 'package:flutter/material.dart';

class SiteManagementPage extends StatefulWidget {
  SiteManagementPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _SiteManagementPageState createState() => _SiteManagementPageState();
}

class _SiteManagementPageState extends State<SiteManagementPage> {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('场所管理'),
      ),
      body: new ListView.builder(
        itemBuilder: (context, index) {
          return new InkWell(
            onTap: () {

            },
            child: new Card(
              child: new Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: 50,
                child: new Text(routerName[index]),
              ),
            ),
          );
        },
        itemCount: routerName.length,
      ),
    );
  }
}


const routerName = [
  "场所2",
  "场所3",
  "场所4",
  "场所5",
  "场所6",
  "场所7",
  "场所8"
];