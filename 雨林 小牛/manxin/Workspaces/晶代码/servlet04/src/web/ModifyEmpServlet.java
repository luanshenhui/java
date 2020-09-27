package web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.Factory;
import dao.EmployeeDAO;
import entity.Employee;

public class ModifyEmpServlet extends HttpServlet {
	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		String id = request.getParameter("id");
		String name = request.getParameter("name");
		String salary = request.getParameter("salary");
		String age = request.getParameter("age");
		try {
			EmployeeDAO dao = 
				(EmployeeDAO)Factory.getInstance(
						"EmployeeDAO");
			Employee e = new Employee();
			e.setName(name);
			e.setSalary(Double.parseDouble(salary));
			e.setAge(Integer.parseInt(age));
			e.setId(Integer.parseInt(id));
			dao.modify(e);
			response.sendRedirect("list");
		} catch (Exception e) {
			e.printStackTrace();
			out.println("…‘∫Û÷ÿ ‘");
		}
	}
}
