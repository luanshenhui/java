package web;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.Factory;
import DAO.EmpDao;
import entity.Emp;

public class PageDownServlet extends HttpServlet{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void service(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		response.setContentType("text/html;charset=utf-8");
		EmpDao dao = (EmpDao)Factory.getInstance("EmpDao");
		int page = Integer.parseInt(request.getParameter("page"));
//		System.out.println(page);
		try {
			List<Emp> list = dao.findEmpPage(page);
//			System.out.println("Pagelist:"+list);
			response.sendRedirect("list?page="+ page +"");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
