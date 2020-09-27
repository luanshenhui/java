package fff.fff;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Act extends HttpServlet {

	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
	
		this.doPost(req, resp);

	}

	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String username=req.getParameter("username");
		String password=req.getParameter("password");
		String path="";
		if(username.equals("lsh")&&(password.equals("123"))){
			path="/hj/page/b.html";
		}else{
			path="/hj/page/a.html";
		}
		
		resp.sendRedirect(path);
	}

}
