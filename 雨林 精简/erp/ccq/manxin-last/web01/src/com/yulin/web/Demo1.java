package com.yulin.web;

import java.io.IOException;
import java.io.Writer;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Demo1 extends HttpServlet{
	private static final long serialVersionUID = 1L;

	@Override
	public void init() throws ServletException {
		System.out.println("��ʼ��Servlet....");
	}
	
	
	public void service1(ServletRequest request, ServletResponse response)
			throws ServletException, IOException {
		System.out.println("Servlet��ʼִ����....");
		
		System.out.println(request.getServerName());
		System.out.println(request.getLocalName());
		System.out.println(request.getRemoteAddr());
		System.out.println(request.getRemoteHost());
		System.out.println(request.getScheme());
	}
	
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse resp)
			throws ServletException, IOException {
//		System.out.println(request.getParameter("name"));
		request.setCharacterEncoding("gbk");
		String name = request.getParameter("name");
		String sex = request.getParameter("sex");
		String sg = request.getParameter("sg");
		String tz = request.getParameter("tz");
		System.out.println("name:"+name+", sex:"+sex+",sg:"+sg+",tz:"+tz);
		/**
		 * ����(kg)/(���(m)��ƽ��)
		 * �����BMI
		 * �У�<20 ƫ�� 		21~25 ��׼		26~30 ����		>30 ����
		 * Ů��<19 ƫ�� 		20~24 ��׼		25~29 ����		>29 ����
		 */
		resp.setCharacterEncoding("gbk"); //������Ӧ�ı����ʽ.
		Writer out = resp.getWriter(); //ͨ����Ӧ������ҳ���������
		
		double bmi = 22.22;
		if(bmi>=21 && bmi<=25){
//			resp.sendRedirect("bz.html"); //��ת��ָ����ҳ��
			out.write("<center><h1>"+name+"����/Ůʿ,��������״��Ϊ:��׼</h1></center>");
		}
		out.close();
	}

	@Override
	public void destroy() {
		System.out.println("Servlet��������....");
	}
}






