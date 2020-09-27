package action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lsh.service.PersonService;
import com.lsh.service.PersonServiceImpl;

public class LoginAction extends HttpServlet {

	
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		this.doPost(req, resp);
		
	}


	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		String username=req.getParameter("username");
		String password=req.getParameter("password");
		
		PersonService service=new PersonServiceImpl();
		boolean boo=service.islogin(username, password);
		
		String path="";
		if(boo){
			path="/page/men.jsp";
			req.setAttribute("god", "��½�ɹ�");
		}else{
			path="/page/login.jsp";
			req.setAttribute("err", "�û���ʧ��");
		}
		req.getRequestDispatcher(path).forward(req, resp);
	}
	
	

}
