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
		//开启事务控制，默认情况下关闭了自动commit功能，
		//如果进行DML insert update delete 操作，必须追加事务控制
		Transaction tx = session.beginTransaction();
		//添加一条记录
		Cost cost = new Cost();
		cost.setName("吐血套餐");
		cost.setBaseDuration(100);
		cost.setBaseDuration(50);
		cost.setUnitCost(0.8);
		cost.setDescr("50元享受80小时服务，超出部分一小时0.8元");
		cost.setStatus("1");
		session.save(cost);//将cost对象信息写入数据表
		//提交事务
		tx.commit();
		//关闭连接
		session.close();
	}
	
	@Ignore
	public void findById(){
		//加载主配置文件，默认加载src下的文件
		Configuration connf = new Configuration();
		connf.configure("/hibernate.cfg.xml");
		//获取SessionFactory
		SessionFactory sf = connf.buildSessionFactory();
		//获取session
		Session session = sf.openSession();
		//按id主键条件查询load(),get()
		//get(要查询的类型,主键值)
		//get 没有记录返回null load没记录抛异常
		Cost cost = (Cost) session.get(Cost.class, 122);
		if(cost != null){
			System.out.println("id:" + cost.getId() + " Name:" + cost.getName() +
					" Descr:" + cost.getDescr());
		}else{
			System.out.println("查询失败！");
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
		cost.setName("超值套餐");
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
