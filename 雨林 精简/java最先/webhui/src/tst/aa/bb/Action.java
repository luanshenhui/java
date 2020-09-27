package tst.aa.bb;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.omg.CORBA.Request;

public class Action extends HttpServlet {


	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String username=request.getParameter("1");
		String password=request.getParameter("2");
		String path="";
		if(username.equals("abc") && password.equals("123")){
			path="/page/ok.html";
		}else{
			path="/page/denglu.html";
		}
		request.getRequestDispatcher(path).forward(request, response);
	}
	

}
