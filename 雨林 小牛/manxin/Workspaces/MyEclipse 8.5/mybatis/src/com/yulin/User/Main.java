package com.yulin.User;

import java.io.InputStream;
import com.yulin.DB.*;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class Main {
	public static void main(String[] args) {
		//本地文件路径，如果放在某个文件夹中要加上文件夹的名字
		String path = "com/yulin/DB/cfg.xml";
		//用IO流的方式读取本地配置文件,同Main类来找到cfg.xml的路径
		InputStream is = Main.class.getClassLoader().getResourceAsStream(path);
		//利用主配置文件生成session工厂
		SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(is);
		//利用工厂开启session
		SqlSession session = factory.openSession();
		String findById = "userMapping.findUserById"; //sql语句的映射
		String insertUser = "userMapping.insertUser";
		User u = session.selectOne(findById, 1001);//执行sql
		session.insert(insertUser,new User(0,"TOM",12));
		session.commit();
		System.out.println(u);
	}
}
