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
		System.out.println("初始化Servlet....");
	}
	
	
	public void service1(ServletRequest request, ServletResponse response)
			throws ServletException, IOException {
		System.out.println("Servlet开始执行了....");
		
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
		 * 体重(kg)/(身高(m)的平方)
		 * 计算出BMI
		 * 男：<20 偏瘦 		21~25 标准		26~30 超重		>30 肥胖
		 * 女：<19 偏瘦 		20~24 标准		25~29 超重		>29 肥胖
		 */
		resp.setCharacterEncoding("gbk"); //设置响应的编码格式.
		Writer out = resp.getWriter(); //通过响应对象获得页面输出工具
		
		double bmi = 22.22;
		if(bmi>=21 && bmi<=25){
//			resp.sendRedirect("bz.html"); //跳转到指定的页面
			out.write("<center><h1>"+name+"先生/女士,您的身体状况为:标准</h1></center>");
		}
		out.close();
	}

	@Override
	public void destroy() {
		System.out.println("Servlet被销毁了....");
	}
}






