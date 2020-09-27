/* 
 * File license
 */
package com.dpn.ciqqlc.task;

import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.dpn.arch.sdk.model.DpnArchSdkModel.DATETIME;

/**
 * DpnBlankTask.
 * 
 * @author zhanglin@dpn.com.cn
 * @since 1.0.0 zhanglin@dpn.com.cn
 * @version 1.0.0 zhanglin@dpn.com.cn
 */
/* *****************************************************************************
 * 备忘记录
 * -> 
********************************************************************************
 * 变更履历
 * -> 1.0.0 2016-07-07 zhanglin@dpn.com.cn : 初建。
***************************************************************************** */
@Component("task")
public class DpnBlankTask {
    
    /* **** fields ********************************************************** */
    
    /* external */
    
    /* internal */
    
    /**
     * logger.
     * 
     * @since 1.0.0
     */
    private final Logger logger_ = LoggerFactory.getLogger(this.getClass());
    
    /* **** static blocks *************************************************** */
    
    /* **** constructors **************************************************** */
    
    /* **** methods ********************************************************* */
    
    /* abstract */
    
    /* override */
    
    /* external */
    
    /**
     * scheduled.
     * 
     * @since 1.0.0
     */
    @Scheduled(
        cron = "0 0/5 * * * ?")
    public void scheduled() {
        /*
         * 0 0/5 * * * ?
         * 每5分钟执行一次。
         */
        Date curr = new Date();
        this.logger_.debug(this.getClass().getName() + " execute at "
                + DATETIME.formatUiDt(curr));
        try {
        
        } catch (Exception e) {
            this.logger_.error("ERROR : .", e);
        } finally {
        
        }
    }
    
    /* internal */
    
    /* **** inner classes *************************************************** */
    
}
