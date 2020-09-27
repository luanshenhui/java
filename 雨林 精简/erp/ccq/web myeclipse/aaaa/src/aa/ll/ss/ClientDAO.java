package aa.ll.ss;

import java.io.IOException;
import java.io.Reader;
import java.util.List;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class ClientDAO {
	public  void add(Client c){
		try {
			Reader reader=Resources.getResourceAsReader("mybatis-config.xml");
			SqlSessionFactory factory=new SqlSessionFactoryBuilder().build(reader,"development");
			SqlSession session=factory.openSession();
			session.insert("aa.ll.ss.Client.add",c);
			session.commit();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
	}
	public List<Client> getAll(){
		List<Client>list=null;
		try {
			Reader  reader = Resources.getResourceAsReader("mybatis-config.xml");
			SqlSessionFactory factory=new SqlSessionFactoryBuilder().build(reader,"development");
			SqlSession session=factory.openSession();
			list=session.selectList("aa.ll.ss.Client.all");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
		
	}
	
	public void update(int id){
		try {
			Reader reader=Resources.getResourceAsReader("mybatis-config.xml");
			SqlSessionFactory factory=new SqlSessionFactoryBuilder().build(reader,"development");
			SqlSession session=factory.openSession();
			session.update("aa.ll.ss.Client.getID",id);
			session.commit();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
}
