package com.example.schedule


import android.content.ComponentName
import android.content.Intent
import android.content.ServiceConnection
import android.database.sqlite.SQLiteDatabase
import android.os.Bundle
import android.os.CountDownTimer
import android.os.IBinder
import android.os.Process
import android.text.TextUtils
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.example.schedule.BinderService.MyBinder
import java.io.BufferedReader
import java.io.IOException
import java.io.InputStream
import java.io.InputStreamReader
import java.sql.SQLException
import java.util.*
import javax.mail.*
import javax.mail.internet.InternetAddress
import javax.mail.internet.MimeMessage


class MainActivity : AppCompatActivity() {
    var binderService: BinderService? = null //声明 binderService

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val db: SQLiteDatabase = MydbHelper(this).getWritableDatabase()
        try {
            val `in` = assets.open("garden.sql")
            var sqlUpdate: String? = null
            try {
                sqlUpdate = readTextFromSDcard(`in`)
            } catch (e: java.lang.Exception) {
                e.printStackTrace()
            }
            val s = sqlUpdate!!.split(";".toRegex()).toTypedArray()
            for (i in s.indices) {
                if (!TextUtils.isEmpty(s[i])) {
                    db.execSQL(s[i])
                }
            }
            `in`.close()
        } catch (e: SQLException) {
            Toast.makeText(this,e.message, Toast.LENGTH_SHORT).show()
            e.printStackTrace()
        } catch (e: IOException) {
            Toast.makeText(this,e.message, Toast.LENGTH_SHORT).show()
            e.printStackTrace()
        } catch (e: Exception) {
            Toast.makeText(this,e.message, Toast.LENGTH_SHORT).show()
            e.printStackTrace()
        }

        var b1 = findViewById<Button>(R.id.btn)
        b1.setOnClickListener {
            val intent= Intent(this@MainActivity, MailActivity::class.java)
            intent.putExtra("data","select * from contactinfo where del_flg is null or del_flg !=1 order by send_count");
            startActivity(intent)
        }

        var b2 = findViewById<Button>(R.id.schedule)
        b2.setOnClickListener{
            var tv = findViewById<TextView>(R.id.time)
            Thread(Runnable {
                task()
            }).start()
            startClick(tv);
        }


        /*b2.setOnClickListener{
            val timer: CountDownTimer = object : CountDownTimer(1000*1000, 1000) {
                override fun onTick(sin: Long) {
                    var tv = findViewById<TextView>(R.id.text)
                    tv.setText((sin / 1000).toString())
                }
                override fun onFinish() {
                    Toast.makeText(this@MainActivity, "倒计时完成", Toast.LENGTH_SHORT).show()
                }
            }
            timer.start();
        }*/

        /*b2.setOnClickListener {
            var tv = findViewById<TextView>(R.id.text)
            tv.setText("自动发送已开启，默默运行中")
            Thread(Runnable {
                task()
            }).start()
        }*/

        var b3 = findViewById<Button>(R.id.limit)
        var pushEdit = findViewById<EditText>(R.id.edit)
        b3.setOnClickListener {
            Thread(Runnable {
                val intent= Intent(this@MainActivity, MailActivity::class.java)
                intent.putExtra("data", pushEdit.getText().toString());
                startActivity(intent)
            }).start()
        }
        var b4 = findViewById<Button>(R.id.test)
        b4.setOnClickListener {
            Thread(Runnable {
                val intent= Intent(this@MainActivity, MailActivity::class.java)
                intent.putExtra("data","select '1', '一期一会', '叠纸嘤～嘤～嘤', '2450917894', '女', '18年', '2018-02-02 00:00:00', '月是天下客(0)', '2019-02-05 00:00:00', 0, 0 from contactinfo where qq=4154810 \n" +
                        "union \n" +
                        "select '2', '一期一会', '叠纸嘤～嘤～嘤', '1922154404', '女', '18年', '2018-02-02 00:00:00', '月是天下客(0)', '2019-02-05 00:00:00', 0, 0 from contactinfo where qq=4154810 \n" +
                        "union \n" +
                        "select '3', '一期一会', '叠纸嘤～嘤～嘤', '535070267', '女', '18年', '2018-02-02 00:00:00', '月是天下客(0)', '2019-02-05 00:00:00', 0, 0 from contactinfo where qq=4154810 ");
                startActivity(intent)
            }).start()
        }

        var b5 = findViewById<Button>(R.id.service)
        b5.setOnClickListener {
            val intent= Intent(this@MainActivity, MyService2::class.java)
            startService(intent)
        }
        var b6 = findViewById<Button>(R.id.bindservice)
        b6.setOnClickListener {
            var i=binderService?.getRandom();
            var tv = findViewById<TextView>(R.id.text)
            tv.setText(i)
        }
        var b7 = findViewById<Button>(R.id.listTest)
        b7.setOnClickListener {
            val intent= Intent(this@MainActivity, ListActivity::class.java)
            startActivity(intent)
        }

