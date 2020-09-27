package cn.com.cgbchina.scheduler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.concurrent.CountDownLatch;

public class Bootstrap {
    private static final Logger log = LoggerFactory.getLogger(Bootstrap.class);
    public static void main(String[] args) throws Exception {

        final ClassPathXmlApplicationContext ac = new ClassPathXmlApplicationContext("spring/scheduler-dubbo-consumer.xml");
        ac.start();
        log.info("scheduler service started successfully");
        // 钩子
        Runtime.getRuntime().addShutdownHook(new Thread() {
            public void run() {
                log.debug("Shutdown hook was invoked. Shutting down scheduler Service.");
                ac.close();
            }
        });
        // prevent main thread from exit
        CountDownLatch countDownLatch = new CountDownLatch(1);
        countDownLatch.await();
    }
}
