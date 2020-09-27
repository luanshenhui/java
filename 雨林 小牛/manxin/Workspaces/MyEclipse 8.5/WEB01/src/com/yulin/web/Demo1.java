package com.yulin.web;

import java.io.IOException;
import java.io.Writer;

import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Demo1 extends HttpServlet{
	/**
	 * Servlet 生命周期
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void init() throws ServletException{
		System.out.println("初始化Servlet......");
	}
	
	public void service1(ServletRequest request, ServletResponse response)
			throws ServletException, IOException {
		System.out.println("Servlet开始执行了");
		System.out.println(request.getServerName());
		System.out.println(request.getLocalName());
		System.out.println(request.getRemoteAddr());
		System.out.println(request.getRemoteHost());
		System.out.println(request.getScheme());	//使用的协议
	}
	
//	@Override
//	protected void service(HttpServletRequest request, HttpServletResponse arg1)
//			throws ServletException, IOException {
//		System.out.println("Servlet开始执行了");
//		System.out.println(request.getServerName());
//		System.out.println(request.getLocalName());
//		System.out.println(request.getRemoteAddr());
//		System.out.println(request.getRemoteHost());
//		System.out.println(request.getScheme());
//		
//		System.out.println(request.getPathInfo());
//		System.out.println(request.getPathTranslated());
//		System.out.println(request.getRequestURL());
//		System.out.println(request.getServletPath());
//	}
	
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse resp)
		throws ServletException, IOException {
		request.setCharacterEncoding("gdk");
		String name = request.getParameter("name");
		String sex = request.getParameter("sex");
		String sg = request.getParameter("sg");
		String tz = request.getParameter("tz");
		System.out.println("name:"+name+",sex:"+sex+",sg:"+sg+",tz:"+tz);
		/**
		 * 计算出BMI		体重(kg)/身高(m)的平方
		 * 男：<20偏瘦	21~25标准	26~30超重	>30肥胖
		 * 女：<19偏瘦	20~24标准	25~29超重	>29肥胖
		 **/
		resp.setCharacterEncoding("gbk");//设置编码的格式
		Writer out = resp.getWriter();//通过响应，获得页面输出工具
		
		double BMI = Double.parseDouble(tz)/(Double.parseDouble(sg)*Double.parseDouble(sg));
		System.out.println(BMI);
		if(sex.equals("1")){
			if(BMI <= 20){
//				resp.sendRedirect("bz.html");//跳转到制定页面
				out.write("<center><h1>"+name+"先生，您的身体状况为：偏瘦</h1></center>");
			}else if(BMI >=21 && BMI <=25){
				out.write("<center><h1>"+name+"先生，您的身体状况为：标准</h1></center>");
			}else if(BMI <= 26 && BMI >= 30){
				out.write("<center><h1>"+name+"先生，您的身体状况为：超重</h1></center>");
			}else if(BMI >= 30){
				out.write("<center><h1>"+name+"先生，您的身体状况为：肥胖</h1></center>");
			}
			
		}else if(sex.equals("0")){
			if(BMI <= 19){
				out.write("<center><h1>"+name+"女生，您的身体状况为：偏瘦</h1></center>");
			}else if(BMI >=20 && BMI <=24){
				out.write("<center><h1>"+name+"女生，您的身体状况为：标准</h1></center>");
			}else if(BMI <= 25 && BMI >= 29){
				out.write("<center><h1>"+name+"女生，您的身体状况为：超重</h1></center>");
			}else if(BMI >= 29){
				out.write("<center><h1>"+name+"女生，您的身体状况为：肥胖</h1></center>");
			}
		}
		out.close();
	}

	@Override
	public void destroy() {
		System.out.println("Servlet被销毁了.....");
	}
}
