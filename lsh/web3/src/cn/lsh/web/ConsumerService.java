package cn.lsh.web;


import javax.annotation.Resource;
import javax.jms.Destination;
import javax.jms.JMSException;
import javax.jms.TextMessage;

import org.springframework.jms.core.JmsTemplate;
import org.springframework.stereotype.Service;


@Service
public class ConsumerService {

    @Resource(name="jmsTemplate")
    private JmsTemplate jmsTemplate;
     
    /**
     * ������Ϣ
     */
    public TextMessage receive(Destination destination) {
        TextMessage tm = (TextMessage) jmsTemplate.receive(destination);
        try {
        	System.out.println("�Ӷ���" + destination.toString() + "�յ�����Ϣ��\t"
        				+ tm.getText());
        		
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return tm;
        
    }
}