/* 
 * File license
 */
package com.dpn.ciqqlc.common.component;

import org.springframework.context.ApplicationContext;

import com.dpn.arch.web.DpnWebLoader.Cache;

/**
 * DpnBlankCache.
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
public class DpnBlankCache
        implements Cache {
        
    /* **** fields ********************************************************** */
    
    /* external */
    
    /* internal */
    
    /**
     * ATTRIBUTE_NAME_ARRAY.
     * 
     * @since 1.0.0 zhanglin@dpn.com.cn
     */
    private final static String[] ATTRIBUTE_NAME_ARRAY = new String[] {
            "demo" };
            
    /* **** static blocks *************************************************** */
    
    /* **** constructors **************************************************** */
    
    /* **** methods ********************************************************* */
    
    /* abstract */
    
    /* override */
    
    // DpnWebLoader.Cache.
    
    /**
     * @see com.dpn.arch.web.DpnWebLoader.Cache#getAttributeNames()
     * @since 1.0.0 zhanglin@dpn.com.cn
     */
    public String[] getAttributeNames() {
        return ATTRIBUTE_NAME_ARRAY;
    }
    
    /**
     * @see com.dpn.arch.web.DpnWebLoader.Cache#getAttributeValue(java.lang.String,
     *      org.springframework.context.ApplicationContext)
     * @since 1.0.0 zhanglin@dpn.com.cn
     */
    public Object getAttributeValue(final String name,
            final ApplicationContext ctx) {
        // 刷新所有 this.refreshAll();
        // 刷新局部 this.refresh(name);
        Object result = null;
        if (ATTRIBUTE_NAME_ARRAY[0].equals(name)) {
            result = "demo";
        }
        return result;
    }
    
    /* external */
    
    /* internal */
    
    /* **** inner classes *************************************************** */
    
}
