package cn.com.cgbchina.batch;

import java.util.concurrent.CountDownLatch;

import lombok.extern.slf4j.Slf4j;

import org.springframework.context.support.ClassPathXmlApplicationContext;

@Slf4j
public class Bootstrap {

    public static void main(String[] args) throws Exception {

        final ClassPathXmlApplicationContext ac = new ClassPathXmlApplicationContext("spring/batch-dubbo-provider.xml",
                "spring/batch-dubbo-consumer.xml");
        ac.start();
        log.info("batch service started successfully");
        // 钩子
        Runtime.getRuntime().addShutdownHook(new Thread() {
            public void run() {
                log.debug("Shutdown hook was invoked. Shutting down batch Service.");
                ac.close();
            }
        });
        // prevent main thread from exit
        CountDownLatch countDownLatch = new CountDownLatch(1);
        countDownLatch.await();
    }
}
