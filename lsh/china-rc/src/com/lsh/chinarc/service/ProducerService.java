package com.lsh.chinarc.service;

import javax.annotation.Resource;
import javax.jms.Destination;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.Session;

import org.springframework.jms.core.JmsTemplate;
import org.springframework.jms.core.MessageCreator;
import org.springframework.stereotype.Service;
@Service
public class ProducerService {

	@Resource(name = "jmsTemplate")
	private JmsTemplate jmsTemplate;

//	*//**
//	 * ��ָ�����з�����Ϣ
//	 *//*
	public void sendMessage(Destination destination, final String msg) {
		System.out.println("�����" + destination.toString() + "��������Ϣ------------"+ msg);
		jmsTemplate.send(destination, new MessageCreator() {
			public Message createMessage(Session session) throws JMSException {
				return session.createTextMessage(msg);
			}
		});
	}

//	*//**
//	 * ��Ĭ�϶��з�����Ϣ
//	 *//*
	public void sendMessage(final String msg) {
		String destination = jmsTemplate.getDefaultDestination().toString();
		System.out.println("�����" + destination + "��������Ϣ------------" + msg);
		jmsTemplate.send(new MessageCreator() {
			public Message createMessage(Session session) throws JMSException {
				return session.createTextMessage(msg);
			}
		});

	}

}
