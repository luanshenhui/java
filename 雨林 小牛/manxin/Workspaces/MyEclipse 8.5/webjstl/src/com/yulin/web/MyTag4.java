package com.yulin.web;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.SimpleTagSupport;

public class MyTag4 extends SimpleTagSupport{
	ArrayList<Object> list;
	String var;
	
	public String getVar() {
		return var;
	}
	public void setVar(String var) {
		this.var = var;
	}
	public ArrayList<Object> getList() {
		return list;
	}
	public void setList(ArrayList<Object> list) {
		this.list = list;
	}
	@Override
	public void doTag() throws JspException, IOException {
		PageContext pc = (PageContext)getJspContext();
		for(int i = 0; i < list.size(); i++){//迭代集合
//			String str = list.get(i).getClass().toString();//getClass()获得对象本身的数据类型
			pc.getRequest().setAttribute(var, list.get(i));
			this.getJspBody().invoke(null);
		}
	}
}
