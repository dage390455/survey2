import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sensoro_survey/model/project_info_model.dart';
import 'package:sensoro_survey/views/survey/point_list_page.dart';
import 'package:sensoro_survey/views/survey/sitePages/site_management_page.dart';

import 'addPointPages/Model/PointListModel.dart';
import 'addPointPages/point_network_page.dart';
import 'addPointPages/point_risk_management_page.dart';
import 'addPointPages/point_risk_type_select_page.dart';



class PointContentPage extends StatefulWidget {
  projectInfoModel input;
  PointListModel model;
  PointContentPage({Key key, @required this.input,this.model}) : super(key: key);
  @override
  State<StatefulWidget> createState() => PointContentPageState(input);
}

class PointContentPageState extends State<PointContentPage> {
  final appBarTitles = ['风险评估','网络铺设', '终端安装'];
  final tabTextStyleSelected = TextStyle(color: Colors.black);
  final tabTextStyleNormal = TextStyle(color: const Color(0xff969696));
  projectInfoModel input;

  PointContentPageState(this.input);

  // ignore: undefined_identifier
//  Color themeColor = ThemeColorUtils.currentColorTheme;//设置主题标题背景颜色
  int _tabIndex = 0;

  var tabImages;
  var _body;
  var pages;

  Image getTabImage(path) {
    return Image.asset(path, width: 20.0, height: 20.0);
  }

  @override
  void initState() {
    super.initState();
    pages = <Widget>[PointRiskTypeSelectPage(model: widget.model,),PointNewWorkPage(),PointListPage(input: input)];
    if (tabImages == null) {
      tabImages = [
        [
          getTabImage('assets/images/fengxianpinggu.png'),
          getTabImage('assets/images/fengxianpinggu-click.png')
        ],
        [
          getTabImage('assets/images/wangluo.png'),
          getTabImage('assets/images/wangluo-click.png')
        ],
        [
          getTabImage('assets/images/zhongduananzhuang.png'),
          getTabImage('assets/images/zhongduananzhuang-click.png')
        ],
      ];
    }
  }

  TextStyle getTabTextStyle(int curIndex) {//设置tabbar 选中和未选中的状态文本
    if (curIndex == _tabIndex) {
      return tabTextStyleSelected;
    }
    return tabTextStyleNormal;
  }

  Image getTabIcon(int curIndex) {//设置tabbar选中和未选中的状态图标
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }

  Text getTabTitle(int curIndex) {
    return Text(appBarTitles[curIndex], style: getTabTextStyle(curIndex));
  }




  @override
  Widget build(BuildContext context) {
    _body = IndexedStack(
      children: pages,
      index: _tabIndex,
    );


    Widget navBar = AppBar(
      elevation: 1.0,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      centerTitle: true,
      // title: Text(
      //   "项目列表",
      //   style: TextStyle(
      //       color: BLACK_TEXT_COLOR, fontWeight: FontWeight.bold, fontSize: 16),
      // ),
      leading: IconButton(
        icon: Image.asset(
          "assets/images/back.png",
          // height: 20,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(widget.model.name),
      actions: <Widget>[


      ],
    );




    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.white
      ),
      home: Scaffold(//布局结构
//        appBar: AppBar(//选中每一项的标题和图标设置
//            title: Text(appBarTitles[_tabIndex],
//                style: TextStyle(color: Colors.white)),
//            iconTheme: IconThemeData(color: Colors.white)
//        ),

        appBar: navBar,
        body: _body,
        bottomNavigationBar: CupertinoTabBar(//
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: getTabIcon(0),
                title: getTabTitle(0)),
            BottomNavigationBarItem(
                icon: getTabIcon(1),
                title: getTabTitle(1)),

            BottomNavigationBarItem(
                icon: getTabIcon(2),
                title: getTabTitle(2)),
//            BottomNavigationBarItem(
//                icon: getTabIcon(3),
//                title: getTabTitle(3)),
          ],
          currentIndex: _tabIndex,
          onTap: (index) {
            setState((){

              _tabIndex = index;
            });
          },
        ),
//          drawer: MyDrawer()
      ),
    );
  }



}
