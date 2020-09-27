package cn.com.cgbchina.item;

import lombok.extern.slf4j.Slf4j;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.concurrent.CountDownLatch;

@Slf4j
public class Bootstrap {

	public static void main(String[] args) throws Exception {
		final ClassPathXmlApplicationContext ac = new ClassPathXmlApplicationContext("spring/item-dubbo-provider.xml",
				"spring/item-dubbo-consumer.xml");
		ac.start();
		log.info("item service started successfully");
		// 钩子
		Runtime.getRuntime().addShutdownHook(new Thread() {
			public void run() {
				log.debug("Shutdown hook was invoked. Shutting down item Service.");
				ac.close();
			}
		});
		// prevent main thread from exit
		CountDownLatch countDownLatch = new CountDownLatch(1);
		countDownLatch.await();
	}
}
