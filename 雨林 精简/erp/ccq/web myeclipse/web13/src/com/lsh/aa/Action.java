package com.lsh.aa;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Action extends HttpServlet {


	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		this.doPost(req, resp);
	}


	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");//1���ñ��룬doget�����ã�ֻ��dopost
		//ʹ��tomcat��������ԭ��
		//���������(jsp:utf-8)->tomcat(iso8859-1)->���ǿ���������
		
//		byte[]brr= req.getParameter("username").getBytes("iso8859-1");
//		String s=new String(brr,"utf-8");;
//		System.out.println(s);//ͨ��
		
		String username=req.getParameter("username");
		System.out.println(username);
		String password=req.getParameter("password");
		System.out.println(password);
		//2request�����÷���
		//getParameter
		String city=req.getParameter("city");
		System.out.println(city);
		String info=req.getParameter("info");
		System.out.println(info);
		String id=req.getParameter("id");
		System.out.println(id);
		
		String sex=req.getParameter("sex");
		System.out.println(sex);
		//3request�����÷���
		//getParameterValues��ȡ��ֵ
		String[] like=req.getParameterValues("like");
		for(String s:like){
		System.out.println(s);
		}
		//4ת��
		req.getRequestDispatcher("/page/b.jsp").forward(req, resp);
		
		//response��Ӧ����ĳ��÷���
		//((1)�����ض���)
		//resp.sendRedirect("/web13/page/b.jsp");
	}
	

}
