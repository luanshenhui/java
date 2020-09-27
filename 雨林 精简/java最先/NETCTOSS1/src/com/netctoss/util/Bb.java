package com.netctoss.util;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class Bb {
	
	
		private static SessionFactory sf;
		private static ThreadLocal<Session> tl=new ThreadLocal<Session>() ;
		static{
			Configuration conf=new Configuration();
			conf.configure("/hibernate.cfg.xml");
			sf=conf.buildSessionFactory();
		}
		public static Session getSession(){
			Session session=tl.get();
			if(session==null || !session.isOpen()){
				session=sf.openSession();
			}
			return session;
			
		}
		
		public static void clossSession(){
			Session session=tl.get();
			tl.set(null);
			if(session!=null){
				session.close();
			}
		}
		public static void main(String[] args) {
			Session s1=getSession();
			Session s2=getSession();
			System.out.println(s1==s2);
		}
}
