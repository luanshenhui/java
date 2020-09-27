package web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.Factory;

import DAO.EmpDao;
import entity.Emp;

public class WebServlet extends HttpServlet{

	private static final long serialVersionUID = 1L;
	
	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		
		String path = request.getRequestURI();
		path = path.substring(path.lastIndexOf("/"), path.lastIndexOf("."));
		
		if("/checkname".equals(path)){
			PrintWriter out = response.getWriter();
			String name = request.getParameter("username");
			System.out.println(name);
			EmpDao dao = (EmpDao) Factory.getInstance("EmpDao");
			try {
				Emp emp = dao.findName(name);
				System.out.println(emp);
				if(emp != null){
					out.print("error");
				}else{
					out.print("ok");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
