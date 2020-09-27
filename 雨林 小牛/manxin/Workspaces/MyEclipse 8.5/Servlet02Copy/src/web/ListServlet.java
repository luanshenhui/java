package web;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import entity.Emp;

import util.Factory;

import DAO.EmpDao;

public class ListServlet extends HttpServlet{
	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<table border='1'" + "width = '60%' cellpadding='0' cellspacing='0'");
		out.println("<tr><td>ID</td><td>姓名</td>" + "<td>薪水</td><td>年龄</td><td>操作</td></tr>");
		EmpDao dao = (EmpDao)Factory.getInstance("EmpDao");
		int page = (request.getParameter("page") == null ? 0 :Integer.parseInt(request.getParameter("page")));
		try {
			int all = dao.findEmp().size();
			int pages = all/5;
			pages = (all%5==0 ? pages : pages+1);
			
			List<Emp> list = dao.findEmpPage(page);
//			System.out.println(list);
			for(Emp emp : list){
				out.println("<tr><td>" + emp.getD_id()
				+ "</td><td>" + emp.getD_name()
				+ "</td><td>" + emp.getD_age()
				+ "</td><td>" + emp.getD_salary()
				+ "</td><td><a href='del?id="+ emp.getD_id() 
				+ "'>删除</a>" + "&nbsp;&nbsp;<a href='load?id=" 
				+ emp.getD_id() + "'>修改</a></td></tr>"
				);
			}
			out.println("</table>");
			if(page == 0){
				out.println("共 "+ pages +"页/第" + (page + 1) + "页");
				out.println("<a href='topageDown?page=" + (page + 1) +"'>下一页</a>");
			}else if(page != 0){
				out.println("<a href='topageUp?page="+ (page - 1) +"'>上一页</a>");
				out.println("共"+ pages +"页/第" + (page + 1) + "页");
				out.println("<a href='topageDown?page=" + (page + 1) +"'>下一页</a>");
			}else if(page + 1 == pages){
				out.println("<a href='topageUp?page="+ (page - 1) +"'>上一页</a>");
				out.println("共页/第" + (page + 1) + "页");
			}
			out.println("<a href='addEmp.html'>" + "添加员工</a>");
		} catch (Exception e) {
			e.printStackTrace();
			out.println("稍后重试");
		}
	}
}
