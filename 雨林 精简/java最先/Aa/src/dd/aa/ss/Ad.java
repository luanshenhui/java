package dd.aa.ss;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Ad extends HttpServlet {

	
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		this.doPost(req, resp);
	
	}

	
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
	
		String username=req.getParameter("1");
		String password=req.getParameter("2");
		String path="";
		if(username.equals("qwe") && password.equals("000")){
			path="page/MyHtml.html";
		}else{
			path="page/a.html";
		}
		req.getRequestDispatcher(path).forward(req, resp);
	}
	

}
