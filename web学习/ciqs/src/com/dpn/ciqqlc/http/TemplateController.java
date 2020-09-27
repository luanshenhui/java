package com.dpn.ciqqlc.http;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * TemplateController.
 * 
 * @author
 * @since 1.0.0
 * @version 1.0.0
 */
/* *****************************************************************************
 * 备忘记录
 * -> 以"/template"作为URL前缀的action，进行打印模板管理的处理。
********************************************************************************
 * 变更履历
 * -> 
***************************************************************************** */
@Controller
@RequestMapping(
    value = "/template")
public class TemplateController {
	
	/**
     * 跳转
     * @param request
     * @return
     */
    @RequestMapping("/template1")
	public String organizesforward(HttpServletRequest request){
		return "template/template1";
	}
    @RequestMapping("/anjianyisonghan")
   	public String anjianyisonghan(HttpServletRequest request){
   		return "template/anjianyisonghan";
   	}
    @RequestMapping("/lianshenpibiao")
   	public String lianshenpibiao(HttpServletRequest request){
   		return "template/lianshenpibiao";
   	}
    @RequestMapping("/banlishenpibiao")
   	public String banlishenpibiao(HttpServletRequest request){
   		return "template/banlishenpibiao";
   	}
    @RequestMapping("/chuanranbingjilubiao")
   	public String chuanranbingjilubiao(HttpServletRequest request){
   		return "template/chuanranbingjilubiao";
   	}
    @RequestMapping("/chuanranbiandiaochabiao")
   	public String chuanranbiandiaochabiao(HttpServletRequest request){
   		return "template/chuanranbiandiaochabiao";
   	}
    @RequestMapping("/weishengkaohepingfenbiao")
   	public String weishengkaohepingfenbiao(HttpServletRequest request){
   		return "template/weishengkaohepingfenbiao";
   	}
    @RequestMapping("/weishengjiandujilubiao")
   	public String weishengjiandujilubiao(HttpServletRequest request){
   		return "template/weishengjiandujilubiao";
   	}
    @RequestMapping("/weishenggongzuojilubiao")
   	public String weishenggongzuojilubiao(HttpServletRequest request){
   		return "template/weishenggongzuojilubiao";
   	}
    @RequestMapping("/jianyijiandujilubiao1")
   	public String jianyijiandujilubiao1(HttpServletRequest request){
   		return "template/jianyijiandujilubiao1";
   	}
    @RequestMapping("/jianyijiandujilubiao2")
   	public String jianyijiandujilubiao2(HttpServletRequest request){
   		return "template/jianyijiandujilubiao2";
   	}
    @RequestMapping("/dangchangxingzhengchufapanjueshu")
   	public String dangchangxingzhengchufapanjueshu(HttpServletRequest request){
   		return "template/dangchangxingzhengchufapanjueshu";
   	}
    @RequestMapping("/xingzhengchufadiaochabaogao")
   	public String xingzhengchufadiaochabaogao(HttpServletRequest request){
   		return "template/xingzhengchufadiaochabaogao";
   	}
}
