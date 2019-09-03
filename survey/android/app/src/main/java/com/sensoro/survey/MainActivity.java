package com.sensoro.survey;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.WindowManager;
import android.widget.Toast;


import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.tencent.mm.opensdk.modelmsg.GetMessageFromWX;
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX;
import com.tencent.mm.opensdk.modelmsg.WXMediaMessage;
import com.tencent.mm.opensdk.modelmsg.WXTextObject;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import java.util.Collection;
import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StringCodec;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.view.FlutterNativeView;
import io.flutter.view.FlutterView;

import static com.tencent.mm.opensdk.modelmsg.SendMessageToWX.Req.WXSceneSession;

public class MainActivity extends FlutterActivity {

    public static IWXAPI api;

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


        new MethodChannel(flutterView, "com.pages.your/project_list").setMethodCallHandler(
                (call, result) -> {
                    //调用分享
                    if (call.method.equals("outputDocument")) {
                        boolean wxAppInstalled = api.isWXAppInstalled();
                        if (wxAppInstalled) {
                            Map<String, Map> map = (Map) call.arguments;
                            Map value = null;
                            for (String key : map.keySet()) {
                                value = map.get(key);
                                System.out.println(key + ":" + value);
                            }
                            if (null != value) {
                                WXTextObject textObj = new WXTextObject();
                                textObj.text = value.toString();
                                WXMediaMessage msg = new WXMediaMessage();
                                msg.mediaObject = textObj;
                                msg.description = value.toString();
                                SendMessageToWX.Req req = new SendMessageToWX.Req();
                                req.transaction = String.valueOf(System.currentTimeMillis());
                                req.message = msg;
                                req.scene = WXSceneSession;
                                api.sendReq(req);
                            }
                        } else {
                            Toast.makeText(MainActivity.this, "当前手机未安装微信，请安装后重试", Toast.LENGTH_SHORT).show();
                        }

                    }
                });


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
                if (!TextUtils.isEmpty(title)) {
                    channel1.send(title);
                }
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


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        api = WXAPIFactory.createWXAPI(this, Constants.APP_ID, false);
        api.registerApp(Constants.APP_ID);
    }


}
