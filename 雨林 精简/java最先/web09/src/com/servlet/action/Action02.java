package com.servlet.action;

import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *(��)Servlet������������չ���� (1)��ʼ���׶Σ�
 * 
 * 
 */

public class Action02 extends HttpServlet {
	// �޲����ĳ�ʼ��
	public void init() throws ServletException {
		System.out.println("�޲����ķ���");

	}

	// �в����ĳ�ʼ������
	public void init(ServletConfig config) throws ServletException {
		System.out.println("�в����ķ���");
	}
	
	

	
	protected void service(HttpServletRequest arg0, HttpServletResponse arg1)
			throws ServletException, IOException {
		System.out.println("service����");
	}

	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		System.out.println("doGet����");

	}

	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		System.out.println("doPost����");

	}

	public void destroy() {

	}

}