        var b8 = findViewById<Button>(R.id.update)
        var updateqq = findViewById<EditText>(R.id.updateqq)
        b8.setOnClickListener {
            var i=ContactinfoDao(this).deleteFlg(updateqq.getText().toString(),"")
            Toast.makeText(this,"update over" + i , Toast.LENGTH_SHORT).show()
        }
    }

    fun click() {
        // 获取当前进程的id
        val pid = Process.myPid()
        // 这个方法只能用于自杀操作
        Process.killProcess(pid)
    }

    private fun task() {
        var tv = findViewById<TextView>(R.id.text)
        while (true) {
            try {
                var qq_cunt= ContactinfoDao(this).getQqCount("999") as String
                var qq=qq_cunt.split("_")[0]
                // get Count
                var count=qq_cunt.split("_")[1]
                // count +1
                Thread.sleep(8*60*1000) // 线程暂停6分钟，单位毫秒
                ContactinfoDao(this).updateData(qq,(count.toInt()+1))
                // send mail for qq
                send(qq)
                tv.setText(qq+"已发送")
                Thread.sleep(8*60*1000) // 线程暂停6分钟，单位毫秒
            } catch (e: MessagingException) {
                // 获取当前进程的id
                val pid = Process.myPid()
                // 这个方法只能用于自杀操作
                Process.killProcess(pid)
                finish()
                break
                e.printStackTrace()
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    var timerTask: TimerTask ? = null
    val timer1: Timer? = Timer()
    fun startClick(view: TextView?) {
        timerTask = object : TimerTask() {
            var cnt = 0
            override fun run() {
                runOnUiThread {
                    if (view != null) {
                        view.setText(getStringTime(cnt++))
                    }
                }
            }
        }
        if (timer1 != null) {
            timer1.schedule(timerTask, 0, 1000)
        }
    }

    private fun getStringTime(cnt: Int): String? {
        val hour = cnt / 3600
        val min = cnt % 3600 / 60
        val second = cnt % 60
        return java.lang.String.format(Locale.CHINA, "%02d:%02d:%02d", hour, min, second)
    }

    @Throws(Exception::class)
    private fun readTextFromSDcard(`is`: InputStream): String? {
        val reader = InputStreamReader(`is`)
        val bufferedReader = BufferedReader(reader)
        val buffer = StringBuffer("")
        var str: String?=""
        while (bufferedReader.readLine().also({ str = it }) != null) {
            buffer.append(str)
            buffer.append("\n")
        }
        return buffer.toString()
    }

    @Throws(MessagingException::class)
    fun send(qq: String): Unit {
        var qq = qq
        val props = Properties()
        props["mail.smtp.auth"] = "true"
        props["mail.smtp.host"] = "smtp.qq.com"
        props["mail.transport.protocol"] = "smtp"
        props["mail.debug"] = "true" //遇到最多的坑就是下面这行，不加要报“A secure connection is requiered”错。
        // props.put("mail.smtp.starttls.enable", "true");
        // 发件人的账号
        //props.put("mail.user", "836597194@qq.com");
        // 访问SMTP服务时需要提供的密码
        //props.put("mail.password", "szkafirbwyqxbcfd");

        // 构建授权信息，用于进行SMTP进行身份验证
        val authenticator: Authenticator = object : Authenticator() {
            override fun getPasswordAuthentication(): PasswordAuthentication {
                // 用户名、密码
                //String userName = props.getProperty("mail.user");
                //String password = props.getProperty("mail.password");
                //return new PasswordAuthentication(userName, password);
                return PasswordAuthentication("836597194", "szkafirbwyqxbcfd")
            }
        }
        // 使用环境属性和授权信息，创建邮件会话
        val mailSession = Session.getInstance(props, authenticator)
        // 创建邮件消息
        val message = MimeMessage(mailSession)
        // 设置发件人
        //InternetAddress form = new InternetAddress(props.getProperty("mail.user"));
        val form = InternetAddress("836597194@qq.com")
        message.setFrom(form)

        // 设置收件人
        qq = qq+"@qq.com"
        val to = InternetAddress(qq)
        message.setRecipient(Message.RecipientType.TO, to)

        // 设置抄送，抄送和密送如果不写正确的地址也要报错。最好注释不用。
        //  InternetAddress cc = new InternetAddress("");
        //  message.setRecipient(RecipientType.CC, cc);

        // 设置密送，其他的收件人不能看到密送的邮件地址
        //    InternetAddress bcc = new InternetAddress("");
        //  message.setRecipient(RecipientType.CC, bcc);

        // 设置邮件标题
        message.subject = "寄万达海创的伶伢"

        // 设置邮件的内容体
        // message.setContent("<a href='http://404的就对了'>测试的邮件</a>", "text/html;charset=UTF-8");
        message.setText("嗨，伶伢，不知道这个称呼对不对。你是不是404的可能在八一路附近那块,爱玩手游。也曾经在万达海创工作....也不知道你会不会看见，看见会不会回我(请邮件回复)。我想能做的只是如此就当个朋友呗");
        // 发送邮件
        Transport.send(message)
    }

    private val conn: ServiceConnection = object : ServiceConnection {
        override fun onServiceConnected(name: ComponentName, service: IBinder) {
            binderService = (service as MyBinder).getService()
        }

        override fun onServiceDisconnected(name: ComponentName) {}
    }


    override fun onStart() {
        val intent = Intent(this, BinderService::class.java)
        bindService(intent, conn, BIND_AUTO_CREATE)
        super.onStart()
    }

    override fun onStop() {
        // unbindService(conn)
        super.onStop()
    }
}
