package com.dongxianglong.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * ���п������ĸ���,���п������̳д˿�����
 * @author ������
 *
 * 2015-2-13����09:48:35
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
	 * ���������������ҵ�񷽷��ĳ���˭�̳У�˭��ȥʵ�֡�
	 * @param request
	 * @param response
	 */
protected abstract void excute(HttpServletRequest request, HttpServletResponse response)
throws ServletException, IOException;
	
	
	
	

}
