package com.yulin.web.control;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.OutputStream;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Random;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.omg.CORBA.Request;

import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGImageEncoder;
import com.yulin.web.entity.User;
import com.yulin.web.service.UserService;

public class UserServlet extends HttpServlet{
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		req.setCharacterEncoding("utf-8");
		resp.setCharacterEncoding("utf-8");
		resp.setContentType("text/html; charset=utf-8");
		
		String path = req.getRequestURI();
		path = path.substring(path.lastIndexOf("/"), path.lastIndexOf("."));
		
		HttpSession session = req.getSession();//获得session
		session.removeAttribute("msg_login");//删除session中的错误提示。
		
		if("/login".equals(path)){
			String id = req.getParameter("loginId");
			String pwd = req.getParameter("pwd");
			UserService us = new UserService();
			User u = us.login(id, pwd);
			if(u != null){
				
				Cookie newCookie = new Cookie("cookie",id+","+pwd);
				newCookie.setMaxAge(10000);
//				newCookie.setPath("/web03");
				resp.addCookie(newCookie);
				session.setAttribute("user", u); //将用户对象保存至session
				resp.sendRedirect("emplist.do"); //重定向到emplist
				
				//自动登录：取出Cookie列表中指定name的Value，value包含用户名和密码。
				//同一个路径下，同名的cookie会被后面的覆盖
			
				
			}else{
				session.setAttribute("msg_login", "用户名或者密码错误！");
				resp.sendRedirect("login.jsp");
			}
		}else if("/emplist".equals(path)){
			/*
			 * 自动登录 
			 */
			Cookie[] cookie = req.getCookies();//获得应用下所有的Cookie
			System.out.println("size:"+cookie.length);
			for(Cookie c : cookie){
				System.out.println("name:"+c.getName());
				System.out.println("value:"+c.getValue());
//				System.out.println(c.getName()+","+c.getPath());
				if ("cookie".equals(c.getName())) {
					String ss[] = c.getValue().split(",");
					String name=ss[0];
					String pwd=ss[1];
					UserService us = new UserService();
					User u =us.login(name, pwd);
					session.setAttribute("user", u);
				}
			}
			User u = (User)session.getAttribute("user");
			if(u == null){
				resp.sendRedirect("login.jsp");
			}else{
				ArrayList<User> list = new UserService().getAll();
				req.setAttribute("list", list);
				req.getRequestDispatcher("emplist.jsp").forward(req, resp);//转发
			}
		}else if("/toUpdate".equals(path)){
			String loginId = req.getParameter("loginId");//获得更新求传过来的id
			User u = new UserService().findById(loginId);//通过id查询User并获得User
			req.setAttribute("user", u);//将user绑定到request
			req.getRequestDispatcher("updateEmp.jsp").forward(req, resp);//转发
		}else if("/updateEmp".equals(path)){
			String loginId = req.getParameter("loginId");
			String name = req.getParameter("name");
			int salary = Integer.parseInt(req.getParameter("salary"));
			int age = Integer.parseInt(req.getParameter("age"));
			new UserService().update(loginId, name, salary, age);
			resp.sendRedirect("emplist.do");
		}else if("/image".equals(path)){
			/* 做5位数字的验证码 */
			/*	1. 验证码范围 : 10000 ~ 99999。
			 *  2. 生成一张图片，图片的内容是验证码。
			 *  3. 获得response对象的输出流。
			 *  4. 将图片发送到浏览器。
			 */
			int checkCode = new Random().nextInt(89999) + 10001;
			session.setAttribute("checkCode", checkCode);
			BufferedImage image = new BufferedImage(
					60, 20, BufferedImage.TYPE_INT_RGB); //创建图片对象。
			Graphics g = image.getGraphics(); //获得图片的"画笔"
			g.setColor(Color.WHITE);
			g.fillRect(0, 0, 60, 20); //画一个矩形
			g.setColor(Color.BLACK);
			g.drawString(""+checkCode, 10, 15);
			resp.setContentType("image/jpeg"); //设置相应数据类型
			OutputStream os = resp.getOutputStream(); //获得想一个输出流
			JPEGImageEncoder je = 
				JPEGCodec.createJPEGEncoder(os);  //创建一个解析图片的工具
			je.encode(image); //将图片压缩成数据流
		}
	}
}








