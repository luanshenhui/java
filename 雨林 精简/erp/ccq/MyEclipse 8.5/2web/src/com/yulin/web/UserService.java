package com.yulin.web;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UserService extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String loginId = req.getParameter("loginId");
		String pwd = req.getParameter("pwd1");
		String name = req.getParameter("name");
		System.out.println("loginId" + loginId + "pwd" + pwd + "name" + name);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String loginId = req.getParameter("loginId");
		String pwd = req.getParameter("pwd1");
		String name = req.getParameter("name");
		System.out.println("loginId" + loginId + "pwd" + pwd + "name" + name);
	}

	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// String loginId=req.getParameter("loginId");
		// String pwd=req.getParameter("pwd1");
		// String name=req.getParameter("name");
		// System.out.println("loginId"+loginId+"pwd"+pwd+"name"+name);
		super.service(req, resp);
		String path = req.getRequestURI();
		System.out.println(path);

		path = path.substring(path.lastIndexOf("/"), path.lastIndexOf("."));// 获得请求路径

		if (path.equals("/regist")) {
			System.out.println("执行注册");
		} else if (path.equals("/login")) {
			System.out.println("执行登陆");
		}
	}
}
