/**
 * 
 */
package com.lsh.action;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.lsh.domain.Person;
import com.lsh.service.PersonService;
import com.lsh.service.PersonServiceImpl;

/**
 * @author ������
 *
 * 2015-2-9����05:55:55
 */
public class EditPasd extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String oldpassword=request.getParameter("oldpassword");
		String newpassword=request.getParameter("newpassword");
		String repassword=request.getParameter("repassword");
		PersonService service=new PersonServiceImpl();
		
		HttpSession session=request.getSession();
		Person person=(Person)session.getAttribute("person");
		if(person.getPassword().equals(oldpassword)){
		if(newpassword.equals(repassword)){
			
			person.setPassword(newpassword);
			
			service.update(person);
			session.invalidate();
			
			PrintWriter out=response.getWriter();
			out.write("<script>window.parent.location.href='web/login.jsp'</script>");
			
		}else{
			request.setAttribute("error", "���벻һ��");
			request.getRequestDispatcher("web/page/passwordidet.jsp").forward(request, response);
		}
		}
	}
	
	

}
