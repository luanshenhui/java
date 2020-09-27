package web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.Factory;
import dao.EmployeeDAO;

public class DelEmpServlet extends HttpServlet{
	public void service(HttpServletRequest request,
			HttpServletResponse response) 
	throws ServletException,IOException{
		response.setContentType(
				"text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		String id = request.getParameter("id");
		try {
			EmployeeDAO dao = 
				(EmployeeDAO)Factory.getInstance("EmployeeDAO");
			dao.delete(Integer.parseInt(id));
			response.sendRedirect("list");
		} catch (Exception e) {
			e.printStackTrace();
			out.println("…‘∫Û÷ÿ ‘");
		}
	}
	
}
