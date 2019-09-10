package com.sensoro.survey;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.StrictMode;
import android.text.TextUtils;
import android.util.Log;
import android.view.WindowManager;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.tencent.mm.opensdk.modelmsg.SendMessageToWX;
import com.tencent.mm.opensdk.modelmsg.WXFileObject;
import com.tencent.mm.opensdk.modelmsg.WXMediaMessage;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StringCodec;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.view.FlutterNativeView;
import io.flutter.view.FlutterView;
import jxl.read.biff.BiffException;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WriteException;
import me.zhouzhuo.zzexcelcreator.ZzExcelCreator;
import me.zhouzhuo.zzexcelcreator.ZzFormatCreator;

public class MainActivity extends FlutterActivity {

    public static IWXAPI api;

    private String routeStr = "projectList";  //首页路径
    BasicMessageChannel channel1;
    private final int MAPCODE = 111;
    private static final String PATH = Environment.getExternalStorageDirectory().getAbsolutePath() + "/AAAAAAAA/";
    private String filename;

    private Map<String, Map> map;

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
                        filename = "升哲勘察" + System.currentTimeMillis() + ".txt";
                        boolean wxAppInstalled = api.isWXAppInstalled();
                        if (wxAppInstalled) {

                            if (null == call.arguments) {
                                map = null;
                                return;
                            }
                            map = (Map) call.arguments;
                            if (Build.VERSION.SDK_INT >= 23) {
                                if (checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                                    requestPermissions(new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 0x01);
                                } else {

                                    createAndShareExcel(map);
                                }
                            } else {
                                createAndShareExcel(map);


                            }

                        }


                    } else {
                        Toast.makeText(MainActivity.this, "当前手机未安装微信，请安装后重试", Toast.LENGTH_SHORT).show();

                    }
                });


        final BasicMessageChannel channel = new BasicMessageChannel<String>(flutterView, "BasicMessageChannelPlugin", StringCodec.INSTANCE);
        channel.setMessageHandler((o, reply) ->

        {


            if (ContextCompat.checkSelfPermission(MainActivity.this, Manifest.permission.ACCESS_FINE_LOCATION)
                    != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, 200);
            } else {

                if (o != null) {
                    String location = o + "";
                    String[] strArr = location.split(",");
                    Intent intent = new Intent(MainActivity.this, DeployMapActivity.class);
                    if (strArr.length >= 3) {
                        intent.putExtra("isReadOnly", strArr[0]);
                        intent.putExtra("lan", strArr[1]);
                        intent.putExtra("log", strArr[2]);

                    }
                    startActivityForResult(intent, MAPCODE);
                }


            }
            reply.reply("我来自 " + " !! 使用的是 BasicMessageChannel 方式");
        });
        channel1 = channel;


        return flutterView;
    }


    //向指定的文件中写入指定的数据
    public void writeFileData(String filename, String content) {

        try {
            File file = new File(filename);
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }
            RandomAccessFile raf = new RandomAccessFile(file, "rwd");
            raf.seek(file.length());
            raf.write(content.getBytes());
            raf.close();
        } catch (Exception e) {
            Log.e("TestFile", "Error on write File:" + e);
        }
    }

    /**
     * 分享文件
     *
     * @param context
     * @param path
     */
    public static void shareFile(Context context, String path) {
        if (TextUtils.isEmpty(path)) {
            return;
        }

        checkFileUriExposure();

        Intent intent = new Intent(Intent.ACTION_SEND);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.putExtra(Intent.EXTRA_STREAM, Uri.fromFile(new File(path)));  //传输图片或者文件 采用流的方式
        intent.setType("*/*");   //分享文件
        context.startActivity(Intent.createChooser(intent, "分享"));
    }

    /**
     * 分享前必须执行本代码，主要用于兼容SDK18以上的系统
     */
    private static void checkFileUriExposure() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
            StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
            StrictMode.setVmPolicy(builder.build());
            builder.detectFileUriExposure();
        }
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
                    String location = latitude + "," + longitude + "," + title;
                    channel1.send(location);
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

            case 0x01:
                if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {


                    createAndShareExcel(map);
                } else {

                    Toast.makeText(MainActivity.this, "请手动到设置去开启存储权限", Toast.LENGTH_LONG).show();

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

    public byte[] inputStreamToByte(String path) {
        try {
            FileInputStream fis = new FileInputStream(path);
            ByteArrayOutputStream bytestream = new ByteArrayOutputStream();
            int ch;
            while ((ch = fis.read()) != -1) {
                bytestream.write(ch);
            }
            byte imgdata[] = bytestream.toByteArray();
            bytestream.close();
            return imgdata;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    private void createAndShareExcel(Map<String, Map> map) {
        try {

            if (null == map) {
                return;
            }
            Map value = null;
            for (String key : map.keySet()) {
                value = map.get(key);
                System.out.println(key + ":" + value);
            }


            new AsyncTask<String, Void, Integer>() {
                @Override
                protected Integer doInBackground(String... params) {
                    writeFileData(PATH + filename, JsonFormater.format(map.toString()));
                    return 1;
                }

                @Override
                protected void onPostExecute(Integer aVoid) {
                    super.onPostExecute(aVoid);
                    if (aVoid == 1) {

                        WXFileObject fileObj = new WXFileObject();
                        fileObj.fileData = inputStreamToByte(PATH + filename);//文件路径  
                        fileObj.filePath = PATH + filename;

                        //使用媒体消息分享  
                        WXMediaMessage msg = new WXMediaMessage(fileObj);

                        msg.title = filename;
                        //发送请求  
                        SendMessageToWX.Req req = new SendMessageToWX.Req();
                        //创建唯一标识  
                        req.transaction = String.valueOf(System.currentTimeMillis());
                        req.message = msg;
                        req.scene = SendMessageToWX.Req.WXSceneSession;

                        api.sendReq(req);
                    } else {
                        Toast.makeText(MainActivity.this, "插入失败！", Toast.LENGTH_SHORT).show();
                    }
                }
            }.execute();


//            final String col = "1";
//            final String row = "1";
//            final String str = "valuevaluevaluevalue";
//
//
//            new AsyncTask<String, Void, Integer>() {
//
//                @Override
//                protected Integer doInBackground(String... params) {
//                    try {
//
//
//                        ZzExcelCreator
//                                .getInstance().createExcel(PATH, filename)
//                                .createSheet("测试1").close();
//
//                        ZzExcelCreator
//                                .getInstance()
//                                .openExcel(new File(PATH + filename + ".xls"))  //打开Excel文件
//                                .openSheet(0)                                   //打开Sheet工作表
//                                .close();
//                        //设置单元格内容格式
//                        WritableCellFormat format = ZzFormatCreator
//                                .getInstance()
//                                .createCellFont(WritableFont.ARIAL)  //设置字体
//                                .setAlignment(Alignment.CENTRE, VerticalAlignment.CENTRE)  //设置对齐方式(水平和垂直)
//                                .setFontSize(14)                    //设置字体大小
//                                .setFontColor(Colour.ROSE)          //设置字体颜色
//                                .getCellFormat();
//
//
//                        ZzExcelCreator
//                                .getInstance().openExcel(new File(PATH + filename + ".xls"))
//                                .openSheet(0)
//                                .setColumnWidth(1, 25)
//                                .setRowHeight(1, 400)
//                                .fillContent(Integer.parseInt(col), Integer.parseInt(row), str, format)
//                                .close();
//                        return 1;
//                    } catch (IOException | WriteException | BiffException e) {
//                        e.printStackTrace();
//                        return 0;
//                    }
//                }
//
//                @Override
//                protected void onPostExecute(Integer aVoid) {
//                    super.onPostExecute(aVoid);
//                    if (aVoid == 1) {
//                        WXFileObject fileObj = new WXFileObject();
//                        fileObj.fileData = inputStreamToByte(PATH + filename + ".xls");//文件路径  
//                        fileObj.filePath = PATH + filename + ".xls";
//
//                        //使用媒体消息分享  
//                        WXMediaMessage msg = new WXMediaMessage(fileObj);
//
//                        msg.title = filename + ".xls";
//                        //发送请求  
//                        SendMessageToWX.Req req = new SendMessageToWX.Req();
//                        //创建唯一标识  
//                        req.transaction = String.valueOf(System.currentTimeMillis());
//                        req.message = msg;
//                        req.scene = SendMessageToWX.Req.WXSceneSession;
//
//                        api.sendReq(req);
//                        Toast.makeText(MainActivity.this, "插入成功！", Toast.LENGTH_SHORT).show();
//                    } else {
//                        Toast.makeText(MainActivity.this, "插入失败！", Toast.LENGTH_SHORT).show();
//                    }
//                }
//            }.execute(col, row, str);


        } catch (Exception e) {
            e.printStackTrace();
        }
    }


}
