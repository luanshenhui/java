package com.example.schedule;


import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Sky on 2016/10/7.
 */

public class ContactinfoDao {
    MydbHelper mMydbHelper;

    /**
     * 在构造方法中实例化帮助类
     *
     * @param context
     */
    public ContactinfoDao(Context context) {
        mMydbHelper = new MydbHelper(context);
    }

    /**
     * 将数据库打开，帮帮助类实例化，然后利用这个对象
     */

    public long addData(String qq,String name, String phone) {
        /**
         * getWritableDatabase:
         * Create and/or open a database that will be used for reading and writing.
         *
         *
         * 增删改查，每一次操作都要得到数据库，操作完成后都要记得关闭
         * getWritableDatabase得到后数据库才会被创建
         * 数据库文件利用DDMS可以查看，在 data/data/包名/databases 目录下即可查看
         */
        SQLiteDatabase writableDatabase = mMydbHelper.getWritableDatabase();
        /**
         * ContentValues:This class is used to store a set of values
         * 存储值得集合
         */
        ContentValues values = new ContentValues();
        values.put("qq", qq);
        values.put("name", name);
        values.put("phone", phone);
        /**
         * 参数1：表名
         * 参数2：可选择的项。可空、
         * 参数3：要添加的值
         * 返回类型：添加数据所在行数，如果返回-1，则表示添加失败
         */
        long row = writableDatabase.insert("contactinfo", null, values);
        writableDatabase.close();
        return row;
    }

    /**
     * 删除
     *
     * @param name
     * @return
     */
    public int deleteData(String name,String phone) {
        SQLiteDatabase writableDatabase = mMydbHelper.getWritableDatabase();
        /**
         *参数1：表名
         * 参数2：删除条件，如果为null，则表示删除全部
         * 参数3：
         */
        int result = writableDatabase.delete("contactinfo", "name=? and phone=?", new String[]{name,phone});
        writableDatabase.close();
        return result;
    }

    /**
     *查询
     * @param qq
     * @return
     */
    public String alertData(String qq) {
        SQLiteDatabase writableDatabase = mMydbHelper.getWritableDatabase();
        /**
         * 参数1：查询的表
         * 参数2：查询的列
         * 参数3：selection
         * 参数4：selectionArgs
         * 参数5：groupBy
         * 参数6：having
         * 参数7：orderBy
         */
        Cursor cursor = writableDatabase.query("contactinfo", new String[]{"send_count"}, "qq=?", new String[]{qq}, null, null, null);
        String phone = null;
        if (cursor.moveToNext()) {
            phone = cursor.getString(0);
        }
        //关闭cursor
        cursor.close();
        //关闭数据库
        writableDatabase.close();
        return phone;


    }

    /**
     * 更新
     * @param qq
     * @param delcount
     * @return
     */
    public int updateData(String qq, int delcount) {

        SQLiteDatabase writableDatabase = mMydbHelper.getWritableDatabase();

        ContentValues values = new ContentValues();
        values.put("send_count", delcount);
        //更新contactinfo表中，name=name的手机号,返回行号
        int row = writableDatabase.update("contactinfo", values, "qq=?", new String[]{qq});
        writableDatabase.close();
        return row;
    }

    /**
     * delete更新
     * @param qq
     * @param delcount
     * @return
     */
    public int deleteFlg(String qq, String delcount) {

        SQLiteDatabase writableDatabase = mMydbHelper.getWritableDatabase();

        ContentValues values = new ContentValues();
        values.put("del_flg", 1);
        //更新contactinfo表中，name=name的手机号,返回行号
        int row = writableDatabase.update("contactinfo", values, "qq=?", new String[]{qq});
        writableDatabase.close();
        return row;
    }


    /**
     *查询List
     * @param sql
     * @return
     */
    public List<Person> ListData(String sql) {
        SQLiteDatabase writableDatabase = mMydbHelper.getWritableDatabase();
        /**
         * 参数1：查询的表
         * 参数2：查询的列
         * 参数3：selection
         * 参数4：selectionArgs
         * 参数5：groupBy
         * 参数6：having
         * 参数7：orderBy
         */
       /* Cursor cursor = writableDatabase.query("lianDb", new String[]{"name","qq","send_count"}, "del_flg=?", new String[]{del_flg}, null, null, null);
        String phone = null;
        if (cursor.moveToNext()) {
            phone = cursor.getString(0);
        }
        //关闭cursor
        cursor.close();
        //关闭数据库
        writableDatabase.close();
        return phone;*/

        Cursor cursor = writableDatabase.rawQuery(sql, null);
        List<Person> list=new ArrayList<Person>();
        while (cursor.moveToNext()) {
            String qq = cursor.getString(3);//获取第三列的值
            String name = cursor.getString(1);//获取第二列的值
            int photo = cursor.getInt(9);//获取第三列的值
            Person member=new Person();
            member.setNum(0);
            member.setQq(qq);
            member.setName(name);
            member.setProfile(String.valueOf(photo));
            list.add(member);
        }
        cursor.close();
        writableDatabase.close();
        return list;
    }

    /**
     *查询
     * @param sql
     * @return
     */
    public String getQqCount(String sql) {
        SQLiteDatabase writableDatabase = mMydbHelper.getWritableDatabase();
        Cursor cursor = writableDatabase.rawQuery("select * from contactinfo order by send_count limit 0,1", null);
        String str = null;
        if (cursor.moveToNext()) {
            str = cursor.getString(3)+"_"+cursor.getInt(9);
        }
        //关闭cursor
        cursor.close();
        //关闭数据库
        writableDatabase.close();
        return str;


    }
}
