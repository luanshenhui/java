package web;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.Factory;
import DAO.EmpDao;
import entity.Emp;

public class Servlet extends HttpServlet{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;chatset=utf-8");
		String uri = request.getRequestURI();
		System.out.println(uri);
		String action = uri.substring(uri.lastIndexOf("/"),uri.lastIndexOf("."));
		if(action.equals("/add")){
			System.out.println("添加");
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
		}else if(action.equals("/list")){
			System.out.println("list");
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
//				System.out.println(list);
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
		}else if(action.equals("/del")){
			System.out.println("删除");
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
		}else if(action.equals("/load")){
			System.out.println("load");
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
		}else if(action.equals("/update")){
			System.out.println("上一页");
			String name = request.getParameter("name");
			int age = Integer.parseInt(request.getParameter("age"));
			double salary = Double.parseDouble(request.getParameter("salary"));
			int id = Integer.parseInt(request.getParameter("id"));
//			System.out.println(id);
			
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
		}else if(action.equals("/topageUp")){
			System.out.println("topageUp");
			EmpDao dao = (EmpDao)Factory.getInstance("EmpDao");
			int page = Integer.parseInt(request.getParameter("page"));
			System.out.println(page);
			try {
				List<Emp> list = dao.findEmpPage(page);
//				System.out.println("Pagelist:"+list);
//				page -= 5;
				response.sendRedirect("list?page="+ page +"");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(action.equals("/topageDown")){
			System.out.println("/topageDown");
			EmpDao dao = (EmpDao)Factory.getInstance("EmpDao");
			int page = Integer.parseInt(request.getParameter("page"));
//			System.out.println(page);
			try {
				List<Emp> list = dao.findEmpPage(page);
//				System.out.println("Pagelist:"+list);
				response.sendRedirect("list?page="+ page +"");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else{
			response.sendRedirect("index.jsp");
		}
	}
}
