package aa.ll.ss;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Action extends HttpServlet{

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		this.doPost(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		req.setCharacterEncoding("UTF-8");
		String name=req.getParameter("username");
		String phone=req.getParameter("password");
		
		ClientService service=new ClientService();
		boolean boo=service.isload(name, phone);
		
		String path="";
		if(boo){
			path="/page/men.jsp";
		}else{
			path="/page/login.jsp";
		}
	req.getRequestDispatcher(path).forward(req, resp);
	}
	
	

}
