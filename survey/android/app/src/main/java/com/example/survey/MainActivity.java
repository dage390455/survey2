package com.example.survey;

import android.content.Context;
import android.os.Bundle;
import android.view.WindowManager;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.view.FlutterNativeView;
import io.flutter.view.FlutterView;

public class MainActivity extends FlutterActivity {


  private String routeStr = "projectList";  //首页路径

  @Override
  public FlutterView createFlutterView(Context context) {

    WindowManager.LayoutParams matchParent = new WindowManager.LayoutParams(-1, -1);
    FlutterNativeView nativeView = this.createFlutterNativeView();
    FlutterView flutterView = new FlutterView(MainActivity.this, null, nativeView);
    flutterView.setInitialRoute(routeStr);
    flutterView.setLayoutParams(matchParent);
    flutterView.enableTransparentBackground();
    this.setContentView(flutterView);
    return flutterView;
  }
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
  }


}
