package com.cost.interceptor;

import java.util.Map;

import com.cost.entity.Cost_Admin;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.Interceptor;

public class LoginInterceptor implements Interceptor{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void destroy() {
		// TODO Auto-generated method stub
	}

	public void init() {
		// TODO Auto-generated method stub
	}

	public String intercept(ActionInvocation ai) throws Exception {
		// TODO Auto-generated method stub
		//1,取得session
		Map<String, Object> session = 
			ai.getInvocationContext().getSession();
		//2,从session中取得登录信息
		Cost_Admin admin = (Cost_Admin)session.get("admin");
		//3,根据登录信息判断是否登陆过
		if(admin == null){
			/*
			 * 说明没有登录，不用调用Action，
			 * 而是返回字符串Login，找name为
			 * login的Result，进而去登录页面 
			 * */
			return "login";
		}else{
			//调用Action
			return ai.invoke();
		}
	}

}
