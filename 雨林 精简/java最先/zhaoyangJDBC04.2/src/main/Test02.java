package main;

import java.io.IOException;
import java.io.Reader;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import com.lsh.am.Member;

public class Test02 {
	public static void main(String[] args) {
		try {
			Reader reader=Resources.getResourceAsReader("mybatis-config.xml");
			//2��ȡsqlsession����,���ɻỰ
			SqlSessionFactory factory=new SqlSessionFactoryBuilder().build(reader,"development");//������
			//3��ȡsqlsession����
			SqlSession session=factory.openSession();
			Member member=session.selectOne("com.lsh.am.Member.getOne",1);
			
			session.commit();
			session.close();
			System.out.println(member);
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
