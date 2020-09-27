package com.yulin.text4;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import com.yulin.text2.Dept;


public class Main {
	public static void main(String[] args) {
		String path = "com/yulin/DB/cfg.xml";
		try {
			InputStream is = Resources.getResourceAsStream(path);
			SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(is);
			SqlSession session = factory.openSession();
			Text4Interface t4 = session.getMapper(Text4Interface.class);
			/*注释增*/
			boolean bo = t4.insert();
			session.commit();
			System.out.println(bo);
			/*注释删*/
			boolean bo1 = t4.deltet();
			session.commit();
			System.out.println(bo1);
			/*注释改*/
			boolean bo2 = t4.update();
			session.commit();
			System.out.println(bo2);
			/*注释查*/
			List<Dept> list = t4.findAll();
			System.out.println(list);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}
}
