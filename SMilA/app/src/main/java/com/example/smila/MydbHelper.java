package com.example.smila;
import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;
/**
 * Created by Sky on 2016/10/7.
 * sQL帮助类，必须继承自SQLiteOpenHelper，并重写两个方法
 * onCreate和onUpgrade，
 * onCreate：数据可创建时调用，主要用来初始化数据表结构，和初始数据
 * onUpgrade：数据库更新时调用，主要用来改变表结构
 * <p>
 * <p>
 * 数据库帮助类要做的事：
 * <p>
 * 重写onCreate和onUpgrade
 * 在这两个方法中填写sql语句
 */

public class MydbHelper extends SQLiteOpenHelper {
    /**
     * @param context 上下文
     *                name   数据库名称
     *                CursorFactory 游标工厂，填写null表示使用默认游标
     *                version 版本号，只能增不能减，否则会报错
     */

    public MydbHelper(Context context) {
        super(context, "Sky.db", null, 2);


    }

    /**
     * 在数据库创建时调用，主要用来初始化数据表结构和初始化数据记录
     *
     * @param db 当数据库第一次被创建时调用这个方法，适合在这个方法里面把数据表结构定义出来
     *           所以只有第一次运行的时候才会执行这个方法，如果要看到这个方法执行，需要重新安装app
     */
    @Override
    public void onCreate(SQLiteDatabase db) {
        Log.d("MydbHelper", "创建数据库onCreate");

      db.execSQL("create table contactinfo("
                +" id INTEGER PRIMARY KEY AUTOINCREMENT ,"
                +" qq varchar not null , "
                +" name varchar not null , "
                +" phone varchar not null )");




//        db.execSQL("create table contactinfo("
//                +"id integer primary key autoincrement,"
//                +"name varchar(20),"
//                +"phone varchar(20))");
    }

    /**
     * 当数据库版本更新的时候调用，版本号必须比之前的大，否则会报错
     *
     * @param db
     * @param oldVersion
     * @param newVersion
     */
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        db.execSQL("alter table contactinfo add account varchar(20)");
    }
}
