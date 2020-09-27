package cc.hh.a;

import java.io.IOException;
import java.io.Reader;

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
			Reader reader = Resources.getResourceAsReader("mybatis-config.xml");
			// 2获取sqlsession工厂,生成会话
			SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(
					reader, "development");// 环境名
			// 3获取sqlsession对象
			SqlSession session = factory.openSession();
//			Mem m = session.selectOne("cc.hh.a.Mem.sel", 1);
//			System.out.println(m);
			Company company =session.selectOne("cc.hh.a.Company.getOne",2);
			System.out.println(company);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

}
