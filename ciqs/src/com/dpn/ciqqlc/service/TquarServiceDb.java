package com.dpn.ciqqlc.service;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.dpn.ciqqlc.standard.model.Tquar;
import com.dpn.ciqqlc.standard.service.TquarService;

@Repository("tquarServiceDbService")
public class TquarServiceDb implements TquarService {

	
	@Autowired
	@Qualifier("blankSST")
	private SqlSession sqlSession;
	
	@Override
	public int deleteByPrimaryKey(String ID) {
		return sqlSession.delete("SQL.Tquar.deleteByPrimaryKey", ID);
	}

	@Override
	public int insert(Tquar record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insertSelective(Tquar record) {
		return sqlSession.insert("SQL.Tquar.insertSelective", record);
	}

	@Override
	public Tquar selectByPrimaryKey(String ID) {
		return sqlSession.selectOne("SQL.Tquar.selectByPrimaryKey", ID);
	}

	@Override
	public int updateByPrimaryKeySelective(Tquar record) {
		return sqlSession.update("SQL.Tquar.updateByPrimaryKeySelective", record);
	}

	@Override
	public int updateByPrimaryKey(Tquar record) {
		// TODO Auto-generated method stub
		return 0;
	}

}
