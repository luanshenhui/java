/* 
 * File license
 */
package com.dpn.ciqqlc.standard.service;

import java.util.Date;

/**
 * DpnBlankDatabaseService.
 * 
 * @author zhanglin@dpn.com.cn
 * @since 1.0.0 zhanglin@dpn.com.cn
 * @version 1.0.0 zhanglin@dpn.com.cn
 */
/* *****************************************************************************
 * 备忘记录
 * -> 数据库服务接口。
********************************************************************************
 * 变更履历
 * -> 1.0.0 2016-07-07 zhanglin@dpn.com.cn : 初建。
***************************************************************************** */
public interface DpnBlankDatabaseService {
    
    // select.
    
    /**
     * Select current system datetime.
     * <ul>
     * <li>ORACLE - SELECT SYSDATE AS RESULT FROM DUAL</li>
     * <li>MYSQL - SELECT NOW() AS RESULT</li>
     * <li>DB2 - SELECT CURRENT TIMESTAMP AS RESULT FROM
     * SYSIBM.SYSDUMMY1</li>
     * <li>SQLSERVER - SELECT GETDATE() AS RESULT</li>
     * </ul>
     * 
     * @return
     * @since 1.0.0 zhanglin@dpn.com.cn
     */
            Date selectSysDt(); /* 查询数据库时间。 */
                                
    /**
     * Select current system guid.
     * <ul>
     * <li>ORACLE - SELECT SYS_GUID() AS RESULT FROM DUAL</li>
     * <li>MYSQL -</li>
     * <li>DB2 -</li>
     * <li>SQLSERVER -</li>
     * </ul>
     * 
     * @return
     * @since 1.0.0 zhanglin@dpn.com.cn
     */
            String selectSysGuid(); /* 查询数据库GUID。 */
                                    
    // insert.
    
    // update.
    
    // delete.
    
    // inner interface.
            
            String selectCreatUser(); /*查询数据库创建人对应的PORT_DEPT_CODE，PORT_ORG_CODE*/
            
            String insertUpLoad();/*上传*/

           
    
}
