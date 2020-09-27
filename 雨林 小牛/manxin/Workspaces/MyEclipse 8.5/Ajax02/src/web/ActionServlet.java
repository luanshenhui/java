package web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ActionServlet extends HttpServlet{
	
	private static final long serialVersionUID = 1L;

	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		PrintWriter out = response.getWriter();
		String path = request.getRequestURI();
		path = path.substring(path.lastIndexOf("/"),path.lastIndexOf("."));
		if("/check_username".equals(path)){
			String name = request.getParameter("username");
			System.out.println("name:" + name);
			String pwd = request.getParameter("pwd");
			if("张三".equals(name)){
				out.println("用户名已存在");
			}else{
				out.println("可以使用");
			}
		}
	}
}
