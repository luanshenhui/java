package cfg;

import java.io.InputStream;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import com.yulin.dangdang.bean.User;

public class Main {
	public static void main(String[] args) {
		String path = "com/yulin/dangdang/common/cfg.xml";
		
		InputStream is = Main.class.getClassLoader().getResourceAsStream(path);
	
		SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(is);

		SqlSession session = factory.openSession();
		String findById = "userMapping.findUserById"; //sql语句的映射
		String insertUser = "userMapping.insertUser";
		User u = session.selectOne(findById, 1001);//执行sql
		session.insert(insertUser,new User(0,"4444qq@ba.com","cc","1234",'c'));
		session.commit();
		System.out.println(u);
	}

}
