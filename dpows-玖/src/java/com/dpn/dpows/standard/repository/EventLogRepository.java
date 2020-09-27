package com.dpn.dpows.standard.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.dpn.dpows.standard.model.EventLogDto;

@Repository("eventLog")
public class EventLogRepository {

	@Autowired
    @Qualifier("dposSST")
    private SqlSession sqlSession = null;
	
	
	public void insertEventLog(Map<?, ?> map) {
		sqlSession.insert("SQL.TAB.LOG.insertEventLog", map);
	}
	
	public List<EventLogDto> getListEventLogDto(Map<String,String> map) throws Exception{
        return this.sqlSession.selectList("SQL.TAB.LOG.getListEventLogDto", map);
    }

    public Integer getSizeEventLogDto(Map<String,String> map) throws Exception{
        Integer num = (Integer)this.sqlSession.selectOne("SQL.TAB.LOG.getSizeEventLogDto", map);
        if(null == num){
            num = new Integer(0);
        }
        return num;
    }
}
