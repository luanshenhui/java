package com.interceptor;

import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.Interceptor;

public class SomeInterceptor implements Interceptor{

	public void destroy() {
		// TODO Auto-generated method stub
	}

	public void init() {
		// TODO Auto-generated method stub
	}

	public String intercept(ActionInvocation ai) throws Exception {
		System.out.println("调用Action之前。。");
		ai.invoke();
		/*
		 *  调用引用此拦截器的Action
		 * 这是对Action控制权的一个体现
		 * 若此处不调用该方法，那么对应的Action将不被执行
		 * */
		System.out.println("调用Action之后。。");
		return "error";
	}
	
}