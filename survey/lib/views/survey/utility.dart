import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/services.dart';

class UtilityPage {
  void showToast(String msg) {
    if (Platform.isIOS) {
      const methodChannel = const MethodChannel('com.pages.your/project_list');
      Map<String, dynamic> map = {
        "message": msg,
      };
      methodChannel.invokeMethod('showToast', map);
    }

    return;
  }
}
