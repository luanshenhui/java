package com.lsh.domain;

import java.io.IOException;
import java.io.Reader;
import java.util.List;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSession;//对话



public class Test {

	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		//读取mybatis核心配置文件
		try {
			Reader reader=Resources.getResourceAsReader("mybatis-config.xml");
			//2获取sqlsession工厂
			SqlSessionFactory factory=new SqlSessionFactoryBuilder().build(reader,"development");//环境名
			//3获取sqlsession对象
			SqlSession session=factory.openSession();
			//4执行sql语句
			//找文件
//			Member member=session.selectOne("com.lsh.domain.Member.getMemberByID","3");
//			System.out.println(member);
			//4.2
//			Member member=new Member(10,"测试","女",4500.5,"市场部");
//			session.insert("com.lsh.domain.Member.add",member);
			//4.3
			Member member=session.selectOne("com.lsh.domain.Member.getMemberByID",2);
			System.out.println(member);
			member.setName("春晓");
			member.setSex("女");
			member.setSalary(10000);
			member.setDepartment("公关部");
			session.update("com.lsh.domain.Member.update",member);
			//(4.4)
//			session.delete("com.lsh.domain.Member.delete",1);
			//(4.5)查询
//			List<Member>list=session.selectList("com.lsh.domain.Member.all");
//			for(Member m:list){
//				System.out.println(m);
//			}
			session.commit();
			session.close();
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

}
