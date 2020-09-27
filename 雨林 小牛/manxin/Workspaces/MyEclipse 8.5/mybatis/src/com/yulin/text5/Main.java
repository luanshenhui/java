package com.yulin.text5;

import java.io.IOException;
import java.io.Reader;
import java.util.List;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class Main {

	/**
	 * 一对多
	 */
	public static void main(String[] args) {
		String path = "com/yulin/DB/cfg.xml";
		try {
			Reader rd = Resources.getResourceAsReader(path);
			SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(rd);
			SqlSession session = factory.openSession();
			/* 一对多的查询 */
			List<Dept> depts = session.selectList("com.yulin.text5.DeptMapping2.findAll");
			for(Dept d : depts){
				System.out.println(d);
			}
			/* 一(m)对一的查询 */
			System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
			List<Info> infos = session.selectList("com.yulin.text5.InfoMapping2.findAll");
			for(Info i : infos){
				System.out.println(i);
			}
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

}
