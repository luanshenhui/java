package com.cebbank.ccis.cebmall.user;

import lombok.extern.slf4j.Slf4j;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.concurrent.CountDownLatch;

@Slf4j
public class MainStart {
	public static void main(String[] args) throws Exception {
		final ClassPathXmlApplicationContext ac = new ClassPathXmlApplicationContext("spring/user-dubbo-provider.xml",
				"spring/user-dubbo-consumer.xml");
		ac.start();
		log.info("user service started successfully");
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
