package com.sensoro.survey;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.WindowManager;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.StringCodec;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.view.FlutterNativeView;
import io.flutter.view.FlutterView;

public class MainActivity extends FlutterActivity {


  private String routeStr = "projectList";  //首页路径
  BasicMessageChannel channel1;
  @Override
  public FlutterView createFlutterView(Context context) {

    WindowManager.LayoutParams matchParent = new WindowManager.LayoutParams(-1, -1);
    FlutterNativeView nativeView = this.createFlutterNativeView();
    FlutterView flutterView = new FlutterView(MainActivity.this, null, nativeView);
    flutterView.setInitialRoute(routeStr);
    flutterView.setLayoutParams(matchParent);
    flutterView.enableTransparentBackground();
    this.setContentView(flutterView);
      final BasicMessageChannel channel = new BasicMessageChannel<String> (flutterView, "BasicMessageChannelPlugin", StringCodec.INSTANCE);
      channel.setMessageHandler(new BasicMessageChannel.MessageHandler() {
          @Override
          public void onMessage(Object o, BasicMessageChannel.Reply reply) {

              Intent intent = new Intent(MainActivity.this,LocationEdtitActivtiy.class);
              startActivity(intent);

//              sendMessageToFlutter();
              reply.reply("我来自 " +" !! 使用的是 BasicMessageChannel 方式");
          }
      });
     channel1 = channel;


    return flutterView;
  }


  public void sendMessageToFlutter(){
     channel1.send("哈哈哈");
  }

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
  }


}
