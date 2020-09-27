package com.yulin.web;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UserService extends HttpServlet{

	
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String path = req.getRequestURI();
		System.out.println(path);
		
		path = path.substring(path.lastIndexOf("/"), path.lastIndexOf("."));
		//获得请求路径
		
		if(path.equals("/regist")){
			System.out.println("执行注册！");
		}else if(path.equals("/login")){
			System.out.println("执行登录！");
		}
			
			
	}
}






