import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sensoro_survey/views/survey/sitePages/site_management_page.dart';

import 'views/survey/project_list_page.dart';

class HomeContentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeContentPageState();
}

class HomeContentPageState extends State<HomeContentPage> {
  final appBarTitles = ['勘察项目', '场所管理'];
  final tabTextStyleSelected = TextStyle(color: Colors.black);
  final tabTextStyleNormal = TextStyle(color: const Color(0xff969696));

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
    pages = <Widget>[ProjectListPage(),SiteManagementPage()];
    if (tabImages == null) {
      tabImages = [
        [
          getTabImage('assets/images/home.png'),
          getTabImage('assets/images/home_sel.png')
        ],
        [
          getTabImage('assets/images/alarm_home.png'),
          getTabImage('assets/images/alarm_home_sel.png')
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
        body: _body,
        bottomNavigationBar: CupertinoTabBar(//
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: getTabIcon(0),
                title: getTabTitle(0)),
            BottomNavigationBarItem(
                icon: getTabIcon(1),
                title: getTabTitle(1)),
//            BottomNavigationBarItem(
//                icon: getTabIcon(2),
//                title: getTabTitle(2)),
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
