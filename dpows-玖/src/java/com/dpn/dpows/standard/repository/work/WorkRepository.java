package com.dpn.dpows.standard.repository.work;

import java.util.List;
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
    public WorkDeclareDto getWorkDeclareDto(Map<String,String> map) throws Exception{
        //map.put("id","");//getObject必须限定id条件
        return (WorkDeclareDto)this.sqlSession.selectOne("work.getListWorkDeclareDto", map);
    }

    public List<WorkDeclareDto> getListWorkDeclareDto(Map<String,String> map) throws Exception{
        return this.sqlSession.selectList("work.getListWorkDeclareDto", map);
    }

    public Integer getSizeWorkDeclareDto(Map<String,String> map) throws Exception{
        Integer num = (Integer)this.sqlSession.selectOne("work.getSizeWorkDeclareDto", map);
        if(null == num){
            num = new Integer(0);
        }

        return num;
    }

    public void insertWorkDeclareDto(WorkDeclareDto dto) throws Exception{
        this.sqlSession.insert("work.insertWorkDeclareDto", dto);
    }

    public void updateWorkDeclareDto(WorkDeclareDto dto) throws Exception{
        this.sqlSession.update("work.updateWorkDeclareDto", dto);
    }

    public void deleteWorkDeclareDto(Map<String,String> map) throws Exception{
        this.sqlSession.delete("work.deleteWorkDeclareDto", map);
    }



    //###########################################  < WorkDeclareGoodsDto >  ###########################################
    public WorkDeclareGoodsDto getWorkDeclareGoodsDto(Map<String,String> map) throws Exception{
        //map.put("id","");//getObject必须限定id条件
        return (WorkDeclareGoodsDto)this.sqlSession.selectOne("work.getListWorkDeclareGoodsDto", map);
    }

    public List<WorkDeclareGoodsDto> getListWorkDeclareGoodsDto(Map<String,String> map) throws Exception{
        return this.sqlSession.selectList("work.getListWorkDeclareGoodsDto", map);
    }

    public Integer getSizeWorkDeclareGoodsDto(Map<String,String> map) throws Exception{
        Integer num = (Integer)this.sqlSession.selectOne("work.getSizeWorkDeclareGoodsDto", map);
        if(null == num){
            num = new Integer(0);
        }

        return num;
    }

    public void insertWorkDeclareGoodsDto(WorkDeclareGoodsDto dto) throws Exception{
        this.sqlSession.insert("work.insertWorkDeclareGoodsDto", dto);
    }

    public void updateWorkDeclareGoodsDto(WorkDeclareGoodsDto dto) throws Exception{
        this.sqlSession.update("work.updateWorkDeclareGoodsDto", dto);
    }

    public void deleteWorkDeclareGoodsDto(Map<String,String> map) throws Exception{
        this.sqlSession.delete("work.deleteWorkDeclareGoodsDto", map);
    }
   
    
    
    
    
  //###########################################  < WorkDeclareAndGoods >  ###########################################
    public List<WorkDeclareDto> getListWorkDeclareAndGoods(Map<String,String> map) throws Exception{
        return this.sqlSession.selectList("work.getListWorkDeclareAndGoods", map);
    }
    
    
    public Integer getSizeWorkDeclareAndGoods(Map<String,String> map) throws Exception{
        Integer num = (Integer)this.sqlSession.selectOne("work.getSizeWorkDeclareAndGoods", map);
        if(null == num){
            num = new Integer(0);
        }

        return num;
    }
    

	
}
