package com.lsh.dlrc.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.lsh.dlrc.domain.LshTable;
import com.lsh.dlrc.domain.Mobel;
import com.lsh.dlrc.domain.Photo;
import com.lsh.dlrc.domain.PordDeptDomain;
import com.lsh.dlrc.domain.Post;
import com.lsh.dlrc.domain.RcDomain;
import com.lsh.dlrc.domain.User;
@Repository("service")
public class Service {
	

	@Autowired
	@Qualifier("blankSST")
	private SqlSession sqlSession = null;
	
//	@Autowired
//	@Qualifier("blankORC")
//	private SqlSession orcSession = null;
	
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
		sqlSession.update("SQL.RC.updateUser", user);
		
	}

	public void updateUserOne(User user) {
		sqlSession.update("SQL.RC.updateUserOne", user);
	}

	public User selectOneUser(User user) {
		return sqlSession.selectOne("SQL.RC.selectOneUser", user);
	}

	public List<PordDeptDomain> getPordDeptDomain(PordDeptDomain pordDeptDomain) {
		return sqlSession.selectList("SQL.RC.getPordDeptDomain", pordDeptDomain);
	}

	public List<Photo> getPhoto(Photo photo) {
		return sqlSession.selectList("SQL.RC.getPhoto", photo);
	}

	public List<Mobel> getMobelList(Mobel mobel) {
		return sqlSession.selectList("SQL.RC.getMobelList", mobel);
	}

	public List<LshTable> getTableList(LshTable lshTable) {
		// oracl
		return sqlSession.selectList("SQL.RC.getTableList", lshTable);
	}

	public void testP(Map<String, Object> param) {
		sqlSession.selectList("SQL.RC.testP", param);
	}

}
