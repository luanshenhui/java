package com.lsh.qq;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Action01 extends HttpServlet {

	
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		this.doPost(req, resp);
	}

	
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		System.out.println("01");
		//req.getRequestDispatcher("/02").forward(req, resp);
		resp.sendRedirect("/web15/02");
		//����ת��������ת��ִ�к��������
		//�Ӷ�������ִ�������ݣ�����ת
		System.out.println("************");
		
	}
	
	
	

}
