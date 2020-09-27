package com.lsh.act;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 
 * 登陆的控制器，用来处理登陆的请求
 * 
 */
public class LoginAction extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}
	//B/S ：浏览器/服务器都是基于请求回应
//请求对象，相应对象  HttpServletRequest request, HttpServletResponse response
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		//获取表单数据
		String username=request.getParameter("username");
		String password=request.getParameter("password");
		//验证用户是否合发
		String path="";
		if(username.equals("abc") && password.equals("123")){
			path="/page/success.html";
		}else{
			path="/page/login.html";
		}
		//跳转
		//(1)请求转发(服务器端跳转)；path="/page/success.html"
		//(2)请求从定向(客户端跳转):path="/web10t/page/login.html"
		//这是第1种：：服务器接收请求，服务器取找资源，然后将资源内容发给浏览器，由于浏览器部知道服务器的位置，所以地址栏不变。
			request.getRequestDispatcher(path).forward(request, response);
		
			//第2 种::服务器接收请求，服务器将资源的路径发给浏览器，让浏览器自己访问资源，由于是
		//浏览器从新发起请求访问资源位置,所以地址栏改变
			//response.sendRedirect(path);
			
			/**
			 * 两种请求方式
			 * get请求：浏览器将表单中的数据以地址栏的方式发给服务器(/web/login?a=1&b=2))
			 * 缺点：不安全，大小受限，
			 * 优点：方便调试
			 * post请求：浏览器将表单中的数据以http请求头的方式发给浏览器(/web/login)
			 * 优缺点对调
			 */
	}

}
