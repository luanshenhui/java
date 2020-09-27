package com.yulin.text2;

import java.io.IOException;
import java.io.InputStream;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class Main {

	public static void main(String[] args) {
		String path = "com/yulin/DB/cfg.xml";
		String namespace = "com.yulin.text2.DeptMapper";
		try {
			InputStream is = Resources.getResourceAsStream(path);
			SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(is);
			SqlSession session = factory.openSession();
			for(Object d : session.selectList(namespace + ".findDept")){
				System.out.println(d);
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}