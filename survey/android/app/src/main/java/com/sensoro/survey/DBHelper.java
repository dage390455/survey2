package com.sensoro.survey;

import android.database.Cursor;
import android.database.sqlite.SQLiteOpenHelper;

import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;


import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteDatabase.CursorFactory;
import android.database.sqlite.SQLiteException;
import android.database.sqlite.SQLiteOpenHelper;

public class DBHelper extends SQLiteOpenHelper {

    private static final int DB_VERSION    = 1;
    //数据库文件目标存放路径为系统默认位置，cn.arthur.examples 是你的包名
    private static String DB_PATH        = "/data/data/com.sensoro.survey/databases/";
    /*
        //如果你想把数据库文件存放在SD卡的话
        private static String DB_PATH        = android.os.Environment.getExternalStorageDirectory().getAbsolutePath()
                                            + "/arthurcn/drivertest/packfiles/";
    */
    private static String DB_NAME         = "selectCity.db";
    private static String ASSETS_NAME     = "selectCity.db";

    private SQLiteDatabase myDataBase    = null;
    private final Context myContext;

    /**
     * 如果数据库文件较大，使用FileSplit分割为小于1M的小文件
     * 此例中分割为 hello.db.101    hello.db.102    hello.db.103
     */
    //第一个文件名后缀
    private static final int ASSETS_SUFFIX_BEGIN    = 101;
    //最后一个文件名后缀
    private static final int ASSETS_SUFFIX_END        = 103;

    /**
     * 在SQLiteOpenHelper的子类当中，必须有该构造函数
     * @param context    上下文对象
     * @param name        数据库名称
     * @param factory    一般都是null
     * @param version    当前数据库的版本，值必须是整数并且是递增的状态
     */
    public DBHelper(Context context, String name, CursorFactory factory, int version) {
        //必须通过super调用父类当中的构造函数
        super(context, name, null, version);
        this.myContext = context;
    }

    public DBHelper(Context context, String name, int version){
        this(context,name,null,version);
    }

    public DBHelper(Context context, String name){
        this(context,name,DB_VERSION);
    }

    public DBHelper (Context context) {
        this(context, DB_PATH + DB_NAME);
    }

    public void createDataBase() throws IOException{
        boolean dbExist = checkDataBase();
        if(dbExist){
            //数据库已存在，do nothing.
        }else{
            //创建数据库
            try {
                File dir = new File(DB_PATH);
                if(!dir.exists()){
                    dir.mkdirs();
                }
                File dbf = new File(DB_PATH + DB_NAME);
                if(dbf.exists()){
                    dbf.delete();
                }
//                SQLiteDatabase.openOrCreateDatabase(dbf, null);
                // 复制asseets中的db文件到DB_PATH下
                copyDataBase();
            } catch (IOException e) {
                throw new Error("数据库创建失败");
            }
        }
    }

    //检查数据库是否有效
    private boolean checkDataBase(){
        SQLiteDatabase checkDB = null;
        String myPath = DB_PATH + DB_NAME;
        try{
            checkDB = SQLiteDatabase.openDatabase(myPath, null, SQLiteDatabase.OPEN_READONLY);
        }catch(SQLiteException e){
            //database does't exist yet.
        }
        if(checkDB != null){
            checkDB.close();
        }
        return checkDB != null ? true : false;
    }


    public List getcityList(String cityCode){
        SQLiteDatabase checkDB = null;
        String myPath = DB_PATH + DB_NAME;
        try{
            checkDB = SQLiteDatabase.openDatabase(myPath, null, SQLiteDatabase.OPEN_READONLY);
        }catch(SQLiteException e){
            //database does't exist yet.
        }

//参数1：表名
//参数2：要想显示的列
//参数3：where子句
//参数4：where子句对应的条件值
//参数5：分组方式
//参数6：having条件
//参数7：排序方式

        List<Map> list = new ArrayList<>();

        Cursor cursor = checkDB.query("city", new String[]{"short_name","code"}, "parent_code=?", new String[]{cityCode}, null, null, null);
        while(cursor.moveToNext()){
            String name = cursor.getString(cursor.getColumnIndex("short_name"));
            String age = cursor.getString(cursor.getColumnIndex("code"));

            Map map = new HashMap<String, String>();
            map.put("short_name",name);
            map.put("code",age);
            list.add(map);

            System.out.println("query------->" + "姓名："+name+" "+"年龄："+age+" ");
        }
//关闭数据库

        checkDB.close();

        return list;
    }

    /**
     * Copies your database from your local assets-folder to the just created empty database in the
     * system folder, from where it can be accessed and handled.
     * This is done by transfering bytestream.
     * */
    private void copyDataBase() throws IOException{
        //Open your local db as the input stream
        InputStream myInput = myContext.getAssets().open(ASSETS_NAME);
        // Path to the just created empty db
        String outFileName = DB_PATH + DB_NAME;
        //Open the empty db as the output stream
        OutputStream myOutput = new FileOutputStream(outFileName);
        //transfer bytes from the inputfile to the outputfile
        byte[] buffer = new byte[1024];
        int length;
        while ((length = myInput.read(buffer))>0){
            myOutput.write(buffer, 0, length);
        }
        //Close the streams
        myOutput.flush();
        myOutput.close();
        myInput.close();
    }

    //复制assets下的大数据库文件时用这个
    private void copyBigDataBase() throws IOException{
        InputStream myInput;
        String outFileName = DB_PATH + DB_NAME;
        OutputStream myOutput = new FileOutputStream(outFileName);
        for (int i = ASSETS_SUFFIX_BEGIN; i < ASSETS_SUFFIX_END+1; i++) {
            myInput = myContext.getAssets().open(ASSETS_NAME + "." + i);
            byte[] buffer = new byte[1024];
            int length;
            while ((length = myInput.read(buffer))>0){
                myOutput.write(buffer, 0, length);
            }
            myOutput.flush();
            myInput.close();
        }
        myOutput.close();
    }

    @Override
    public synchronized void close() {
        if(myDataBase != null){
            myDataBase.close();
        }
        super.close();
    }

    /**
     * 该函数是在第一次创建的时候执行，
     * 实际上是第一次得到SQLiteDatabase对象的时候才会调用这个方法
     */
    @Override
    public void onCreate(SQLiteDatabase db) {
    }

    /**
     * 数据库表结构有变化时采用
     */
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
    }

}
