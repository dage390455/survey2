import 'package:flutter/cupertino.dart' show Color;
import 'package:flutter/material.dart';
import 'dart:ui';

Color BLACK_TEXT_COLOR = Colors.black;
Color TITLE_TEXT_COLOR = Color(0xFF1DBB99);
Color NORMAL_TEXT_COLOR = Color(0xFF252525);
Color LIGHT_TEXT_COLOR = Color(0xFFA6A6A6);
Color PLACEHOLDER_TEXT_COLOR = Color(0xFF888888);
Color TEST_COLOR = Color(0xFF8058A5);
Color LINE_COLOR = Color(0xFFDFDFDF);
Color LINE_DARK_COLOR = Color(0xFFB6B6B6);
Color RED_COLOR = Color(0xFFF34A4A6);
Color LIGHT_LINE_COLOR = Color(0xFFF4F4F4);
Color FENGE_LINE_COLOR = Color(0xFFDFDFDF);
Color GREEN_COLOR = Color(0xFF1DBB99);

// Colors
const Color blueLogin = Color.fromRGBO(30, 182, 218, 1.0);
const Color blueSwitch = Color.fromRGBO(0, 162, 185, 1.0);
const Color blueSendMail = Color.fromRGBO(61, 60, 219, 1.0);
const Color blueGenerateReport = Color.fromRGBO(30, 131, 147, 1.0);

const String appName = "Sensoro-City";
const String appBarTitle = "Sensoro-City";
const String appVersion = "1.0";
const String yearCopyright = "2019";
bool isEnglish = false;

double screen_height = window.physicalSize.height;
double screen_width = window.physicalSize.width;

String refresh_localString = "刷新";
String loadMore_localString = "加载";
String pullToRefresh_localString = "下拉刷新";
String releaseToRefresh_localString = "释放刷新";
String refreshing_localString = "正在刷新";
String refreshFinish_localString = "刷新完成";
String refreshed_localString = "刷新结束";
String pushToLoad_localString = "上拉加载";
String releaseToLoad_localString = "释放加载";
String loading_localString = "正在加载";
String loadFinish_localString = "加载完成";
String loaded_localString = "加载结束";
String noMore_localString = "没有更多数据";
String lastPage_localString = "已经是最后一页了";
String updateAt_localString = "更新于 %T";
String autoLoad_localString = "自动加载";
String autoLoadDescribe_localString = "滑到底部自动刷新";

void setIsEnglish(bool isEnglish) {
  if (isEnglish) {
    refresh_localString = "Refresh";
    loadMore_localString = "Loading";
    pullToRefresh_localString = "Pull to refresh";
    releaseToRefresh_localString = "Release to refresh";
    refreshing_localString = "Refreshing";
    refreshFinish_localString = "Refresh finish";
    refreshed_localString = "Refresh finished";
    pushToLoad_localString = "Push to load";
    releaseToLoad_localString = "Release to load";
    loading_localString = "Loading";
    loadFinish_localString = "Load finish";
    loaded_localString = "Load finish";
    noMore_localString = "No more";
    lastPage_localString = "The last page";
    updateAt_localString = "Update at %T";
    autoLoad_localString = "Auto load";
    autoLoadDescribe_localString = "To bottoom auto refresh";
  }
}

int currentTimeMillis() {
  return new DateTime.now().millisecondsSinceEpoch;
}

// public static let SELECTED_COLOR = UIColor.fromRGB(0x1DBB99); //原来29C093   替换为 1DBB99
//     public static let TITLE_TEXT_COLOR = UIColor.fromRGB(0x252525);//原来为030303，统一替换为252525.
//     public static let NORMAL_TEXT_COLOR = UIColor.fromRGB(0x252525);
//     public static let LIGHT_TEXT_COLOR = UIColor.fromRGB(0xA6A6A6);
//     public static let PLACEHOLDER_TEXT_COLOR = UIColor.fromRGB(0x888888);
//     public static let ALARM_LOG_TEXT_COLOR = UIColor.fromRGB(0x626262);
//  public static let BACK_COLOR = UIColor.fromRGB(0xF4F4F4);
//     public static let SUBVIEW_BACK_COLOR = UIColor.fromRGB(0xFAFAFA);
//     public static let MENU_ICON_COLOR = UIColor.fromRGB(0xB6B6B6);
//     public static let HEADER_BACK_COLOR = UIColor.white;
//     public static let DISABLE_BACK_COLOR = UIColor.fromRGB(0xDFDFDF);
//     public static let FILL_COLOR = UIColor.fromRGB(0xFAFAFA)

//     public static let SEARCH_ITEM_BACK_COLOR = UIColor.fromRGB(0xE7E7E7);
//     public static let RED_COLOR = UIColor.fromRGB(0xF34A4A);
