package web;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import entity.Emp;

import DAO.EmpDao;

import util.Factory;

public class LoadServlet extends HttpServlet{
	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		
		int id = Integer.parseInt(request.getParameter("id"));
		
		EmpDao dao = (EmpDao)Factory.getInstance("EmpDao");
		PrintWriter out = response.getWriter();
		List<Emp> list = null;
		try {
			list = dao.findEmpById(id);
			out.println("<form action='update?id="+ id + "' method='post'>");
			out.println("<table width='280px' height='200px'>");
			for(Emp emp : list){
				out.println("<tr><td>" + "姓名：" + "<input type='text' name='name'"
						+ "value='" + emp.getD_name() + "'/></td></tr>");
	    		out.println("<tr><td>" + "年龄：" + "<input type='text' name='age'"
						+ "value='" + emp.getD_age() + "'/></td></tr>");	
	    		out.println("<tr><td>" + "工资：" + "<input type='text' name='salary'"
						+ "value='" + emp.getD_salary() + "'/></td></tr>");
	    		out.println("<tr><td><input type='submit'"
						+ "value='修改'/></td></tr>");
			}
			out.println("</table></form>");
		} catch (Exception e) {
			e.printStackTrace();
			out.println("请稍后再试");
		}
	}
	
}
