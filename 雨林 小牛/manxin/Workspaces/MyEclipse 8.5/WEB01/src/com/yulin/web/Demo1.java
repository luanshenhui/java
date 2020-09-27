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
	 * Servlet ��������
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void init() throws ServletException{
		System.out.println("��ʼ��Servlet......");
	}
	
	public void service1(ServletRequest request, ServletResponse response)
			throws ServletException, IOException {
		System.out.println("Servlet��ʼִ����");
		System.out.println(request.getServerName());
		System.out.println(request.getLocalName());
		System.out.println(request.getRemoteAddr());
		System.out.println(request.getRemoteHost());
		System.out.println(request.getScheme());	//ʹ�õ�Э��
	}
	
//	@Override
//	protected void service(HttpServletRequest request, HttpServletResponse arg1)
//			throws ServletException, IOException {
//		System.out.println("Servlet��ʼִ����");
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
		 * �����BMI		����(kg)/���(m)��ƽ��
		 * �У�<20ƫ��	21~25��׼	26~30����	>30����
		 * Ů��<19ƫ��	20~24��׼	25~29����	>29����
		 **/
		resp.setCharacterEncoding("gbk");//���ñ���ĸ�ʽ
		Writer out = resp.getWriter();//ͨ����Ӧ�����ҳ���������
		
		double BMI = Double.parseDouble(tz)/(Double.parseDouble(sg)*Double.parseDouble(sg));
		System.out.println(BMI);
		if(sex.equals("1")){
			if(BMI <= 20){
//				resp.sendRedirect("bz.html");//��ת���ƶ�ҳ��
				out.write("<center><h1>"+name+"��������������״��Ϊ��ƫ��</h1></center>");
			}else if(BMI >=21 && BMI <=25){
				out.write("<center><h1>"+name+"��������������״��Ϊ����׼</h1></center>");
			}else if(BMI <= 26 && BMI >= 30){
				out.write("<center><h1>"+name+"��������������״��Ϊ������</h1></center>");
			}else if(BMI >= 30){
				out.write("<center><h1>"+name+"��������������״��Ϊ������</h1></center>");
			}
			
		}else if(sex.equals("0")){
			if(BMI <= 19){
				out.write("<center><h1>"+name+"Ů������������״��Ϊ��ƫ��</h1></center>");
			}else if(BMI >=20 && BMI <=24){
				out.write("<center><h1>"+name+"Ů������������״��Ϊ����׼</h1></center>");
			}else if(BMI <= 25 && BMI >= 29){
				out.write("<center><h1>"+name+"Ů������������״��Ϊ������</h1></center>");
			}else if(BMI >= 29){
				out.write("<center><h1>"+name+"Ů������������״��Ϊ������</h1></center>");
			}
		}
		out.close();
	}

	@Override
	public void destroy() {
		System.out.println("Servlet��������.....");
	}
}
