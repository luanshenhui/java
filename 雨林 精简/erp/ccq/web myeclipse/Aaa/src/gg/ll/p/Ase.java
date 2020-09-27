package gg.ll.p;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Ase extends HttpServlet{

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		this.doPost(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String username=req.getParameter("1");
		String password=req.getParameter("2");
		String path="";
		if(!username.equals("hui") && !password.equals("hui")){
			path="/Aaa/page/n.html";
		}else{
			path="/Aaa/page/m.html";
		}
		resp.sendRedirect(path);
	}
	
}
