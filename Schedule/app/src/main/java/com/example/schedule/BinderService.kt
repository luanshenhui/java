package com.example.schedule

import android.app.Service
import android.content.Intent
import android.os.Binder
import android.os.IBinder
import java.util.*

class BinderService : Service() {

    override fun onBind(intent: Intent): IBinder {
        // 返回 MyBinder Service 对象
        return MyBinder()
    }

    // 创建 MyBinder 内部类
    class MyBinder : Binder() {
        fun getService(): BinderService? {// 创建 获取service 方法
            return BinderService()// 返回当前的 Service 类
        }
    }

    fun getRandom(): String? {
        return Random().nextInt(33).toString()
    }

    override fun onDestroy() {
        super.onDestroy()
    }

}
