package com.dongxianglong.action;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.dongxianglong.domain.Person;
import com.dongxianglong.service.PersonService;
import com.dongxianglong.service.PersonServiceImpl;

/**
 *�����޸Ŀ�����
 * @author ������
 *
 * 2015-2-9����03:47:40
 */
public class PasswordAction extends HttpServlet {

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		 
		request.setCharacterEncoding("UTF-8");
		
		String password=request.getParameter("password");
		
		String newpassword=request.getParameter("newpassword");
		
		String repassword=request.getParameter("repassword");
		String path="";
		PersonService service=new PersonServiceImpl();
		//��ȡhttp�Ự
		HttpSession session=request.getSession();
		//�ܻỰҪPerson����
		Person person=(Person)session.getAttribute("person");
		if(person.getPassword().equals(password))
		{
			if(newpassword.equals(repassword))
			{
				
				person.setPassword(newpassword);
				service.update(person);
				//path="/web/login.jsp";
				session.invalidate();
				PrintWriter out=response.getWriter();
				out.write("<script>window.parent.location.href='web/login.jsp'</script>");
			}
			else
			{
				//ע��ʧ��
				//path="/web/page/passwordedit.jsp";
				request.setAttribute("error", "���벻һ��");
				request.getRequestDispatcher("/web/page/passwordedit.jsp").forward(request, response);
			}
			
		}
		
	}
	
	
	
	

}
