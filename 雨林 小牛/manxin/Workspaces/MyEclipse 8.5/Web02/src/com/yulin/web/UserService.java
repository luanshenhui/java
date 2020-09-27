package com.yulin.web;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UserService extends HttpServlet{
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String loginId = req.getParameter("loginid");
		String pwd = req.getParameter("pwd1");
		String name = req.getParameter("name");
		System.out.println("loginId:"+loginId+"pwd:"+pwd+"name:"+name);
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String loginId = req.getParameter("loginid");
		String pwd = req.getParameter("pwd1");
		String name = req.getParameter("name");
		System.out.println("loginId:"+loginId+"pwd:"+pwd+"name:"+name);
	}
	
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		UserDao ud = new UserDao();
		String path = req.getRequestURI();//获得路径
		System.out.println("路径："+path);
		path = path.substring(path.lastIndexOf("/"), path.lastIndexOf("."));//获得请求路径
		if(path.equals("/regist")){
			System.out.println("执行注册");
			int loginid = Integer.parseInt(req.getParameter("loginid"));
			int pwd = Integer.parseInt(req.getParameter("pwd1"));
			String name = req.getParameter("name");
			User user = new User(loginid,pwd,name);
			System.out.println(ud.insertUser(user));
			
		}else if(path.equals("/login")){
			System.out.println("执行登录");
			int loginid = Integer.parseInt(req.getParameter("loginId"));
			int pwd = Integer.parseInt(req.getParameter("pwd"));
			User u = ud.find(loginid, loginid);
			if(u!=null){
				System.out.println("登录成功");
			}else{
				System.out.println("登录失败");
			}
		}
	}
}
