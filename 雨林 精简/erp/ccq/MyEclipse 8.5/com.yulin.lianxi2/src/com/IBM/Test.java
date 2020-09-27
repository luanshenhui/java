package com.IBM;


import java.io.IOException;
import java.io.Reader;
import java.util.List;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;




public class Test {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		try {
			Reader reader=Resources.getResourceAsReader("mybatis-config.xml");
			//2��ȡsqlsession����,���ɻỰ
			SqlSessionFactory factory=new SqlSessionFactoryBuilder().build(reader,"development");//������
			//3��ȡsqlsession����
			SqlSession session=factory.openSession();
			
			List<People>list=session.selectList("com.IBM.People.sel");
			for(People s:list){
			System.out.println(s);
			}

			session.commit();
			session.close();
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
