package com.example.schedule

import android.os.Bundle
import android.util.Log
import android.widget.ListView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import java.util.*
import javax.mail.*
import javax.mail.internet.InternetAddress
import javax.mail.internet.MimeMessage
import kotlin.collections.arrayListOf
import kotlin.collections.set


class MailActivity : AppCompatActivity() {

    var mListView: ListView? = null
    var data: ArrayList<Person>? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.mail_list)
        mListView=findViewById(R.id.listView)
        // 获取意图对象
        val intent = intent
        //获取传递的值
        val sql = intent.getStringExtra("data")
        data= ContactinfoDao(this).ListData(sql) as ArrayList<Person>?
        try {
            var adater= MyAdapter(this,data);
            mListView?.adapter=adater
            //设置item的点击事件
            mListView?.setOnItemClickListener { adapterView, view, i, l ->
                Toast.makeText(
                    this, data?.get(i)?.qq,
                    Toast.LENGTH_SHORT
                ).show()
                Thread(Runnable {
                    // send mail for qq
                    send(data?.get(i)?.qq.toString())
                    // get Count
                    var count=ContactinfoDao(this).alertData(data?.get(i)?.qq)
                    // count +1
                    if(count==null || count == "null"){
                        count="0"
                    }
                    ContactinfoDao(this).updateData(data?.get(i)?.qq,(count.toInt()+1))
                }).start()
            }
        } catch (e: Exception) {
            Toast.makeText(this,"err", Toast.LENGTH_SHORT).show()
            Log.v("tag",e.message)
        } finally {
            // Toast.makeText(this,"err2", Toast.LENGTH_SHORT).show()
        }

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

}
