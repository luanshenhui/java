package cn.com.cgbchina.batch;

import java.util.concurrent.CountDownLatch;

import lombok.extern.slf4j.Slf4j;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Bootstrap {
    private static final Logger log = LoggerFactory.getLogger(Bootstrap.class);
    public static void main(String[] args) throws Exception {

        final ClassPathXmlApplicationContext ac = new ClassPathXmlApplicationContext("spring/batch-dubbo-consumer.xml",
                "spring/batch-dubbo-provider.xml");
        ac.start();
        log.info("batch service started successfully");
        // 钩子
        Runtime.getRuntime().addShutdownHook(new Thread() {
            public void run() {
                ac.close();
            }
        });
        // prevent main thread from exit
        CountDownLatch countDownLatch = new CountDownLatch(1);
        countDownLatch.await();
    }
}
