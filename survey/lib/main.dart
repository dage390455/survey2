import 'dart:async';
import 'dart:core';
import 'dart:ui' as ui; // 调用window拿到route判断跳转哪个界面

import 'package:sensoro_survey/generated/application.dart';
import 'package:sensoro_survey/generated/translations.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/rendering.dart';
import 'package:sensoro_survey/views/survey/const.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sensoro_survey/views/sensoro_city_page/task_detail_page.dart';
import 'package:sensoro_survey/views/sensoro_city_page/task_list_page.dart';
import 'package:sensoro_survey/views/sensoro_city_page/task_test_page.dart';

import 'package:sensoro_survey/views/survey/project_list_page.dart';
import 'package:sensoro_survey/views/survey/electric_install_page.dart';

//import 'views/welcome_page/index.dart';

const int ThemeColor = 0xFFC91B3A;
var db;

class MyApp extends StatefulWidget {
  MyApp() {
    final router = new Router();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _hasLogin = false;
  bool _isLoading = true;
  SpecificLocalizationDelegate _localeOverrideDelegate;

  @override
  Future initState() {
    super.initState();

    /// 初始化一个新的Localization Delegate，有了它，当用户选择一种新的工作语言时，可以强制初始化一个新的Translations
    _localeOverrideDelegate = new SpecificLocalizationDelegate(null);

    /// 保存这个方法的指针，当用户改变语言时，我们可以调用applic.onLocaleChanged(new Locale('en',''));，通过SetState()我们可以强制App整个刷新
    applic.onLocaleChanged = onLocaleChange;
    var platformAandroid =
        (Theme.of(context).platform == TargetPlatform.android);
  }

  // 改变语言时的应用刷新核心，每次选择一种新的语言时，都会创造一个新的SpecificLocalizationDelegate实例，强制Translations类刷新。
  onLocaleChange(Locale locale) {
    setState(() {
      _localeOverrideDelegate = new SpecificLocalizationDelegate(locale);
    });
  }

  _UpdateURL() async {
    const currUrl =
        'https://github.com/alibaba/flutter-go/raw/master/FlutterGo.apk';
    if (await canLaunch(currUrl)) {
      await launch(currUrl);
    } else {
      throw 'Could not launch $currUrl';
    }
  }

  showWelcomePage() {
//    if (_isLoading) {
//      return Container(
//        color: const Color(ThemeColor),
//        child: Center(
//          child: SpinKitPouringHourglass(color: Colors.white),
//        ),
//      );
//    } else {
//      // 判断是否已经登录
//      if (_hasLogin) {
    // return AppPage();
//      } else {
//        return LoginPage();
//      }
//    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'title',
      theme: new ThemeData(
        primaryColor: Color(ThemeColor),
        backgroundColor: Color(0xFFEFEFEF),
        accentColor: Color(0xFF888888),
        textTheme: TextTheme(
          //设置Material的默认字体样式
          body1: TextStyle(color: Color(0xFF888888), fontSize: 16.0),
        ),
        iconTheme: IconThemeData(
          color: Color(ThemeColor),
          size: 35.0,
        ),
      ),
      home: new Scaffold(body: showWelcomePage()),
      //去掉debug logo
      debugShowCheckedModeBanner: false,
      // onGenerateRoute: Application.router.generator,
      // navigatorObservers: <NavigatorObserver>[Analytics.observer],
    );
  }
}

//注册页面，这个方法实现和原生的交互。
Widget _widgetForRoute(String route) {
  print('route=$route');
  //这一句代码改变上方状态栏字体颜色
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  switch (route) {
    case 'myApp':
      return new MyApp();
    case 'myApp1':
      return new MyApp1();
    case 'taskTest':
      return new ListViewDemo2();
    case 'taskList':
      return new taskListPage();
    case 'taskList_english':
      setIsEnglish(true);
      return new taskListPage();
    case 'electricInstall':
      return new ElectricInstallPage();
    case 'electricInstall_english':
      setIsEnglish(true);
      return new ElectricInstallPage();
    case 'projectList':
      return new ProjectListPage();
    default:
      return Center(
        child: Text('Unknown route: $route', textDirection: TextDirection.ltr),
      );
  }
}

// void main() {
// void main() async => runApp(_widgetForRoute(ui.window.defaultRouteName));
void main() async {
  // runApp(new MyApp());

  print('进入了flutter');

  //选择打开哪个页面
  runApp(_widgetForRoute(ui.window.defaultRouteName));
  // runApp(_widgetForRoute('myApp'));

  //这一句代码改变上方状态栏字体颜色
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
}

class MyApp1 extends StatelessWidget {
  Widget _home(BuildContext context) {
    return new MyHomePage(title: 'Flutter Demo Home Page');
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        "/home": (BuildContext context) => new MyHomePage(),
      },
      home: _home(context),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 创建一个给native的channel (类似iOS的通知）
  static const methodChannel = const MethodChannel('com.pages.your/native_get');

  _iOSPushToVC() async {
    await methodChannel.invokeMethod('iOSFlutter', '参数');
  }

  _iOSPushToVC1() async {
    Map<String, dynamic> map = {
      "code": "200",
      "data": [1, 2, 3]
    };
    await methodChannel.invokeMethod('iOSFlutter1', map);
  }

  _iOSPushToVC2() async {
    dynamic result;
    try {
      result = await methodChannel.invokeMethod('iOSFlutter2');
    } on PlatformException {
      result = "error";
    }
    if (result is String) {
      print(result);
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return new Container(
              child: new Center(
                child: new Text(
                  result,
                  style: new TextStyle(color: Colors.brown),
                  textAlign: TextAlign.center,
                ),
              ),
              height: 40.0,
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('注册了router ${methodChannel}');
    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new FlatButton(
                onPressed: () {
                  _iOSPushToVC();
                },
                child: new Text("跳转ios新界面，参数是字符串")),
            new FlatButton(
                onPressed: () {
                  _iOSPushToVC1();
                },
                child: new Text("传参，参数是map，看log")),
            new FlatButton(
                onPressed: () {
                  _iOSPushToVC2();
                },
                child: new Text("接收客户端相关内容")),
          ],
        ),
      ),
    );
  }
}
