package com.yulin.dangdang.dao;

import java.io.IOException;
import java.io.InputStream;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class Main {

	public static void main(String[] args) {
		String path = "cfg/cfg.xml";
		String namespace = "com.yulin.cateMapping";
		try {
			InputStream is = Resources.getResourceAsStream(path);
			SqlSessionFactory fa = new SqlSessionFactoryBuilder().build(is);
			SqlSession session = fa.openSession();
			for(Object b : session.selectList(namespace + ".findBook" ,9)){
				System.out.println(b);
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
