package com.servlet.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet����������ڿ����еı�׼ģ��
 * 
 * @author Administrator
 * 
 */
public class Action03 extends HttpServlet {
/**
 * ����get�����ҵ�񷽷�
 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		//��doGet�����е���doPost����
		this.doPost(request, response);
	}
/**
 * ����post�����ҵ�񷽷�
 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		//���ĵ�ҵ������ڴ�ʵ��
	}

}
