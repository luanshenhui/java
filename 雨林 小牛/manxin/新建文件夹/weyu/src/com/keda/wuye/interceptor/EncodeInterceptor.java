package com.keda.wuye.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.Interceptor;

public class EncodeInterceptor implements Interceptor{

	public void destroy() {
		
	}

	public void init() {
		
	}

	public String intercept(ActionInvocation ai) throws Exception {
		HttpServletRequest request = ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		String path = ai.invoke();
		return path;
	}
	
}
