/* 
 * File license
 */
package com.dpn.ciqqlc.standard.service;

/**
 * DpnBlankFlowService.
 * 
 * @author zhanglin@dpn.com.cn
 * @since 1.0.0 zhanglin@dpn.com.cn
 * @version 1.0.0 zhanglin@dpn.com.cn
 */
/* *****************************************************************************
 * 备忘记录
 * -> 关键流程服务接口。
********************************************************************************
 * 变更履历
 * -> 1.0.0 2016-07-07 zhanglin@dpn.com.cn : 初建。
***************************************************************************** */
public interface DpnBlankFlowService {
    
    /**
     * doOper.
     * 
     * @param str
     * @return
     * @throws Exception
     * @since 1.0.0 zhanglin@dpn.com.cn
     */
            boolean doOper(String str) throws Exception; /* 执行操作。 */
                                                         
}
