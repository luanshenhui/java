package web;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.Factory;
import dao.EmployeeDAO;
import entity.Employee;

public class LoadEmpServlet extends HttpServlet{
	public void service(HttpServletRequest request,
			HttpServletResponse response) 
	throws ServletException,IOException{
		response.setContentType(
				"text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		String id = request.getParameter("id");
		try {
			EmployeeDAO dao = 
				(EmployeeDAO)Factory.getInstance(
						"EmployeeDAO");
			Employee e = dao.findById(
					Integer.parseInt(id));
			if( e != null){
				String name = e.getName();
				double salary = e.getSalary();
				int age = e.getAge();
				out.println("<form action='modify?id=" + id + "' method='post'>");
				out.println("id:" + id + "<br/>");
				out.println(
						"����:<input name='name' value='" 
						+ name + "'/><br/>");
				out.println(
						"нˮ:<input name='salary' value='" 
						+ salary + "'/><br/>");
				out.println(
						"����:<input name='age' value='" 
						+ age + "'/><br/>");
				out.println("<input type='submit' value='�ύ'/>");
				out.println("</form>");
			}
		} catch (Exception e) {
			e.printStackTrace();
			out.println("�Ժ�����");
		}
	}
}
