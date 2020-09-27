package web;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.Factory;

import dao.EmpDAO;
import dao.EmpDAOImpl;
import entity.Emp;

public class AddEmpServlet extends HttpServlet{
	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("utf-8");
		String name = request.getParameter("name");
		double salary = Double.parseDouble(request.getParameter("salary"));
		int age = Integer.parseInt(request.getParameter("age"));
		Emp emp = new Emp();
		emp.setName(name);
		emp.setSalary(salary);
		emp.setAge(age);
		EmpDAO dao = (EmpDAO) Factory.getInstance("EmpDAO");
		try {
			dao.save(emp);
			System.out.println("≤Â»Î≥…π¶");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
	}
}
