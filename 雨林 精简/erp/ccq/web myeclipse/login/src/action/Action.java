package action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lsh.dao.PersonDAO;
import com.lsh.dao.PersonDAOImpl;
import com.lsh.qq.Person;
import com.lsh.service.PersonService;
import com.lsh.service.PersonServiceImpl;

public class Action extends HttpServlet {


	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		this.doPost(req, resp);
	}

	
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		String username=req.getParameter("username");
		String password=req.getParameter("password");
		
		PersonService ser=new PersonServiceImpl();
		boolean boo=ser.register(username, password);
		String path="";
		if (boo){
			path="/page/login.jsp";
		}else{
			path="/page/men.jsp";
		}
		req.getRequestDispatcher(path).forward(req, resp);
		
	}
	

}
