package com.yulin.interceptor;

import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.Interceptor;

public class SomeInterceptor implements Interceptor{

	public void destroy() {
		// TODO Auto-generated method stub
		
	}
	public void init() {
		// TODO Auto-generated method stub

	}
	
	public String intercept(ActionInvocation ai) throws Exception{
		System.out.println("����Actionǰ...");
		/**
		 * ����ҽ�ô���������Action��
		 * ���Ƕ�Action����Ȩ��һ������
		 * ���˴������ø÷�������ô��Ӧ��
		 * Action������ִ��
		 */
		ai.invoke();
		System.out.println("����Action��...");
		return "error";
	}

}
