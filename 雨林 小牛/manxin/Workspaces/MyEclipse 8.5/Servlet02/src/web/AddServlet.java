package web;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import DAO.EmpDao;

import util.Factory;

import entity.Emp;

public class AddServlet extends HttpServlet{

	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		String name = request.getParameter("name");
		double salary = Double.parseDouble(request.getParameter("salary"));
		int age = Integer.parseInt(request.getParameter("age"));
		Emp emp = new Emp();
		emp.setD_name(name);
		emp.setD_salary(salary);
		emp.setD_age(age);
		EmpDao dao = (EmpDao)Factory.getInstance("EmpDao");
		try {
			dao.save(emp);
			System.out.println("OK");
		} catch (Exception e) {
			e.printStackTrace();
		}
		response.sendRedirect("list");
	}
	
}
