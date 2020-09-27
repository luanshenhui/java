package com.example.schedule

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.util.Log
import android.widget.Toast

class MyService2 : Service() {

    override fun onBind(intent: Intent): IBinder {
        TODO("Return the communication channel to the service.")
    }

    override fun onCreate() {
        super.onCreate()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        var i=0;
        Thread(Runnable {
           while(true){
               i++
               Log.v("tag","################################"+i)
           }
        }).start()

        return super.onStartCommand(intent, flags, startId)
    }

}
