package cc.mm.ll;

import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;



public class Main {
	public static void main(String[] args) {
		try {
			Reader reader=Resources.getResourceAsReader("mybatis-config.xml");
			SqlSessionFactory factory=new SqlSessionFactoryBuilder().build(reader,"development");
			SqlSession session=factory.openSession();
			List<Member>list=session.selectList("getAll");
			for(Member m:list){
				System.out.println(m);
			}
			Company c=session.selectOne("cc.mm.ll.Company.one", 2);
			System.out.println(c);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
