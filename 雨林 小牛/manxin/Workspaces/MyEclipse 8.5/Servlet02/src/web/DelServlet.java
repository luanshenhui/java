package web;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import entity.Emp;
import DAO.EmpDao;
import util.Factory;

public class DelServlet extends HttpServlet{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		
		int id = Integer.parseInt(request.getParameter("id"));
		EmpDao dao = (EmpDao)Factory.getInstance("EmpDao");
		Emp emp = new Emp();
		emp.setD_id(id);
		try {
			dao.delete(emp);
			System.out.println("OK");
		} catch (Exception e) {
			e.printStackTrace();
		}
		response.sendRedirect("list");
	}
}
