package web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AddEmpServlet extends HttpServlet {
	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		String name = request.getParameter("name");
//		name = new String(
//				name.getBytes("iso-8859-1"),
//				"utf-8");
		String salary = request.getParameter("salary");
		String age = request.getParameter("age");
		/*
		 * 作用1：生成一个content-type消息头，
		 * 告诉浏览器返回的数据类型和编码格式。
		 * 作用2：设置out.println方法输出时所使用的
		 * 编码格式。
		 */
		response.setContentType(
				"text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("姓名:" + name + " 薪水: " + salary 
				+ " 年龄:" + age);
		out.close();
	}

}
