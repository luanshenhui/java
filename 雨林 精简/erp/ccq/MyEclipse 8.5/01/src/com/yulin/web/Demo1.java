package com.yulin.web;

import java.io.IOException;
import java.io.Writer;

import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Demo1 extends HttpServlet {
	
@Override

public void init() throws ServletException {
	System.out.println("��ʼ��");
}

	public void service1(ServletRequest request, ServletResponse response)
			throws ServletException, IOException {
	System.out.println("ִ����");
	System.out.println(request.getServerName());
	//request.getServerName();
	System.out.println(request.getLocalName());
	System.out.println(request.getRemoteAddr());
	System.out.println(request.getScheme());
	}
	@Override
		protected void service(HttpServletRequest request, HttpServletResponse resq)
				throws ServletException, IOException {
		System.out.println(request.getServerName());
		System.out.println(request.getLocalName());
		System.out.println(request.getRemoteAddr());
		System.out.println(request.getRemoteHost());
		System.out.println(request.getScheme());
		
		System.out.println(request.getPathInfo());
		System.out.println(request.getPathTranslated());
		System.out.println(request.getRequestURI());
		System.out.println(request.getScheme());
		
		 String name =request.getParameter("name");
		 String sex =request.getParameter("sex");
		 String sg =request.getParameter("sg");
		 String tz =request.getParameter("tz");
			System.out.println("name:"+name+",sex:"+sex+",sg:"+sg+",tz:"+tz);
		
			resq.setCharacterEncoding("gbk");//���ñ����ʽ
			Writer out=resq.getWriter();//ͨ����Ӧ������ҳ���������
			
			
			double bmi=Double.parseDouble(tz)/(Double.parseDouble(sg)*Double.parseDouble(sg)); 
			
			//double bmi=22.22;
			if(bmi>=0&&bmi<=1){
				out.write("<center><h1>"+name+"����/Ůʿ�����״��Ϊ����׼</h1></center>");
			}
			
			out.close();
			
			//resq.sendRedirect("bz.html");��ת���ƶ�ҳ��
		
		}

@Override
	public void destroy() {
		System.out.println("����");
	}
}
