package web;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import util.Factory;

import DAO.EmpDAO;

import entity.Emp;

public class WebServlet extends HttpServlet{
	private static final long serialVersionUID = 1L;
	
	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		HttpSession session = request.getSession();
		
		String path = request.getRequestURI();
		path = path.substring(path.lastIndexOf("/"), path.lastIndexOf("."));
		if(path.equals("/add")){
			String name = request.getParameter("name");
			int age = Integer.parseInt(request.getParameter("age"));
			double salary = Double.parseDouble(request.getParameter("salary"));
			Emp emp = new Emp(0, name, "1234", age, salary);
			EmpDAO dao = (EmpDAO)Factory.getInstance("EmpDAO");
			try {
				dao.save(emp);
			} catch (Exception e) {
				e.printStackTrace();
			}
			response.sendRedirect("list.do");
		}else if("/list".equals(path)){
			String pages = request.getParameter("pages");
			if(pages == null){
				pages = "1";
			}
			EmpDAO dao = (EmpDAO) Factory.getInstance("EmpDAO");
			try {
				List<Emp> list = dao.findByPage(Integer.parseInt(pages), 5);
				int totalPages = dao.getTotalPages(5);
				request.setAttribute("list", list);
				request.setAttribute("pages", Integer.parseInt(pages));
				request.setAttribute("totalPages", totalPages);
			} catch (Exception e) {
				e.printStackTrace();
			}
			request.getRequestDispatcher("emplist1.jsp").forward(request, response);
		}else if("/delete".equals(path)){
			int id = Integer.parseInt(request.getParameter("loginId"));
			EmpDAO dao = (EmpDAO) Factory.getInstance("EmpDAO");
			try {
				dao.delete(id);
			} catch (Exception e) {
				e.printStackTrace();
			}
			response.sendRedirect("list.do");
		}else if("/toUpdate".equals(path)){
			EmpDAO dao = (EmpDAO) Factory.getInstance("EmpDAO");
			int id = Integer.parseInt(request.getParameter("loginId"));
			try {
				List<Emp> list = dao.findById(id);
				request.setAttribute("list", list);
			} catch (Exception e) {
				e.printStackTrace();
			}
			request.getRequestDispatcher("updateEmp.jsp").forward(request, response);
		}else if("/update".equals(path)){
			String name = request.getParameter("name");
			int age = Integer.parseInt(request.getParameter("age"));
			double salary = Double.parseDouble(request.getParameter("salary"));
			int id = Integer.parseInt(request.getParameter("id"));
			String pwd = request.getParameter("pwd");
			EmpDAO dao = (EmpDAO) Factory.getInstance("EmpDAO");
			Emp emp = new Emp(id, name, pwd, age, salary);
			try {
				dao.update(emp);
				System.out.println("修改成功");
			} catch (Exception e) {
				e.printStackTrace();
			}
			response.sendRedirect("list.do");
		}
//		else if("/page".equals(path)){
//			try {
//				EmpDAO dao = (EmpDAO) Factory.getInstance("EmpDAO");
//				String p = request.getParameter("page");
//				int pages;
//				if(p != null){
//					pages = Integer.parseInt(p);
//				}else{
//					pages = 1;
//				}
////				List<Emp> list = dao.findAll();
////				int all = list.size();
//				List<Emp> list = dao.findByPage(pages, 5);
//				request.setAttribute("list", list);
//				request.setAttribute("pages", pages);
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//			request.getRequestDispatcher("emplist1.jsp").forward(request, response);
//		}
		else if("/login".equals(path)){
			//验证登陆
			String code = request.getParameter("code");
			String codeCheck = (String)session.getAttribute("number");
			if(!codeCheck.equalsIgnoreCase(code)){
				//提示用户验证码错误
				request.setAttribute("number_error", "验证码错误");
				request.getRequestDispatcher("login.jsp").forward(request, response);
				//跳出最内层的方法
				return;
			}
			int id = Integer.parseInt(request.getParameter("name"));
			String pwd = request.getParameter("pwd");
			EmpDAO dao = (EmpDAO) Factory.getInstance("EmpDAO");
			try {
				Emp emp = dao.findLoginId(id);
				if(emp != null && emp.getPwd().equals(pwd)){
					session.setAttribute("emp", emp);
					response.sendRedirect("list.do");
				}else{
					request.setAttribute("login_error", "用户名或密码错误");
					response.sendRedirect("login.jsp");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if("/checkname".equals(path)){
			PrintWriter out = response.getWriter();
			String name = request.getParameter("name");
			String pwd = request.getParameter("pwd");
			EmpDAO dao = (EmpDAO) Factory.getInstance("EmpDAO");
			try {
				Emp emp = dao.findName(name);
				if(emp != null){
					out.println("用户名已存在");
				}else{
					out.println("可以使用");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if("/regist".equals(path)){
			String code = request.getParameter("code");
			String codeCheck = session.getAttribute("number").toString();
			String name = request.getParameter("name");
			String pwd = request.getParameter("pwd");
			EmpDAO dao = (EmpDAO) Factory.getInstance("EmpDAO");
			try {
				if(codeCheck.equals(code)){
					Emp emp = new Emp(0, name, pwd, 0, 0);
					dao.regist(emp);
					System.out.println("注册成功");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			request.getRequestDispatcher("login.jsp").forward(request, response);
		}else if("/index".equals(path)){
			response.sendRedirect("login.jsp");
		}else{
			response.sendRedirect("index.jsp");
		}
	}

}
