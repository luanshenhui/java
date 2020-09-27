package com.lsh.zhm;



import java.io.IOException;
import java.io.Reader;
import java.util.List;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;




public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		try {
			Reader reader=Resources.getResourceAsReader("mybatis-config.xml");
			//2获取sqlsession工厂,生成会话
			SqlSessionFactory factory=new SqlSessionFactoryBuilder().build(reader,"development");//环境名
			//3获取sqlsession对象
			SqlSession session=factory.openSession();
			
			Company company=session.selectOne("com.lsh.zhm.Company.getOne",2);
			System.out.println(company);
//			
//			List<Company>list=session.selectList("com.lsh.am.Company.getAll");
//			for(Company c:list){
//				System.out.println(c);
//			}
			

			
//			Company company =session.selectOne("com.lsh.am.Company.getOne",2);
//			System.out.println(company);
//			//company.setId(5);
//			company.setName("DELL");
//			session.update("com.lsh.am.Company.upde",company);
			
			session.commit();
			session.close();
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
