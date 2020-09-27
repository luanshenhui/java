package web;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.Factory;
import dao.EmployeeDAO;
import entity.Employee;

public class ListEmpServlet extends HttpServlet{
	public void service(HttpServletRequest request,
			HttpServletResponse response) 
	throws ServletException,IOException{
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		try {
			EmployeeDAO dao = 
				(EmployeeDAO)Factory.getInstance(
						"EmployeeDAO");
			List<Employee> employees = dao.findAll();
			//输出一个表格
			//595165358   18642820892
			
			
			out.println("<table border='1' " +
					"width='60%' cellpadding='0' cellspacing='0'>");
			out.println("<tr><td>ID</td><td>姓名</td>" +
					"<td>薪水</td><td>年龄</td>" +
					"<td>操作</td></tr>");
			for(int i=0;i<employees.size();i++){
				Employee e = employees.get(i);
				int id = e.getId();
				String name = e.getName();
				double salary = e.getSalary();
				int age = e.getAge();
				out.println("<tr><td>" + id 
						+ "</td><td>" + name 
						+ "</td><td>" + salary 
						+ "</td><td>" + age 
						+ "</td><td><a href='del?id=" 
						+ id + "'>删除</a>" +
								"&nbsp;&nbsp;<a href='load?id=" 
						+ id + "'>修改</a></td></tr>");
			}
			out.println("</table>");
			out.println("<a href='addEmp.html'>" +
					"添加员工</a>");
		} catch (Exception e) {
			e.printStackTrace();
			out.println("稍后重试");
		}
	}
	
}
