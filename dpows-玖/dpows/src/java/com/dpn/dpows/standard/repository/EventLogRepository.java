package com.dpn.dpows.standard.repository;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

@Repository("eventLog")
public class EventLogRepository {

	@Autowired
    @Qualifier("dposSST")
    private SqlSession sqlSession = null;
	
	
	public void insertEventLog(Map<?, ?> map) {
		sqlSession.insert("log.insertEventLog", map);
	}
}
