package com.example.smila;

import android.content.Context
import android.widget.BaseAdapter
abstract class BasicAdapter<T>(context: Context?,list:ArrayList<T>?): BaseAdapter() {
    var listData:ArrayList<T>?=null
    var context:Context?=null
    init {
        this.listData=list
        this.context=context
    }
    override fun getItem(p0: Int): T? {
        return listData?.get(p0)
    }

    override fun getItemId(p0: Int): Long {
        return p0.toLong()
    }

    override fun getCount(): Int {
        return listData?.size?:0
    }

    /**
     * 获取数据集合
     */
    public fun getData():ArrayList<T>?{
        return listData
    }

    /**
     * 移除某一项
     */
    public fun remove(position:Int){
        listData?.removeAt(position)
        notifyDataSetChanged()
    }

    /**
     * 移除所有数据
     */
    public fun removeAll(){
        listData?.clear()
        notifyDataSetChanged()
    }

    /**
     * 在某一个位置更新数据
     */
    public fun update(postion:Int,data:T){
        listData?.add(postion,data)
        notifyDataSetChanged()
    }

    /**
     * 追加数据
     */
    public fun updateAllAppend(datas:ArrayList<T>){
        listData?.addAll(datas)
        notifyDataSetChanged()
    }

    /**
     * 更新全部数据
     */
    public fun updateAll(datas: ArrayList<T>){
        listData?.clear()
        listData?.addAll(datas)
        notifyDataSetChanged()
    }
}
