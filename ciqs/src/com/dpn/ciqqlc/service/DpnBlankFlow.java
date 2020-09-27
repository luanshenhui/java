/* 
 * File license
 */
package com.dpn.ciqqlc.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.dpn.ciqqlc.standard.service.DpnBlankDatabaseService;
import com.dpn.ciqqlc.standard.service.DpnBlankFlowService;

/**
 * DpnBlankFlow.
 * 
 * @author zhanglin@dpn.com.cn
 * @since 1.0.0 zhanglin@dpn.com.cn
 * @version 1.0.0 zhanglin@dpn.com.cn
 */
/* *****************************************************************************
 * 备忘记录
 * -> 关键流程服务实现。
 ********************************************************************************
 * 变更履历
 * -> 1.0.0 2016-07-07 zhanglin@dpn.com.cn : 初建。
 ***************************************************************************** */
@Service("flowServ")
public class DpnBlankFlow
        implements DpnBlankFlowService {
        
    /* **** fields ********************************************************** */
    
    /* external */
    
    /* internal */
    
    /**
     * dbServ.
     * 
     * @since 1.0.0 zhanglin@dpn.com.cn
     */
    @Autowired
    @Qualifier("dbServ")
    private DpnBlankDatabaseService dbServ = null; /* 数据库服务对象。 */
                                                   
    /* **** static blocks *************************************************** */
    
    /* **** constructors **************************************************** */
    
    /* **** methods ********************************************************* */
    
    /* abstract */
    
    /* override */
    
    // DpnBlankFlowService.
    
    /**
     * @see com.dpn.ciqqlc.standard.service.DpnBlankFlowService#doOper(java.lang.String)
     * @since 1.0.0 zhanglin@dpn.com.cn
     */
    public boolean doOper(final String str) throws Exception {
        return true;
    }
    
    /* external */
    
    /* internal */
    
    /* **** inner classes *************************************************** */
    
}
