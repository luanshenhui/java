package com.lsh.chinarc.common;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.annotation.Resource;
import javax.jms.Destination;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.lsh.chinarc.domain.RcDomain;
import com.lsh.chinarc.domain.Student;
import com.lsh.chinarc.domain.User;
import com.lsh.chinarc.service.ProducerService;
import com.lsh.chinarc.service.Service;


@Component("task")
public class Task {
	@Autowired
	private Service service;
	
	//队列名gzframe.demo
    @Resource(name="demoQueueDestination")
    private Destination demoQueueDestination;
    
    //队列名gzframe.demo
    @Resource(name="lsh")
    private Destination lsh;

    //队列消息生产者
    @Resource(name="producerService")
    private ProducerService producer;
	
	@Scheduled(cron = "0 0/1 * * * ?")
	public void task(){
		int counts=service.selectCount(new RcDomain());
		Date now = new Date();
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String time = dateFormat.format(now);
		String info="------sendMessage-------"+time+"--"+counts+"----";
		producer.sendMessage(demoQueueDestination, info);
		
		System.err.println(info);

		Student student1 = service.getStudent(1);
		System.out.println(student1);
		User user9 = service.getUser(9);
		User user6 = service.getUser(6);
		User user4 = service.getUser(4);
		System.out.println("user9------"+user9);
		System.out.println("user6------"+user6);
		System.out.println("user4------"+user4);
		service.saveUser(new Student("ccq",4,"3-1"));
		
	}
	
	@Scheduled(cron = "0 0/2 * * * ?")
	public void taskLsh(){
		int counts=service.selectCount(new RcDomain());
		Date now = new Date();
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String time = dateFormat.format(now);
		String info="------sendlsh-------"+time+"--"+counts+"----";
		producer.sendMessage(lsh, info);
		System.err.println(info);
	}

}
