package com.sensoro.survey;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;
import android.view.WindowManager;
import android.widget.Toast;


import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.StringCodec;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.view.FlutterNativeView;
import io.flutter.view.FlutterView;

public class MainActivity extends FlutterActivity {


    private String routeStr = "projectList";  //首页路径
    BasicMessageChannel channel1;
    private final int MAPCODE = 111;

    @Override
    public FlutterView createFlutterView(Context context) {

        WindowManager.LayoutParams matchParent = new WindowManager.LayoutParams(-1, -1);
        FlutterNativeView nativeView = this.createFlutterNativeView();
        FlutterView flutterView = new FlutterView(MainActivity.this, null, nativeView);
        flutterView.setInitialRoute(routeStr);
        flutterView.setLayoutParams(matchParent);
        flutterView.enableTransparentBackground();
        this.setContentView(flutterView);
        final BasicMessageChannel channel = new BasicMessageChannel<String>(flutterView, "BasicMessageChannelPlugin", StringCodec.INSTANCE);
        channel.setMessageHandler((o, reply) -> {


            if (ContextCompat.checkSelfPermission(MainActivity.this, Manifest.permission.ACCESS_FINE_LOCATION)
                    != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, 200);
            } else {
                Intent intent = new Intent(MainActivity.this, DeployMapActivity.class);
                startActivityForResult(intent, MAPCODE);
            }
            reply.reply("我来自 " + " !! 使用的是 BasicMessageChannel 方式");
        });
        channel1 = channel;


        return flutterView;
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (resultCode == RESULT_OK) {
            if (requestCode == MAPCODE) {
                double latitude = data.getDoubleExtra("latitude", -1);
                double longitude = data.getDoubleExtra("longitude", -1);
                String title = data.getStringExtra("title");
                channel1.send(title);
//                Log.d("===title", "title------- = " + title + ",latitude = =" + latitude + "==longitude==" + longitude);
            }
        }


    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        switch (requestCode) {
            case 200:
                if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    Intent intent = new Intent(MainActivity.this, DeployMapActivity.class);
                    startActivityForResult(intent, MAPCODE);
                } else {
                    Toast.makeText(MainActivity.this, "未开启定位权限,请手动到设置去开启权限", Toast.LENGTH_LONG).show();
                }
                break;
            default:
                break;
        }
    }

    public void sendMessageToFlutter() {
        channel1.send("哈哈哈");
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

    }


}
