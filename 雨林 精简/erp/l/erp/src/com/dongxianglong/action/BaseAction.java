package com.dongxianglong.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 所有控制器的父类,所有控制器继承此控制器
 * @author 董祥龙
 *
 * 2015-2-13上午09:48:35
 */

public abstract class BaseAction extends HttpServlet {

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		excute( request,  response);
		
	}
	
	
	/**
	 * 所有子类控制器的业务方法的抽象，谁继承，谁就去实现。
	 * @param request
	 * @param response
	 */
protected abstract void excute(HttpServletRequest request, HttpServletResponse response)
throws ServletException, IOException;
	
	
	
	

}
