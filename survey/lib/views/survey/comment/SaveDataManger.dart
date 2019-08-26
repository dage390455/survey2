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
      const MethodChannel('com.pages.your/history_list');

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

    print("---------------" + f.toString());
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

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var history = prefs.getString(historyKey);
    if (history != null && history.length > 0) {
      return history.split(",");
    }
    return List<String>();
  }

  static addHistory(String tag, String historyKey) async {
    var history = await SaveDataManger.getHistory(historyKey);

    if (!history.contains(tag)) {
      history.add(tag);

      SaveDataManger.saveHistory(history, historyKey);
    }
  }

  //修改已存储的内容，编辑模式
  static replaceHistory(String tag, String historyKey, int id) async {
    var history = await SaveDataManger.getHistory(historyKey);
    for (String str in history) {
      String str1 = str.replaceAll(';', ',');
      Map<String, dynamic> map = json.decode(str1);
      int id1 = map["id"].toInt();
      //替换
      if (id == id1) {
        history.remove(str);
        history.add(tag);
        SaveDataManger.saveHistory(history, historyKey);
      }
    }

    // if (!history.contains(tag)) {
    //   history.add(tag);
    //   SaveDataManger.saveHistory(history, historyKey);
    // }
  }

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
