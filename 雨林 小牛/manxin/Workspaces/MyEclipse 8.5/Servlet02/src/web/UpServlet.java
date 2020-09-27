package web;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import entity.Emp;

import DAO.EmpDao;

import util.Factory;

public class UpServlet extends HttpServlet{
	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		
		String name = request.getParameter("name");
		int age = Integer.parseInt(request.getParameter("age"));
		double salary = Double.parseDouble(request.getParameter("salary"));
		int id = Integer.parseInt(request.getParameter("id"));
//		System.out.println(id);
		
		EmpDao dao = (EmpDao)Factory.getInstance("EmpDao");
		Emp emp = new Emp();
		emp.setD_id(id);
		emp.setD_name(name);
		emp.setD_age(age);
		emp.setD_salary(salary);
		try {
			dao.update(emp);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
