package com.servlet.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet控制器组件在开发中的标准模板
 * 
 * @author Administrator
 * 
 */
public class Action03 extends HttpServlet {
/**
 * 处理get请求的业务方法
 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		//在doGet方法中调用doPost方法
		this.doPost(request, response);
	}
/**
 * 处理post请求的业务方法
 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		//核心的业务代码在此实现
	}

}
