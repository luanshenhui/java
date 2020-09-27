package cn.com.cgbchina.batch.util;

import cn.com.cgbchina.batch.service.SmsFileUploadServiceImpl;
import com.google.common.base.Throwables;
import com.spirit.jms.mq.QueueMessageListener;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Created by lvzd on 2016/9/8.
 */
@Slf4j
public class SmsUploadMqListener extends QueueMessageListener<String[]> {
    @Autowired
    private SmsFileUploadServiceImpl smsFileUploadService;

    // 线程池
    private ExecutorService executorService = Executors.newCachedThreadPool();
    @Override
    public void onMsgListener(final String[] s) {
        if (s != null && s.length > 0) {
            executorService.submit(new Runnable() {
                public void run() {
                    try {
                        smsFileUploadService.uploadSmsFile(s);
                    } catch (Exception e) {
                        log.error("SmsUploadMqListener eroor : {}" ,Throwables.getStackTraceAsString(e));
                    }
                }
            });

        }
    }
}
