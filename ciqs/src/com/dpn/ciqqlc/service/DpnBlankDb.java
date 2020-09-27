/* 
 * File license
 */
package com.dpn.ciqqlc.service;

import java.util.Date;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.dpn.ciqqlc.standard.service.DpnBlankDatabaseService;

/**
 * DpnBlankDb.
 * 
 * @author zhanglin@dpn.com.cn
 * @since 1.0.0 zhanglin@dpn.com.cn
 * @version 1.0.0 zhanglin@dpn.com.cn
 */
/* *****************************************************************************
 * 备忘记录
 * -> 数据库服务实现。
 ********************************************************************************
 * 变更履历
 * -> 1.0.0 2016-07-07 zhanglin@dpn.com.cn : 初建。
 ***************************************************************************** */
@Repository("dbServ")
public class DpnBlankDb
        implements DpnBlankDatabaseService {
        
    /* **** fields ********************************************************** */
    
    /* external */
    
    /* internal */
    
    /**
     * sqlSession.
     * 
     * @since 1.0.0 zhanglin@dpn.com.cn
     */
    @Autowired
    @Qualifier("blankSST")
    private SqlSession sqlSession = null;
    
    /* **** static blocks *************************************************** */
    
    /* **** constructors **************************************************** */
    
    /* **** methods ********************************************************* */
    
    /* abstract */
    
    /* override */
    
    // DpnBlankDatabaseService
    
    /**
     * @see com.dpn.ciqqlc.standard.service.DpnBlankDatabaseService#selectSysDt()
     * @since 1.0.0 zhanglin@dpn.com.cn
     */
    public Date selectSysDt() {
        return this.sqlSession.selectOne("SQL.SYS.selectDt");
    }
    
    /**
     * @see com.dpn.ciqqlc.standard.service.DpnBlankDatabaseService#selectSysGuid()
     * @since 1.0.0 zhanglin@dpn.com.cn
     */
    public String selectSysGuid() {
        return this.sqlSession.selectOne("SQL.SYS.selectGuid");
    }
    
	public String selectCreatUser() {
		// TODO Auto-generated method stub
		
		return null;
	}

	public String insertUpLoad() {
		// TODO Auto-generated method stub
		return null;
	}
    
    
    /* external */
    
    /* internal */
    
    /* **** inner classes *************************************************** */
    
}
