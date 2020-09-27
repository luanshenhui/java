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
	System.out.println("初始化");
}

	public void service1(ServletRequest request, ServletResponse response)
			throws ServletException, IOException {
	System.out.println("执行了");
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
		
			resq.setCharacterEncoding("gbk");//设置编码格式
			Writer out=resq.getWriter();//通过响应对象获得页面输出工具
			
			
			double bmi=Double.parseDouble(tz)/(Double.parseDouble(sg)*Double.parseDouble(sg)); 
			
			//double bmi=22.22;
			if(bmi>=0&&bmi<=1){
				out.write("<center><h1>"+name+"先生/女士，你的状况为：标准</h1></center>");
			}
			
			out.close();
			
			//resq.sendRedirect("bz.html");跳转到制定页面
		
		}

@Override
	public void destroy() {
		System.out.println("销毁");
	}
}
