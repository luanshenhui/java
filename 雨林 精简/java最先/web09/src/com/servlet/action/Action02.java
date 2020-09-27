package com.servlet.action;

import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *(二)Servlet的生命周期扩展深入 (1)初始化阶段：
 * 
 * 
 */

public class Action02 extends HttpServlet {
	// 无参数的初始化
	public void init() throws ServletException {
		System.out.println("无参数的方法");

	}

	// 有参数的初始化方法
	public void init(ServletConfig config) throws ServletException {
		System.out.println("有参数的方法");
	}
	
	

	
	protected void service(HttpServletRequest arg0, HttpServletResponse arg1)
			throws ServletException, IOException {
		System.out.println("service方法");
	}

	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		System.out.println("doGet方法");

	}

	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		System.out.println("doPost方法");

	}

	public void destroy() {

	}

}
