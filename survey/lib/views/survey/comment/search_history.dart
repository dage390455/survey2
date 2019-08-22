///
/// Created with Android Studio.
/// User: 三帆
/// Date: 18/02/2019
/// Time: 14:19
/// email: sanfan.hx@alibaba-inc.com
/// target: 搜索WidgetDemo中的历史记录model
///

import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_go/utils/shared_preferences.dart';

class SharedPreferencesKeys {
  /// boolean
  /// 用于欢迎页面. 只有第一次访问才会显示. 或者手动将这个值设为false
  static String showWelcome = 'loginWelcone';

  /// json
  /// 用于存放搜索页的搜索数据.
  /// [{
  ///  name: 'name'
  ///
  /// }]
  static String searchHistory = 'searchHistory';
}

class SearchHistory {
  final String name;
  final String targetRouter;

  SearchHistory({@required this.name, @required this.targetRouter});
}

/// 用来做shared_preferences的存储
class SpUtil {
  static SpUtil _instance;
  static Future<SpUtil> get instance async {
    return await getInstance();
  }

  static SharedPreferences _spf;

  SpUtil._();

  Future _init() async {
    _spf = await SharedPreferences.getInstance();
  }

  static Future<SpUtil> getInstance() async {
    if (_instance == null) {
      _instance = new SpUtil._();
      await _instance._init();
    }
    return _instance;
  }

  static bool _beforeCheck() {
    if (_spf == null) {
      return true;
    }
    return false;
  }

  // 判断是否存在数据
  bool hasKey(String key) {
    Set keys = getKeys();
    return keys.contains(key);
  }

  Set<String> getKeys() {
    if (_beforeCheck()) return null;
    return _spf.getKeys();
  }

  get(String key) {
    if (_beforeCheck()) return null;
    return _spf.get(key);
  }

  getString(String key) {
    if (_beforeCheck()) return null;
    return _spf.getString(key);
  }

  Future<bool> putString(String key, String value) {
    if (_beforeCheck()) return null;
    return _spf.setString(key, value);
  }

  bool getBool(String key) {
    if (_beforeCheck()) return null;
    return _spf.getBool(key);
  }

  Future<bool> putBool(String key, bool value) {
    if (_beforeCheck()) return null;
    return _spf.setBool(key, value);
  }

  int getInt(String key) {
    if (_beforeCheck()) return null;
    return _spf.getInt(key);
  }

  Future<bool> putInt(String key, int value) {
    if (_beforeCheck()) return null;
    return _spf.setInt(key, value);
  }

  double getDouble(String key) {
    if (_beforeCheck()) return null;
    return _spf.getDouble(key);
  }

  Future<bool> putDouble(String key, double value) {
    if (_beforeCheck()) return null;
    return _spf.setDouble(key, value);
  }

  List<String> getStringList(String key) {
    return _spf.getStringList(key);
  }

  Future<bool> putStringList(String key, List<String> value) {
    if (_beforeCheck()) return null;
    return _spf.setStringList(key, value);
  }

  dynamic getDynamic(String key) {
    if (_beforeCheck()) return null;
    return _spf.get(key);
  }

  Future<bool> remove(String key) {
    if (_beforeCheck()) return null;
    return _spf.remove(key);
  }

  Future<bool> clear() {
    if (_beforeCheck()) return null;
    return _spf.clear();
  }
}

class SearchHistoryList {
  static SpUtil _sp;
  static SearchHistoryList _instance;
  static List<SearchHistory> _searchHistoryList = [];

  static SearchHistoryList _getInstance(SpUtil sp) {
    if (_instance == null) {
      _sp = sp;
      String json = sp.get(SharedPreferencesKeys.searchHistory);
      _instance = new SearchHistoryList.fromJSON(json);
    }
    return _instance;
  }

  factory SearchHistoryList([SpUtil sp]) {
    if (sp == null && _instance == null) {
      print(new ArgumentError(
          ['SearchHistoryList need instantiatied SpUtil at first timte ']));
    }
    return _getInstance(sp);
  }

//  List<SearchHistory> _searchHistoryList = [];

  // 存放的最大数量
  int _count = 10;

  SearchHistoryList.fromJSON(String jsonData) {
    _searchHistoryList = [];
    if (jsonData == null) {
      return;
    }
    List jsonList = json.decode(jsonData);
    jsonList.forEach((value) {
      _searchHistoryList.add(SearchHistory(
          name: value['name'], targetRouter: value['targetRouter']));
    });
  }

  List<SearchHistory> getList() {
    return _searchHistoryList;
  }

  clear() {
    _sp.remove(SharedPreferencesKeys.searchHistory);
    _searchHistoryList = [];
  }

  save() {
    _sp.putString(SharedPreferencesKeys.searchHistory, this.toJson());
  }

  add(SearchHistory item) {
    print("_searchHistoryList> ${_searchHistoryList.length}");
    for (SearchHistory value in _searchHistoryList) {
      if (value.name == item.name) {
        return;
      }
    }
    if (_searchHistoryList.length > _count) {
      _searchHistoryList.removeAt(0);
    }
    _searchHistoryList.add(item);
    save();
  }

  toJson() {
    List<Map<String, String>> jsonList = [];
    _searchHistoryList.forEach((SearchHistory value) {
      jsonList.add({'name': value.name, 'targetRouter': value.targetRouter});
    });
    return json.encode(jsonList);
  }

  @override
  String toString() {
    return this.toJson();
  }
}
