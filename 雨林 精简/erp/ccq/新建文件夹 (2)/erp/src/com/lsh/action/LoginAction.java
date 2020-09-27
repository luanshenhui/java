/**
 * 
 */
package com.lsh.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.lsh.domain.Person;
import com.lsh.service.PersonService;
import com.lsh.service.PersonServiceImpl;

/**
 * @author 栾慎辉
 *
 * 2015-2-6上午09:27:51
 */
public class LoginAction extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	this.doPost(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		String username=req.getParameter("username");
		String password=req.getParameter("password");
		PersonService service=new PersonServiceImpl();
		boolean boo=service.islogin(username, password);
		String path="";
		if(boo){
			path="/web/page/main.jsp";
			//把当前用户存在session中
			Person person=service.getPersonByName(username);
			//获取会话对象
			HttpSession session=req.getSession();
			session.setAttribute("person", person);
		//	req.setAttribute("good","登陆成功");
		}else{
			//path="/web/register.jsp";
			path="/web/login.jsp";
			req.setAttribute("null","用户名不正确");
			
		}
		req.getRequestDispatcher(path).forward(req, resp);
	}
	

}
