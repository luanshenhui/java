package org.util;

import java.util.List;

import org.entity.Cost;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.junit.Ignore;
import org.junit.Test;

import static org.junit.Assert.*;

public class TestCost {
	@Ignore
	public void testSave(){
		Configuration conf = new Configuration();
		conf.configure("/hibernate.cfg.xml");
		SessionFactory sf = conf.buildSessionFactory();
		Session session = sf.openSession();
		//����������ƣ�Ĭ������¹ر����Զ�commit���ܣ�
		//�������DML insert update delete ����������׷���������
		Transaction tx = session.beginTransaction();
		//���һ����¼
		Cost cost = new Cost();
		cost.setName("��Ѫ�ײ�");
		cost.setBaseDuration(100);
		cost.setBaseDuration(50);
		cost.setUnitCost(0.8);
		cost.setDescr("50Ԫ����80Сʱ���񣬳�������һСʱ0.8Ԫ");
		cost.setStatus("1");
		session.save(cost);//��cost������Ϣд�����ݱ�
		//�ύ����
		tx.commit();
		//�ر�����
		session.close();
	}
	
	@Ignore
	public void findById(){
		//�����������ļ���Ĭ�ϼ���src�µ��ļ�
		Configuration connf = new Configuration();
		connf.configure("/hibernate.cfg.xml");
		//��ȡSessionFactory
		SessionFactory sf = connf.buildSessionFactory();
		//��ȡsession
		Session session = sf.openSession();
		//��id����������ѯload(),get()
		//get(Ҫ��ѯ������,����ֵ)
		//get û�м�¼����null loadû��¼���쳣
		Cost cost = (Cost) session.get(Cost.class, 122);
		if(cost != null){
			System.out.println("id:" + cost.getId() + " Name:" + cost.getName() +
					" Descr:" + cost.getDescr());
		}else{
			System.out.println("��ѯʧ�ܣ�");
		}
		session.close();
	}
	
	@Ignore
	public void delete(){
		Configuration conf = new Configuration();
		conf.configure("/hibernate.cfg.xml");
		SessionFactory sf = conf.buildSessionFactory();
		Session session = sf.openSession();
		Transaction tx = session.beginTransaction();
		Cost cost = (Cost) session.get(Cost.class, 1054);
		session.delete(cost);
		tx.commit();
		session.close();
	}
	
	@Ignore
	public void update(){
		Configuration conf = new Configuration();
		conf.configure("/hibernate.cfg.xml");
		SessionFactory sf = conf.buildSessionFactory();
		Session session = sf.openSession();
		Transaction tx = session.beginTransaction();
		Cost cost = (Cost) session.get(Cost.class, 1056);
		cost.setName("��ֵ�ײ�");
		session.update(cost);
		tx.commit();
		session.close();
	}
	
	@SuppressWarnings("unchecked")
	@Test
	public void findAll(){
		Configuration connf = new Configuration();
		connf.configure("/hibernate.cfg.xml");
		SessionFactory sf = connf.buildSessionFactory();
		Session session = sf.openSession();
		Query query = session.createQuery("from Cost");
		List<Cost> list = query.list();
		for(Cost c : list){
			System.out.println(c);
		}
//		System.out.println(list);
		session.close();
	}
}
