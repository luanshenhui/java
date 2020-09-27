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
		req.setCharacterEncoding("UTF-8");//1设置编码，doget不好用，只能dopost
		//使用tomcat发生乱码原因
		//浏览器数据(jsp:utf-8)->tomcat(iso8859-1)->我们看到的乱码
		
//		byte[]brr= req.getParameter("username").getBytes("iso8859-1");
//		String s=new String(brr,"utf-8");;
//		System.out.println(s);//通用
		
		String username=req.getParameter("username");
		System.out.println(username);
		String password=req.getParameter("password");
		System.out.println(password);
		//2request请求常用方法
		//getParameter
		String city=req.getParameter("city");
		System.out.println(city);
		String info=req.getParameter("info");
		System.out.println(info);
		String id=req.getParameter("id");
		System.out.println(id);
		
		String sex=req.getParameter("sex");
		System.out.println(sex);
		//3request请求常用方法
		//getParameterValues获取多值
		String[] like=req.getParameterValues("like");
		for(String s:like){
		System.out.println(s);
		}
		//4转发
		req.getRequestDispatcher("/page/b.jsp").forward(req, resp);
		
		//response回应对象的常用方法
		//((1)请求重定向)
		//resp.sendRedirect("/web13/page/b.jsp");
	}
	

}
