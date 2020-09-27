package com.lsh.chinarc.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Repository;

import com.lsh.chinarc.dao.UserDao;
import com.lsh.chinarc.domain.RcDomain;
import com.lsh.chinarc.domain.Student;
import com.lsh.chinarc.domain.User;
@Repository("service")
public class Service {
	@Autowired
	@Qualifier("blankSST")
	private SqlSession sqlSession = null;
	@Autowired
	private UserDao userDao = null;

	public List<RcDomain> selectList(RcDomain rcDomain) {
		return sqlSession.selectList("SQL.RC.selectList", rcDomain);
	}

	public void updateDomain(RcDomain domain) {
		sqlSession.update("SQL.RC.updateDomain", domain);
	}

	public List<RcDomain> selectListPage(RcDomain rcDomain) {
		return sqlSession.selectList("SQL.RC.selectListPage", rcDomain);
	}

	public int selectCount(RcDomain domain) {
		return sqlSession.selectOne("SQL.RC.selectCount", domain);
	}

	public void insertDomain(RcDomain domain) {
		sqlSession.insert("SQL.RC.insertDomain", domain);
		
	}
	
	
	private Map<Integer, Student> stus = new HashMap<Integer, Student>();
	{
		stus.put(1, new Student("zhangsan",100));
		stus.put(2, new Student("lisi", 106));
	};
	
	/**
	 * 根据参数对返回值进行缓存
	 */
	@Cacheable(value="lshh")
	public Student getStudent(int id){
		System.out.println("getStudent: " + id);
		return stus.get(id);
	}

	public void saveUser(Student student) {
		User u=new User();
		u.setName(student.getName());
		u.setId(student.getAge());
		userDao.saveUser(u);
		
	}

	public User getUser(int i) {
		return userDao.getUser(i);
	}

	public List<User> selectUserListPage(User user) {
		return sqlSession.selectList("SQL.RC.selectUserListPage", user);
	}

	public int selectUserCount(User user) {
		return sqlSession.selectOne("SQL.RC.selectUserCount", user);
	}

	public void insertUser(User user) {
		sqlSession.insert("SQL.RC.insertUser", user);
		
	}

	public void updateUser(User user) {
		sqlSession.insert("SQL.RC.updateUser", user);
		
	};
	
	/*
	 * 注意：getStudent方法要定义为Public才能使用缓存。
	有条件的缓存 condition = "#id < 2"，表示只缓存id<2的数据。
	 */
//		@Cacheable(value="students", condition = "#id < 2")
//		public Student getStudent(int id){
//			System.out.println("getStudent: " + id);
//			return stus.get(id);
//		};
}
