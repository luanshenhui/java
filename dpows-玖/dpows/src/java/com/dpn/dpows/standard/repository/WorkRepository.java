package com.dpn.dpows.standard.repository;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.dpn.dpows.standard.model.WorkDeclareDto;
import com.dpn.dpows.standard.model.WorkDeclareGoodsDto;




/**
 * WorkRepository.
 *
 * @author zhaoqian@dpn.com.cn
 * @version 1.0.0 zhaoqian@dpn.com.cn
 * @since 1.0.0 zhaoqian@dpn.com.cn
 * Created by ZhaoQian on 2017-9-6 14:27:26.
 *
**/
@Repository("workDao")
public class WorkRepository {
 
    @Autowired
    @Qualifier("dposSST")
    private SqlSession sqlSession = null;


    /* *** 实现 *** */
    //###########################################  < WorkDeclareDto >  ###########################################
    public Integer getSizeWorkDeclareDto(Map<String,String> map) throws Exception{
        Integer num = (Integer)this.sqlSession.selectOne("work.getSizeWorkDeclareDto", map);
        if(null == num){
            num = new Integer(0);
        }

        return num;
    }

    
    public void updateWorkDeclareDto(WorkDeclareDto dto) throws Exception{
        this.sqlSession.update("work.updateWorkDeclareDto", dto);
    }


    public void updateWorkDeclareGoodsDto(WorkDeclareGoodsDto dto) throws Exception{
        this.sqlSession.update("work.updateWorkDeclareGoodsDto", dto);
    }
    
    

	public void insertEventLog(Map<?, ?> map) {
		sqlSession.insert("log.insertEventLog", map);
	}
}
