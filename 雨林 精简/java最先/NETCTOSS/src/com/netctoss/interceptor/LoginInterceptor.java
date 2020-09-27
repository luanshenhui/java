package com.netctoss.interceptor;

import java.util.Map;

import com.netctoss.login.entity.AdminInfo;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.Interceptor;

public class LoginInterceptor implements Interceptor{

	public void destroy() {
		
	}

	public void init() {
		
	}

	public String intercept(ActionInvocation ai) throws Exception {
		Map<String,Object> session=ai.getInvocationContext().getSession();
		AdminInfo admin=(AdminInfo) session.get("admin");
		if(admin!=null){
			return ai.invoke();
		}else{
			return "login";
		}
	}

}
