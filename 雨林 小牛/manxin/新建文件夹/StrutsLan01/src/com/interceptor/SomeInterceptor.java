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
		System.out.println("����Action֮ǰ����");
		ai.invoke();
		/*
		 *  �������ô���������Action
		 * ���Ƕ�Action����Ȩ��һ������
		 * ���˴������ø÷�������ô��Ӧ��Action������ִ��
		 * */
		System.out.println("����Action֮�󡣡�");
		return "error";
	}
	
}