package com.yulin.web;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.SimpleTagSupport;

public class MyTag3 extends SimpleTagSupport{
	String content;	//循环的内容				
	int count;	//循环的次数
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
	
	
	
	@Override
	public void doTag() throws JspException, IOException {
		
		PageContext pc = (PageContext)getJspContext();//在页面输出		
		JspWriter out = pc.getOut();//out对象
		
		for(int i = 0; i < count; i++){
			this.getJspBody().invoke(null);
		}
	}
}
