package com.yulin.web;

import java.io.IOException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.SimpleTagSupport;

public class MyTag2 extends SimpleTagSupport{
	String msg;//被保存的信息
	String var;//保存时的名字
	String scope;//信息被保存的地方
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public String getVar() {
		return var;
	}
	public void setVar(String var) {
		this.var = var;
	}
	public String getScope() {
		return scope;
	}
	public void setScope(String scope) {
		this.scope = scope;
	}
	
	@Override
	public void doTag() throws JspException, IOException {
		PageContext pc = (PageContext)getJspContext();
		if("session".equals(scope)){
			pc.getSession().setAttribute(var, msg);
		}else if("request".equals(scope)){
			pc.getRequest().setAttribute(var, msg);
		}
		//完成.tld,并且在页面中用EL表达式获得内容
	}
	
}
