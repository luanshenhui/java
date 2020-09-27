package com.lsh.chinarc.common;
import javax.annotation.Resource;
import javax.jms.Destination;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MessageListener;
import javax.jms.TextMessage;

import com.lsh.chinarc.service.ConsumerService;

/**
 * Created by Administrator on 2017/5/3.
 */
public class QueueMessageListener implements MessageListener {
	
	//������gzframe.demo
    @Resource(name="demoQueueDestination")
    private Destination demoQueueDestination;
    
    //������lsh.demo
    @Resource(name="lsh")
    private Destination lsh;
    
    //������Ϣ������
    @Resource(name="consumerService")
    private ConsumerService consumer;
	
    public void onMessage(Message message) {
        TextMessage tm = (TextMessage) message;
//        TextMessage tm = consumer.receive(demoQueueDestination);
        try {
            System.out.println("QueueMessageListener���������ı���Ϣ��\t"
                    + tm.getText());
            //do something ...
        } catch (JMSException e) {
            e.printStackTrace();
        }
    }
}