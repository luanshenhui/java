/* 
 * File license
 */
package com.dpn.ciqqlc.http;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.dpn.ciqqlc.standard.service.DpnBlankDatabaseService;
import com.dpn.ciqqlc.standard.service.DpnBlankFlowService;

/**
 * DpnBlankPageController.
 * 
 * @author zhanglin@dpn.com.cn
 * @since 1.0.0 zhanglin@dpn.com.cn
 * @version 1.0.0 zhanglin@dpn.com.cn
 */
/* *****************************************************************************
 * 备忘记录
 * -> 以"/page"作为URL前缀的action，进行页面的处理。
********************************************************************************
 * 变更履历
 * -> 1.0.0 2016-07-07 zhanglin@dpn.com.cn : 初建。
***************************************************************************** */
@Controller
@RequestMapping(
    value = "/page")
public class DpnBlankPageController {
    
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
                                                   
    /**
     * flowServ.
     * 
     * @since 1.0.0 zhanglin@dpn.com.cn
     */
    @Autowired
    @Qualifier("flowServ")
    private DpnBlankFlowService flowServ = null; /* 数据库服务对象。 */
                                                 
    /* **** static blocks *************************************************** */
    
    /* **** constructors **************************************************** */
    
    /* **** methods ********************************************************* */
    
    /* abstract */
    
    /* override */
    
    /* external */
    
    /**
     * error.
     * 
     * @return
     * @since 1.0.0 zhanglin@dpn.com.cn
     */
    @RequestMapping(
        value = "/error")
    public ModelAndView error() {
        /*
         * 错误页面。
         * 参数如下：
         * ------------ required ------------
         * none.
         * ------------ optional ------------
         * none.
         */
        ModelAndView result = new ModelAndView();
        try {
            // STEP : 规范请求参数。
            // STEP : 注入请求参数。
            // STEP : 处理业务逻辑。
            // STEP : 注入返回结果。
        } catch (Exception e) {
            // STEP : 处理可控异常。
        }
        // STEP : 处理返回结果。
        // result.setViewName("forward:/WEB-INF/jsp/error.jsp");
        // result.setViewName("redirect:http://www.dpn.com.cn/");
        result.setViewName("error");
        return result;
    }
    
    /**
     * wel.
     * 
     * @return
     * @since 1.0.0 zhanglin@dpn.com.cn
     */
    @RequestMapping(
        value = "/wel")
    public ModelAndView wel() {
        /*
         * 欢迎首页。
         * 参数如下：
         * ------------ required ------------
         * none.
         * ------------ optional ------------
         * none.
         */
        ModelAndView result = new ModelAndView();
        try {
            // STEP : 规范请求参数。
            // STEP : 注入请求参数。
            // STEP : 处理业务逻辑。
            // STEP : 注入返回结果。
        } catch (Exception e) {
            // STEP : 处理可控异常。
        }
        // STEP : 处理返回结果。
        result.setViewName("wel");
        return result;
    }
    
    /* internal */
    
    /* **** inner classes *************************************************** */
    
}
