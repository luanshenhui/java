/**
 * 
 */
package com.f.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.f.service.PersonService;
import com.f.service.PersonServiceImpl;


/**
 * @author ��ѧ��
 *	��¼������
 * 2015-2-6����9:07:53
 */
public class LoginAction extends BaseAction{
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String username= request.getParameter("username");
		String password=request.getParameter("password");			
		String path="";
		PersonService service=new PersonServiceImpl();
		
		if(service.islogin(username, password)){
			
			path="/web/page/main.jsp";
			//����ǰ����洢��session��
			HttpSession session=request.getSession();
			session.setAttribute("person",service.getPersonByName(username));
			
		}else{
			request.setAttribute("login_error", "�û������������");
			path="/web/login.jsp";
		}
		request.getRequestDispatcher(path).forward(request, response);		
		
	}
}
