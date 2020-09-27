/* 
 * File license
 */
package com.dpn.ciqqlc.common.component;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.dpn.arch.web.component.DpnProfileFilter;

/**
 * Filter for profile.
 * 
 * @author zhanglin@dpn.com.cn
 * @since 1.0.0 zhanglin@dpn.com.cn
 * @version 1.0.0 zhanglin@dpn.com.cn
 */
/* *****************************************************************************
 * 备忘记录
 * -> 用于对请求进行记录分析的过滤器。
 * -> 需要slf4j的支持。
********************************************************************************
 * 变更履历
 * -> 1.0.0 2015-05-15 zhanglin@dpn.com.cn : 初建。
***************************************************************************** */
public class ProfileFilter
        extends DpnProfileFilter {
    
    /* **** fields ********************************************************** */
    
    /* external */
    
    /* internal */
    
    private static final Logger PROFILE = LoggerFactory.getLogger("PROFILE");
    
    /* **** static blocks *************************************************** */
    
    /* **** constructors **************************************************** */
    
    /* **** methods ********************************************************* */
    
    /* abstract */
    
    /* override */
    
    // DpnProfileFilter.
    
    /**
     * @see com.dpn.arch.web.component.DpnProfileFilter#isRecord()
     * @since 1.0.0 zhanglin@dpn.com.cn
     */
    @Override
    protected boolean isRecord() {
        /*
         * 用于配置是否记录解析信息。
         */
        return PROFILE == null ? false : PROFILE.isInfoEnabled();
    }
    
    /**
     * @see com.dpn.arch.web.component.DpnProfileFilter#isDetail()
     * @since 1.0.0 zhanglin@dpn.com.cn
     */
    @Override
    protected boolean isDetail() {
        /*
         * 用于配置输出的信息是否包含更加详细的请求信息。
         */
        return PROFILE == null ? false : PROFILE.isDebugEnabled();
    }
    
    /**
     * @see com.dpn.arch.web.component.DpnProfileFilter#doRecord(java.lang.String)
     * @since 1.0.0 zhanglin@dpn.com.cn
     */
    @Override
    protected void doRecord(final String profile) {
        /*
         * 对请求的详细信息进行记录操作。
         * 将此操作单独作为可继承的方法提供出来，
         * 目的是为了使用者可以覆盖此方法进行更个性化的修改。
         */
        if (PROFILE != null) {
            PROFILE.info(profile);
        }
    }
    
    /* external */
    
    /* internal */
    
    /* **** inner classes *************************************************** */
    
}
