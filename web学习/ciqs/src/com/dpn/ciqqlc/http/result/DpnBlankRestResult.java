/* 
 * File license
 */
package com.dpn.ciqqlc.http.result;

/**
 * DpnBlankRestResult.
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
public class DpnBlankRestResult {
    
    /* **** fields ********************************************************** */
    
    /* external */
    
    /* internal */
    
    /**
     * status.
     * 
     * @since 1.0.0 zhanglin@dpn.com.cn
     */
    private String status = null; /* 系统处理成功、失败的状态标志。 */
                                  
    /**
     * result.
     * 
     * @since 1.0.0 zhanglin@dpn.com.cn
     */
    private Object result = null; /* 内容数据。 */
                                  
    /* **** static blocks *************************************************** */
    
    /* **** constructors **************************************************** */
    
    /* **** methods ********************************************************* */
    
    /* abstract */
    
    /* override */
    
    /* external */
    
    // GETs.
    
    public String getStatus() {
        return this.status;
    }
    
    public Object getResult() {
        return this.result;
    }
    
    // SETs.
    
    public void setStatus(final String status) {
        this.status = status;
    }
    
    public void setResult(final Object result) {
        this.result = result;
    }
    
    public DpnBlankRestResult succ() {
        this.setStatus("succ");
        return this;
    }
    
    public DpnBlankRestResult fail() {
        this.setStatus("fail");
        return this;
    }
    
    public DpnBlankRestResult result(final Object result) {
        if (result == null) {
            throw new IllegalArgumentException(
                    "The value of 'result' is illegal.");
        }
        this.setResult(result);
        return this;
    }
    
    /* internal */
    
    /* **** inner classes *************************************************** */
    
}
