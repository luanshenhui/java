package com.yulin.web.control;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.ResourceBundle.Control;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.yulin.web.entity.User;
import com.yulin.web.service.UserService;

public class UserServlet extends HttpServlet {
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		req.setCharacterEncoding("utf-8");
		resp.setCharacterEncoding("utf-8");
		resp.setContentType("text/html;charset=utf-8");
		String path = req.getRequestURI();
		path = path.substring(path.lastIndexOf("/"), path.lastIndexOf("."));
		UserService us = new UserService();
		if ("/regist".equals(path)) {
			String loginId = req.getParameter("loginId");
			String pwd = req.getParameter("pwd");
			String name = req.getParameter("name");
			if (!(us.regist(loginId, pwd, name))) {
				System.out.println("注册失败");
			} else {
				System.out.println("注册成功");// 利用转发机制，跳到登陆页面，将用户名和密码填写到登陆条中
				req.setAttribute("loginId", loginId);
				req.setAttribute("pwd", pwd);
				req.setAttribute("name", name);
				RequestDispatcher rd = req.getRequestDispatcher("login.jsp");// 获得转发工具
				rd.forward(req, resp);// 执行转发，把请求对象和相应对象一并转发给下一个请求。
			}
		} else if ("/login".equals(path)) {
			
			String loginId = req.getParameter("loginId");
			String pwd = req.getParameter("pwd");
			User u = us.login(loginId, pwd);
			if (u != null) {
				System.out.println("登录成功");
				req.setAttribute("user", u);// 将user对象带到下一个页面
				RequestDispatcher rd = req.getRequestDispatcher("emplist.do");
				rd.forward(req, resp);
			} else {
				System.out.println("登录失败");
			}
		} else if ("/emplist".equals(path)) {
			
			/*
			 * 获得所有员工的信息显示在页面 将登陆者的姓名显示在页面中 提示：
			 * 1.转发到emplist.jsp
			 * 2.在页面中利用java代码完成循环输出表格
			 * 3.表格中的数据利用EL表达式获得
			 */
			ArrayList<User> list = (ArrayList<User>) us.findAll();
			req.setAttribute("list", list); 
			req.getRequestDispatcher("emplist.jsp").forward(req, resp);
		}

	}
}


















