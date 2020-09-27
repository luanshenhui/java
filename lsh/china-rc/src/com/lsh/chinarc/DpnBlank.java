/* 
 * File license
 */
package com.lsh.chinarc;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Main class of {@code DpnBlank}.
 * 
 * @author zhanglin@dpn.com.cn
 * @since 1.0.0 zhanglin@dpn.com.cn
 * @version 1.0.0 zhanglin@dpn.com.cn
 */
/* *****************************************************************************
 * 备忘记录
 * -> 使用此类作为项目java代码编写的格式模板。
********************************************************************************
 * 变更履历
 * -> 1.0.0 2016-07-07 zhanglin@dpn.com.cn : 初建。
***************************************************************************** */
public final class DpnBlank {
    
    /* **** fields ********************************************************** */
    
    /* external */
    
    /* internal */
    
    /* **** static blocks *************************************************** */
    
    /* **** constructors **************************************************** */
    
    /**
     * {@code DpnBlank} instances should <b>NOT</b> be constructed in
     * standard programming.
     * 
     * @throws AssertionError if use this constructer.
     * @since 1.0.0 zhanglin@dpn.com.cn
     */
    private DpnBlank() {
        /*
         * 在编程中应该禁止类的实例化。
         * 异常语句保证此类的构造函数不可在类的内部被误调用。
         */
        throw new AssertionError("ERROR : CAN NOT create instance{class="
                + DpnBlank.class.getName() + "} by its constructor.");
    }
    
    /* **** methods ********************************************************* */
    
    /* abstract */
    
    /* override */
    
    /* external */
    
    /* internal */
    
    /* **** inner classes *************************************************** */
    
    /**
     * {@code DpnBlank}-self constants.
     * 
     * @since 1.0.0 zhanglin@dpn.com.cn
     */
    public static final class SELF {
        
        public static final String PROD_ID = "BLANK";
        
        public static final String SSOP_ID = "BLANK";
        
        /**
         * {@code DpnBlank.SELF} instances should <b>NOT</b> be
         * constructed in standard programming.
         * 
         * @throws AssertionError if use this constructer.
         * @since 1.0.0 zhanglin@dpn.com.cn
         */
        private SELF() {
            /*
             * 在编程中应该禁止类的实例化。
             * 异常语句保证此类的构造函数不可在类的内部被误调用。
             */
            throw new AssertionError("ERROR : CAN NOT create instance{class="
                    + SELF.class.getName() + "} by its constructor.");
        }
        
    }
    
    /**
     * {@code DpnBlank}-LOGGER constants.
     * 
     * @since 1.0.0 zhanglin@dpn.com.cn
     */
    public static final class LOGGER {
        
        public static final Logger PROFILE = LoggerFactory.getLogger("PROFILE");
        
        /**
         * {@code DpnBlank.LOGGER} instances should <b>NOT</b> be
         * constructed in standard programming.
         * 
         * @throws AssertionError if use this constructer.
         * @since 1.0.0 zhanglin@dpn.com.cn
         */
        private LOGGER() {
            /*
             * 在编程中应该禁止类的实例化。
             * 异常语句保证此类的构造函数不可在类的内部被误调用。
             */
            throw new AssertionError("ERROR : CAN NOT create instance{class="
                    + LOGGER.class.getName() + "} by its constructor.");
        }
        
    }
    
}
