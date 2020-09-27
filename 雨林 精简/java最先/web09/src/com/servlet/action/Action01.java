package com.servlet.action;

import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
/**
 * (一)通过Servlet组件的生命周期
 * 第一阶段：初始化阶段，
 * 			当请求第一次到达的时候执行，而且只执行一次。
 * 			包括 init()和init(ServletConfig config)同时存在，则会调用有参的初始化方法。 
 * 第二阶段：处理业务阶段
 * 			当请求到达的时候就调用，执行多次，多少请求就执行多少次
 * 			包括Service，doGet，doPost三个方法
 * 			请求首先到达service方法，service会判断请求类型，如果get请求则调用doGet方法
 * 			处理业务，如果是post方法，则service方法会调用doPost方法出处理业务。
 * 第三阶段：销毁阶段
 * 			当web服务器停止时候执行，也是只执行一次。
 * 注意一：是web服务器(容器)在调用生命周期的方法。
 * 注意二：web服务器会为Servlet组件只创建一个对象，然后每个请求开启一个线程来处理相应请求。
 */
public class Action01 extends HttpServlet{

	
	//初始化的阶段
	public void init() throws ServletException {
		System.out.println("第一阶段：初始化阶段");
	}


	protected void service(HttpServletRequest arg0, HttpServletResponse arg1)
			throws ServletException, IOException {
	System.out.println("第二阶段：处理业务阶段");
	}


	
	public void destroy() {
		System.out.println("第三阶段：销毁阶段");
	}
	
}
