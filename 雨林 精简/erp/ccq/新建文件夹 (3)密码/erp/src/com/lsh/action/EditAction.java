/**
 * 
 */
package com.lsh.action;

import java.io.IOException;
import java.util.List;

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
 * 2015-2-9����02:19:44
 */
public class EditAction extends HttpServlet {

		//
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");

		Long id=Long.parseLong(request.getParameter("id"));
		PersonService service=new PersonServiceImpl();
	
		Person person=service.getByID(id);
		
		//
		int age =Integer.parseInt(request.getParameter("age"));
		person.setAge(age);
		
		person.setEmail(request.getParameter("email"));
		person.setPhone(Long.parseLong(request.getParameter("phone")));
		person.setSalary(Double.parseDouble(request.getParameter("salary")));
//		person.setSex(request.getParameter("sex"));
//		person.setUsername(request.getParameter("username"));
//		person.setPassword(request.getParameter("password"));
		
		
		String path=""; 
		if(service.update(person)){
			path="/web/page/personview.jsp";
			
			HttpSession session=request.getSession();
			session.setAttribute("person", person);
		}else{
			path="/web/login.jsp";
		}
		request.getRequestDispatcher(path).forward(request, response);
		
	
	}
	
	

}
