import 'dart:convert';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveDataManger {
  // setUp() async {
  //   const MethodChannel('plugins.flutter.io/shared_preferences')
  //       .setMockMethodCallHandler((MethodCall methodCall) async {
  //     if (methodCall.method == 'getAll') {
  //       return <String, dynamic>{}; // set initial values here if desired
  //     }
  //     return null;
  //   });
  // }

  //shared_preferences 存在重启后清空的问题，考虑用自定义的methodChannel来实现userdefault存储
  static const methodChannel =
      const MethodChannel('com.pages.your/project_list');

  static const EventChannel eventChannel =
      const EventChannel("App/Event/Channel", const StandardMethodCodec());

  Map<String, dynamic> testValues = <String, dynamic>{};

  static saveHistory(List<String> tags, String historyKey) async {
    // SharedPreferences.setMockInitialValues({});
    // const MethodChannel('plugins.flutter.io/shared_preferences')
    //     .setMockMethodCallHandler((MethodCall methodCall) async {
    //   if (methodCall.method == 'getAll') {
    //     return <String, dynamic>{}; // set initial values here if desired
    //   }
    //   return null;
    // });
    // return null;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var tagsString = "";

    for (int i = 0; i < tags.length; i++) {
      if (tagsString.length == 0) {
        tagsString = tags[i];
      } else {
        tagsString = tagsString + "," + tags[i];
      }
    }

    var f = await prefs.setString(historyKey, tagsString);
    //tagsString={"projectName":"韩国哈哈","createTime":"2019-08-29 10:21","remark":"","id":1567045262407,"subList":[]},{"projectName":"哈哈哈哈","createTime":"2019-08-29 10:21","remark":"","id":1567045268967,"subList":[]},
    //用自定义methodChannel保存本地化数据，不是shared_preferences

    //给userdefault保存时，最外层用;分割.
    String str1 = tagsString.replaceAll('},{"p', '};{"p');
    Map<String, dynamic> map = {
      "value": str1,
      "key": historyKey,
    };
    await methodChannel.invokeMethod('saveHistoryList', map);

    print("---------------" + f.toString());
  }

  static saveProjectHistory(List<String> tags, String historyKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var tagsString = "";

    for (int i = 0; i < tags.length; i++) {
      if (tagsString.length == 0) {
        tagsString = tags[i];
      } else {
        tagsString = tagsString + "," + tags[i];
      }
    }

    var f = await prefs.setString(historyKey, tagsString);
    //tagsString={"projectName":"韩国哈哈","createTime":"2019-08-29 10:21","remark":"","id":1567045262407,"subList":[]},{"projectName":"哈哈哈哈","createTime":"2019-08-29 10:21","remark":"","id":1567045268967,"subList":[]},
    //用自定义methodChannel保存本地化数据，不是shared_preferences
  }

  static Future<List<String>> getHistory(String historyKey) async {
    // SharedPreferences.setMockInitialValues({});

    // SharedPreferences.setMockInitialValues({});
    // const MethodChannel('plugins.flutter.io/shared_preferences')
    //     .setMockMethodCallHandler((MethodCall methodCall) async {
    //   if (methodCall.method == 'getAll') {
    //     return <String, dynamic>{}; // set initial values here if desired
    //   }
    //   return null;
    // });

    //从原生userdefault拉取数据
    // eventChannel
    //     .receiveBroadcastStream("sendProjectList")
    //     .listen(_onEvent, onError: _onError);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var history = prefs.getString(historyKey);
    if (history != null && history.length > 0) {
      return history.split(",");
    }
    return List<String>();
  }

  static Future<List<dynamic>> getProjectHistory(String historyKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String history = prefs.getString(historyKey);
    if (history == null || history.length == 0) {
      return List<dynamic>();
    }
    if (history.length > 0) {
      String str0 = history.substring(0, 1);
      if (str0 == ',') {
        history = history.substring(1, history.length);
      }
    }

    history = history.replaceAll('subList\":}', 'subList\":[]}');
    history = "[$history]";
    if (history != null && history.length > 0) {
      List<dynamic> list = jsonDecode(history);
      return list;
    }
    return List<dynamic>();
  }

  static addHistory(String tag, String historyKey) async {
    var history = await SaveDataManger.getHistory(historyKey);

    // if (historyKey == "projectList") {
    //   history = await SaveDataManger.getProjectHistory(historyKey);
    // }

    if (!history.contains(tag)) {
      history.add(tag);

      SaveDataManger.saveHistory(history, historyKey);
    }
    //history是一个被,分割后的字符串数组,[0]"{"projectName":"韩国哈哈"" [1]""createTime":"2019-08-29 10:21""
  }

  static addProjectHistory(String tag, String historyKey) async {
    var history = await SaveDataManger.getHistory(historyKey);

    // if (historyKey == "projectList") {
    //   history = await SaveDataManger.getProjectHistory(historyKey);
    // }

    if (!history.contains(tag)) {
      history.add(tag);

      SaveDataManger.saveProjectHistory(history, historyKey);
    }
    //history是一个被,分割后的字符串数组,[0]"{"projectName":"韩国哈哈"" [1]""createTime":"2019-08-29 10:21""
  }

  //修改已存储的内容，编辑模式
  static replaceHistory1(String tag, String historyKey, int id) async {
    var history = await SaveDataManger.getHistory(historyKey);
    List<String> tags = history;
    for (int i = 0; i < tags.length; i++) {
      String str = tags[i];
      if (str.length < 3) {
        continue;
      }
      Map<String, dynamic> map = json.decode(str);
      if (map.containsKey("id") && map["id"].toInt() == id) {
        String str1 = tags[i - 3];
        Map<String, dynamic> map1 = json.decode(str1);
      }
    }
  }

  //修改已存储的内容，编辑模式
  static replaceHistory(String tag, String historyKey, int id) async {
    var history = await SaveDataManger.getProjectHistory(historyKey);
    List<dynamic> tags = history;
    String teststr3 = jsonEncode(tags);
    List<String> list = [];

    for (int i = 0; i < tags.length; i++) {
      Map<String, dynamic> map = tags[i];

      // Map<String, dynamic> map = json.decode(str);
      int id1 = map["id"].toInt();
      //替换
      if (id == id1) {
        // tags.removeAt(i);
        continue;
        // history.add(tag);
        // List<dynamic> list = jsonDecode(tag);
        // SaveDataManger.saveHistory(history, historyKey);
      }
      List list1 = [map];
      String str = jsonEncode(list1);
      list.add(str);
    }
    // list.add(tag);

    String inputStr = "";
    for (int i = 0; i < list.length; i++) {
      String str = list[i];
      str = str.replaceAll('[', '');
      str = str.replaceAll(']', '');
      if (inputStr.length == 0) {
        inputStr = str;
      } else {
        inputStr = inputStr + ',' + str;
      }
    }
    if (inputStr.length == 0) {
      inputStr = tag;
    } else {
      inputStr = inputStr + ',' + tag;
    }
    List<String> list2 = inputStr.split(',');
    //这一步要把tags里的map转成字符串数组，再加上tag才能用

    // String newStr = jsonEncode(tags);
    // SaveDataManger.saveHistory(list2, historyKey);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var f = await prefs.setString(historyKey, inputStr);
    //tagsString={"projectName":"韩国哈哈","createTime":"2019-08-29 10:21","remark":"","id":1567045262407,"subList":[]},{"projectName":"哈哈哈哈","createTime":"2019-08-29 10:21","remark":"","id":1567045268967,"subList":[]},
    //用自定义methodChannel保���本地化数据，不是shared_preferences

    //给userdefault保存时，最外层用;分割.
    String str1 = inputStr.replaceAll('},{"p', '};{"p');
    Map<String, dynamic> map = {
      "value": str1,
      "key": historyKey,
    };
    await methodChannel.invokeMethod('saveHistoryList', map);
  }

  //删除已存储的内容
  static deleteHistory(String tag, String historyKey, int id) async {
    var history = await SaveDataManger.getProjectHistory(historyKey);
    List<dynamic> tags = history;
    String teststr3 = jsonEncode(tags);
    List<String> list = [];

    for (int i = 0; i < tags.length; i++) {
      Map<String, dynamic> map = tags[i];

      // Map<String, dynamic> map = json.decode(str);
      int id1 = map["id"].toInt();
      //替换
      if (id == id1) {
        // tags.removeAt(i);
        continue;
        // history.add(tag);
        // List<dynamic> list = jsonDecode(tag);
        // SaveDataManger.saveHistory(history, historyKey);
      }
      List list1 = [map];
      String str = jsonEncode(list1);
      list.add(str);
    }
    // list.add(tag);

    String inputStr = "";
    for (int i = 0; i < list.length; i++) {
      String str = list[i];
      str = str.replaceAll('[', '');
      str = str.replaceAll(']', '');
      if (inputStr.length == 0) {
        inputStr = str;
      } else {
        inputStr = inputStr + ',' + str;
      }
    }

    List<String> list2 = inputStr.split(',');
    //这一步要把tags里的map转成字符串数组，再加上tag才能用

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var f = await prefs.setString(historyKey, inputStr);
    //tagsString={"projectName":"韩国哈哈","createTime":"2019-08-29 10:21","remark":"","id":1567045262407,"subList":[]},{"projectName":"哈哈哈哈","createTime":"2019-08-29 10:21","remark":"","id":1567045268967,"subList":[]},
    //用自定义methodChannel保���本地化数据，不是shared_preferences

    //给userdefault保存时，最外层用;分割.
    String str1 = inputStr.replaceAll('},{"p', '};{"p');
    Map<String, dynamic> map = {
      "value": str1,
      "key": historyKey,
    };
    await methodChannel.invokeMethod('saveHistoryList', map);
  }

  void _onEvent(Object value) {
    if (value is Map) {
      Map dic = value;
      var name = dic["name"];

      if (name == "showCalendar") {}

      return;
    }
  }

  // 错误处理
  void _onError(dynamic) {}

//    var tagsString  = "";
//
//    for (int i=0;i<tags.length;i++){
//      if (tagsString.length ==0){
//        tagsString = tags[i];
//      }else{
//        tagsString = tagsString + "," + tags[i];
//      }
//    }
//
//    prefs.setString(historyKey, tagsString);

}
