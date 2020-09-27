package cn.com.cgbchina.related;

import lombok.extern.slf4j.Slf4j;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.concurrent.CountDownLatch;

@Slf4j
public class Bootstrap {

    public static void main(String[] args) throws Exception {
        final ClassPathXmlApplicationContext ac = new ClassPathXmlApplicationContext(
                "spring/related-dubbo-provider.xml", "spring/related-dubbo-consumer.xml");
        ac.start();
        log.info("related service started successfully");
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
