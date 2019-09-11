package com.sensoro.survey;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.text.TextUtils;
import android.util.Log;
import android.view.WindowManager;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.google.gson.Gson;
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX;
import com.tencent.mm.opensdk.modelmsg.WXFileObject;
import com.tencent.mm.opensdk.modelmsg.WXMediaMessage;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.List;
import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StringCodec;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.view.FlutterNativeView;
import io.flutter.view.FlutterView;
import jxl.Workbook;
import jxl.write.Label;
import jxl.write.WritableImage;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;

public class MainActivity extends FlutterActivity {

    public static IWXAPI api;

    private String routeStr = "projectList";  //首页路径
    BasicMessageChannel channel1;
    private final int MAPCODE = 111;
    private static final String PATH = Environment.getExternalStorageDirectory().getAbsolutePath() + "/AAAAAAAA/";
    private String filename;

    private Map<String, Map> map;
    WritableWorkbook wbook = null;

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
                        filename = "升哲勘察" + System.currentTimeMillis();
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

                        } else {
                            Toast.makeText(MainActivity.this, "当前手机未安装微信，请安装后重试", Toast.LENGTH_SHORT).show();

                        }


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

            JSONObject jsonObj = new JSONObject(map);

            Detail detail = getDetail(jsonObj.toString());


            if (null != detail) {


                new AsyncTask<String, Void, Integer>() {

                    @Override
                    protected Integer doInBackground(String... params) {
                        try {


                            String filenameTemp = PATH + filename + ".xls";
                            File file = new File(PATH);
                            if (!file.exists()) {
                                try {
                                    //按照指定的路径创建文件夹
                                    file.mkdirs();
                                } catch (Exception e) {
                                    // TODO: handle exception
                                }
                            }
                            File dir = new File(filenameTemp);
                            if (!dir.exists()) {
                                try {
                                    //在指定的文件夹中创建文件
                                    dir.createNewFile();
                                } catch (Exception e) {
                                }
                            }


                            WritableWorkbook wbook = Workbook.createWorkbook(new File(filenameTemp));
                            WritableSheet sheet = wbook.createSheet("升哲勘察", 0);

                            //获取sheet对象
                            //初始化行
                            int row = 0;
                            //初始化列
                            int col = 0;
                            col = 0;





                            String createTime = detail.getJson().getCreateTime();
                            String remark = detail.getJson().getRemark();
                            String projectName = detail.getJson().getProjectName();


                            sheet.addCell(new Label(0, row++, "工程名"));
                            sheet.addCell(new Label(0, row++, "创建时间"));
                            sheet.addCell(new Label(0, row++, "项目备注"));


                            row = 0;
                            sheet.addCell(new Label(1, row++, projectName));
                            sheet.addCell(new Label(1, row++, createTime));
                            sheet.addCell(new Label(1, row++, remark));


                            List<Detail.JsonBean.SubListBean> subList = detail.getJson().getSubList();

                            for (Detail.JsonBean.SubListBean subListBean : subList) {

//                                long electricalFireId = subListBean.getElectricalFireId();
//                                sheet.addCell(new Label(0, ++row, "id"));
//                                sheet.addCell(new Label(1, row, electricalFireId + ""));

                                String editName = subListBean.getEditName();
                                if (!TextUtils.isEmpty(editName)) {
                                    sheet.addCell(new Label(0, ++row, "勘察点信息"));
                                    sheet.addCell(new Label(1, row, editName));
                                }

                                String editPurpose = subListBean.editPurpose;
                                if (!TextUtils.isEmpty(editPurpose)) {
                                    sheet.addCell(new Label(0, ++row, "勘察点用途"));
                                    sheet.addCell(new Label(1, row, editPurpose));
                                }

                                String address = subListBean.getEditAddress();
                                if (!TextUtils.isEmpty(address)) {
                                    sheet.addCell(new Label(0, ++row, "具体地址"));
                                    sheet.addCell(new Label(1, row, address));
                                }

                                String editLongitudeLatitude = subListBean.getEditLongitudeLatitude();
                                if (!TextUtils.isEmpty(editLongitudeLatitude)) {
                                    sheet.addCell(new Label(0, ++row, "定位位置"));
                                    sheet.addCell(new Label(1, row, editLongitudeLatitude));
                                }
                                String editPointStructure = subListBean.getEditPointStructure();

                                if (!TextUtils.isEmpty(editPointStructure)) {
                                    sheet.addCell(new Label(0, ++row, "勘察点结构"));
                                    sheet.addCell(new Label(1, row, editName));
                                }
                                String editPointArea = subListBean.getEditPointArea();

                                if (!TextUtils.isEmpty(editPointArea)) {
                                    sheet.addCell(new Label(0, ++row, "勘察点面积"));
                                    sheet.addCell(new Label(1, row, editName));
                                }

                                String bossName = subListBean.getBossName();

                                if (!TextUtils.isEmpty(bossName)) {
                                    sheet.addCell(new Label(0, ++row, "老板名字"));
                                    sheet.addCell(new Label(1, row, bossName));
                                }
                                String bossPhone = subListBean.getBossPhone();
                                if (!TextUtils.isEmpty(bossPhone)) {
                                    sheet.addCell(new Label(0, ++row, "老板电话"));
                                    sheet.addCell(new Label(1, row, bossPhone));
                                }




                                String editenvironmentpic1 = subListBean.getEditenvironmentpic1();
                                if (!TextUtils.isEmpty(editenvironmentpic1)) {
                                    sheet.addCell(new Label(0, ++row, "环境第一张图片"));
                                    Bitmap compressBm = getCompressBm(editenvironmentpic1, 800, 1024);
                                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                                    compressBm.compress(Bitmap.CompressFormat.PNG, 75, baos);
                                    WritableImage image = new WritableImage(1, row, 1, 1, baos.toByteArray());
                                    sheet.setRowView(row, 1700, false); //设置行高
                                    sheet.addImage(image);
                                }


                                String editenvironmentpic2 = subListBean.getEditenvironmentpic2();
                                if (!TextUtils.isEmpty(editenvironmentpic2)) {
                                    sheet.addCell(new Label(0, ++row, "环境第二张图片"));
                                    Bitmap compressBm = getCompressBm(editenvironmentpic2, 800, 1024);
                                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                                    compressBm.compress(Bitmap.CompressFormat.PNG, 75, baos);
                                    WritableImage image = new WritableImage(1, row, 1, 1, baos.toByteArray());
                                    sheet.setRowView(row, 1700, false); //设置行高
                                    sheet.addImage(image);
                                }


                                String editenvironmentpic3 = subListBean.getEditenvironmentpic3();

                                if (!TextUtils.isEmpty(editenvironmentpic3)) {
                                    sheet.addCell(new Label(0, ++row, "环境第三张图片"));
                                    Bitmap compressBm = getCompressBm(editenvironmentpic3, 800, 1024);
                                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                                    compressBm.compress(Bitmap.CompressFormat.PNG, 75, baos);
                                    WritableImage image = new WritableImage(1, row, 1, 1, baos.toByteArray());
                                    sheet.setRowView(row, 1700, false); //设置行高
                                    sheet.addImage(image);
                                }
                                String editenvironmentpic4 = subListBean.getEditenvironmentpic4();

                                if (!TextUtils.isEmpty(editenvironmentpic4)) {
                                    sheet.addCell(new Label(0, ++row, "环境第四张图片"));
                                    Bitmap compressBm = getCompressBm(editenvironmentpic4, 800, 1024);
                                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                                    compressBm.compress(Bitmap.CompressFormat.PNG, 75, baos);
                                    WritableImage image = new WritableImage(1, row, 1, 1, baos.toByteArray());
                                    sheet.setRowView(row, 1700, false); //设置行高
                                    sheet.addImage(image);
                                }
                                String editenvironmentpic5 = subListBean.getEditenvironmentpic5();
                                if (!TextUtils.isEmpty(editenvironmentpic5)) {
                                    sheet.addCell(new Label(0, ++row, "环境第五张图片"));
                                    Bitmap compressBm = getCompressBm(editenvironmentpic5, 800, 1024);
                                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                                    compressBm.compress(Bitmap.CompressFormat.PNG, 75, baos);
                                    WritableImage image = new WritableImage(1, row, 1, 1, baos.toByteArray());
                                    sheet.setRowView(row, 1700, false); //设置行高
                                    sheet.addImage(image);
                                }






                                String editOutsinPic = subListBean.getEditOutsinPic();
                                if (!TextUtils.isEmpty(editOutsinPic)) {
                                    sheet.addCell(new Label(0, ++row, "外箱安装位置图片"));

                                    Bitmap compressBm = getCompressBm(editOutsinPic, 800, 1024);
                                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                                    compressBm.compress(Bitmap.CompressFormat.PNG, 75, baos);
                                    WritableImage image = new WritableImage(1, row, 1, 1, baos.toByteArray());
                                    sheet.setRowView(row, 1700, false); //设置行高
                                    sheet.addImage(image);
                                }
                                String editpic1 = subListBean.getEditpic1();

                                if (!TextUtils.isEmpty(editpic1)) {
                                    sheet.addCell(new Label(0, ++row, "电箱图片1"));
                                    Bitmap compressBm = getCompressBm(editpic1, 800, 1024);
                                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                                    compressBm.compress(Bitmap.CompressFormat.PNG, 75, baos);
                                    WritableImage image = new WritableImage(1, row, 1, 1, baos.toByteArray());
                                    sheet.setRowView(row, 1700, false); //设置行高
                                    sheet.addImage(image);
                                }
                                String editpic2 = subListBean.getEditpic2();

                                if (!TextUtils.isEmpty(editpic2)) {
                                    sheet.addCell(new Label(0, ++row, "电箱图片2"));
                                    Bitmap compressBm = getCompressBm(editpic2, 800, 1024);
                                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                                    compressBm.compress(Bitmap.CompressFormat.PNG, 75, baos);
                                    WritableImage image = new WritableImage(1, row, 1, 1, baos.toByteArray());
                                    sheet.setRowView(row, 1700, false); //设置行高
                                    sheet.addImage(image);
                                }
                                String editpic3 = subListBean.getEditpic3();


                                if (!TextUtils.isEmpty(editpic3)) {
                                    sheet.addCell(new Label(0, ++row, "电箱图片3"));
                                    Bitmap compressBm = getCompressBm(editpic3, 800, 1024);
                                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                                    compressBm.compress(Bitmap.CompressFormat.PNG, 75, baos);
                                    WritableImage image = new WritableImage(1, row, 1, 1, baos.toByteArray());
                                    sheet.setRowView(row, 1700, false); //设置行高
                                    sheet.addImage(image);
                                }
                                String editpic4 = subListBean.getEditpic4();


                                if (!TextUtils.isEmpty(editpic4)) {
                                    sheet.addCell(new Label(0, ++row, "电箱图片4"));
                                    Bitmap compressBm = getCompressBm(editpic4, 800, 1024);
                                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                                    compressBm.compress(Bitmap.CompressFormat.PNG, 75, baos);
                                    WritableImage image = new WritableImage(1, row, 1, 1, baos.toByteArray());
                                    sheet.setRowView(row, 1700, false); //设置行高
                                    sheet.addImage(image);
                                }
                                String editpic5 = subListBean.getEditpic5();

                                if (!TextUtils.isEmpty(editpic5)) {
                                    sheet.addCell(new Label(0, ++row, "电箱图片5"));
                                    Bitmap compressBm = getCompressBm(editpic5, 800, 1024);
                                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                                    compressBm.compress(Bitmap.CompressFormat.PNG, 75, baos);
                                    WritableImage image = new WritableImage(1, row, 1, 1, baos.toByteArray());
                                    sheet.setRowView(row, 1700, false); //设置行高
                                    sheet.addImage(image);
                                }

                                String editPosition = subListBean.getEditPosition();

                                if (!TextUtils.isEmpty(editPosition)) {
                                    sheet.addCell(new Label(0, ++row, "定位地址"));
                                    sheet.addCell(new Label(1, row, editName));
                                }
                                String editPurpose = subListBean.getEditPurpose();
                                if (!TextUtils.isEmpty(editPurpose)) {
                                    sheet.addCell(new Label(0, ++row, "勘察点用途"));
                                    sheet.addCell(new Label(1, row, editName));
                                }


                                int isNeedCarton = subListBean.getIsNeedCarton();
                                sheet.addCell(new Label(0, ++row, "是否需要外箱"));
                                sheet.addCell(new Label(1, row, isNeedCarton == 1 ? "是" : "否"));


                                int isOutSide = subListBean.getIsOutSide();
                                sheet.addCell(new Label(0, ++row, "电箱位置"));
                                sheet.addCell(new Label(1, row, isOutSide == 1 ? "户外" : "室内"));


                                int needLadder = subListBean.isNeedLadder;
                                sheet.addCell(new Label(0, ++row, "是否需要梯子"));
                                sheet.addCell(new Label(1, row, needLadder == 1 ? "需要" : "不需要"));


                                int isEffectiveTransmission = subListBean.isEffectiveTransmission;
                                sheet.addCell(new Label(0, ++row, "报警音可否有效传播"));
                                sheet.addCell(new Label(1, row, isEffectiveTransmission == 1 ? "是" : "否"));


                                int isNuisance = subListBean.isNuisance;
                                sheet.addCell(new Label(0, ++row, "是否扰民"));
                                sheet.addCell(new Label(1, row, isNuisance == 1 ? "是" : "否"));


                                int isNoiseReduction = subListBean.isNoiseReduction;
                                sheet.addCell(new Label(0, ++row, "是否有专人消音"));
                                sheet.addCell(new Label(1, row, isNoiseReduction == 1 ? "是" : "否"));


                                int allOpenValue = subListBean.allOpenValue;
                                sheet.addCell(new Label(0, ++row, "空开层级"));
                                sheet.addCell(new Label(1, row, allOpenValue == 1 ? "总空开" : "分空开"));


                                int isSingle = subListBean.isSingle;
                                sheet.addCell(new Label(0, ++row, "空开类型"));
                                sheet.addCell(new Label(1, row, isSingle == 1 ? "单相电" : "三相电"));
                                int isMolded = subListBean.isMolded;
                                sheet.addCell(new Label(0, ++row, "空开类型"));
                                sheet.addCell(new Label(1, row, isMolded == 1 ? "微断" : "塑壳"));

                                int isZhiHui = subListBean.isZhiHui;
                                sheet.addCell(new Label(0, ++row, "适用类型"));
                                sheet.addCell(new Label(1, row, isZhiHui == 1 ? "智慧空开（支持通断）" : "电器火灾（不支持通断）"));


                                String current = subListBean.getCurrent();
                                if (!TextUtils.isEmpty(current)) {
                                    sheet.addCell(new Label(0, ++row, "额定电流"));
                                    sheet.addCell(new Label(1, row, current));
                                }

                                String currentSelect = subListBean.getCurrentSelect();
                                if (!TextUtils.isEmpty(currentSelect)) {
                                    sheet.addCell(new Label(0, ++row, "额定电流"));
                                    sheet.addCell(new Label(1, row, currentSelect));
                                }

                                String dangerous = subListBean.getDangerous();
                                if (!TextUtils.isEmpty(dangerous)) {
                                    sheet.addCell(new Label(0, ++row, "危险线路数"));
                                    sheet.addCell(new Label(1, row, dangerous));
                                }
                                String probeNumber = subListBean.probeNumber;
                                if (!TextUtils.isEmpty(probeNumber)) {
                                    sheet.addCell(new Label(0, ++row, "温度探头数"));
                                    sheet.addCell(new Label(1, row, probeNumber));
                                }
                                String recommendedTransformer = subListBean.recommendedTransformer;
                                if (!TextUtils.isEmpty(recommendedTransformer)) {
                                    sheet.addCell(new Label(0, ++row, "漏电互感器规格"));
                                    sheet.addCell(new Label(1, row, recommendedTransformer));
                                }


                            }


//                            Bitmap compressBm = getCompressBm("/storage/emulated/0/Android/data/com.sensoro.survey/files/Pictures/scaled_681e8487-1669-4996-b278-52342464831f6149127435123271730.jpg", 800, 1024);
//                            ByteArrayOutputStream baos = new ByteArrayOutputStream();
//                            compressBm.compress(Bitmap.CompressFormat.PNG, 75, baos);


//                            WritableImage image = new WritableImage(col++, row, 1, 1, baos.toByteArray());

//                            sheet.setRowView(row, 1700, false); //设置行高
                            // 把图片插入到sheet
//                            sheet.addImage(image);
                            wbook.write();
                            wbook.close();

                            Log.e("Tag======", "====" + file.length());

                            return 1;
                        } catch (IOException | WriteException e) {
                            e.printStackTrace();
                            return 0;
                        } finally {
                            try {
                                if (wbook != null) {
                                    wbook.close();
                                }
                            } catch (WriteException e) {
                                e.printStackTrace();
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        }
                    }

                    @Override
                    protected void onPostExecute(Integer aVoid) {
                        super.onPostExecute(aVoid);
                        if (aVoid == 1) {
                            WXFileObject fileObj = new WXFileObject();
                            fileObj.filePath = PATH + filename + ".xls";
                            //使用媒体消息分享  
                            WXMediaMessage msg = new WXMediaMessage(fileObj);
                            msg.title = filename + ".xls";
                            //发送请求  
                            SendMessageToWX.Req req = new SendMessageToWX.Req();
                            //创建唯一标识  
                            req.transaction = buildTransaction(filename);
                            req.message = msg;
                            req.scene = SendMessageToWX.Req.WXSceneSession;

                            api.sendReq(req);
                            Toast.makeText(MainActivity.this, "插入成功！", Toast.LENGTH_SHORT).show();
                        } else {
                            Toast.makeText(MainActivity.this, "插入失败！", Toast.LENGTH_SHORT).show();
                        }
                    }
                }.execute();


            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private Bitmap getCompressBm(String filename, int maxw, int maxh) {
        Bitmap bm = null;
        int iSamplesize = 1;
        //第一次采样
        BitmapFactory.Options bitmapFactoryOptions = new BitmapFactory.Options();
        //该属性设置为true只会加载图片的边框进来，并不会加载图片具体的像素点
        bitmapFactoryOptions.inJustDecodeBounds = true;
        bitmapFactoryOptions.inPreferredConfig = Bitmap.Config.RGB_565;
        bm = BitmapFactory.decodeFile(filename, bitmapFactoryOptions);
        Log.e("Tag", "onActivityResult: 压缩之前图片的宽：" + bitmapFactoryOptions.outWidth + "--压缩之前图片的高："
                + bitmapFactoryOptions.outHeight + "--压缩之前图片大小:" + bitmapFactoryOptions.outWidth * bitmapFactoryOptions.outHeight * 4 / 1024 + "kb");
        int iWidth = bitmapFactoryOptions.outWidth;
        int iHeight = bitmapFactoryOptions.outHeight;
        //对缩放比例进行调整，直到宽和高符合我们要求为止
        while (iWidth > maxw || iHeight > maxh) {
            //如果宽高的任意一方的缩放比例没有达到要求，都继续增大缩放比例
            //sampleSize应该为2的n次幂，如果给sampleSize设置的数字不是2的n次幂，那么系统会就近取
            iSamplesize = iSamplesize * 2;//宽高均为原图的宽高的1/2  内存约为原来的1/4
            iWidth = iWidth / iSamplesize;
            iHeight = iHeight / iSamplesize;
        }
        //二次采样开始
        //二次采样时我需要将图片加载出来显示，不能只加载图片的框架，因此inJustDecodeBounds属性要设置为false
        bitmapFactoryOptions.inJustDecodeBounds = false;
        bitmapFactoryOptions.inSampleSize = iSamplesize;
        // 设置像素颜色信息
        // bitmapFactoryOptions.inPreferredConfig = Bitmap.Config.RGB_565;
        bm = BitmapFactory.decodeFile(filename, bitmapFactoryOptions);
//默认的图片格式是Bitmap.Config.ARGB_8888
        Log.e("Tag", "onActivityResult: 图片的宽：" + bm.getWidth() + "--图片的高："
                + bm.getHeight() + "--图片大小:" + bm.getWidth() * bm.getHeight() * 4 / 1024 + "kb");
        return bm;//返回压缩后的照片
    }

    private static String buildTransaction(String type) {
        return (type == null) ? String.valueOf(System.currentTimeMillis()) : type + System.currentTimeMillis();
    }


    public static Detail getDetail(String res) {

        Gson gson = new Gson();

        Detail wetherBean = gson.fromJson(res, Detail.class);

        return wetherBean;

    }
}
