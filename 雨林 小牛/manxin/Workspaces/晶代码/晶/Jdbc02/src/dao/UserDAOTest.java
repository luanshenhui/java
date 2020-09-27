package dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import util.Factory;

import entity.User;

public class UserDAOTest {

	@Test
	public void testSave() throws SQLException {
		UserDAOImpl dao = (UserDAOImpl)Factory.getIntance("UserDAO");
		User user = new User();
		user.setUsername("user1234");
		user.setPwd("test");
		user.setAge(22);
		dao.save(user);
	}
	
	@Test
	public void testFindAll() throws SQLException {
		UserDAOImpl dao = new UserDAOImpl();
		List<User> users = dao.findAll();
//		System.out.println(users);
		System.out.println(users.size());
	}
	
	@Test
	public void testDelete() throws SQLException {
		UserDAOImpl dao = new UserDAOImpl();
		dao.delete(105);
	}
	
	@Test
	public void testFindByUsername() throws SQLException {
		UserDAOImpl dao = new UserDAOImpl();
		User user = dao.findByUsername("user0099");
		System.out.println(user);
	}
	
	@Test
	public void testSaveList() throws SQLException {
		UserDAOImpl dao = new UserDAOImpl();
		List<User> users = new ArrayList<User>();
		for(int i=0;i<100;i++){
			User user = new User();
			user.setUsername("user0" + i);
			user.setPwd("test");
			user.setAge(22);
			users.add(user);
		}
		dao.saveList(users);
	}
	
	@Test
	public void testSaveBatch() throws SQLException {
		UserDAOImpl dao = new UserDAOImpl();
		List<User> users = new ArrayList<User>();
		for(int i=0;i<24;i++){
			User user = new User();
			user.setUsername("user0" + i);
			user.setPwd("test");
			user.setAge(22);
			users.add(user);
		}
		dao.saveBatch(users);
	}
	
	@Test
	public void testModify() throws SQLException{
		UserDAOImpl dao = new UserDAOImpl();
		User user = dao.findByUsername("user099");
		user.setAge(user.getAge() + 10);
		user.setPwd("dogdog");
		dao.modify(user);
		
	}
	
	@Test
	public void testFindByPages() throws SQLException{
		UserDAOImpl dao = new UserDAOImpl();
		List<User> users = 
			dao.findByPages(2, 3);
		System.out.println(users);
	}
	
	@Test
	public void testGetTotalPages() throws SQLException{
		UserDAOImpl dao = new UserDAOImpl();
		System.out.println(dao.getTotalPages(5));
	}
	
	
	
	
}
