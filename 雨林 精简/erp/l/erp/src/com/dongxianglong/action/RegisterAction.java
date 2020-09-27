/**
 * 
 */
package com.dongxianglong.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dongxianglong.domain.Person;
import com.dongxianglong.domain.Roleaction;
import com.dongxianglong.service.PersonServiceImpl;

/**
 * @author ������
 *
 * 2015-2-6����09:50:11
 */
public class RegisterAction extends HttpServlet {

	PersonServiceImpl service=new PersonServiceImpl();
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	  this.doPost(request, response);	
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String username=request.getParameter("username");
		String password=request.getParameter("password");
		String sex=request.getParameter("sex");
		String age=request.getParameter("age");
		String email=request.getParameter("email");
		String phone=request.getParameter("phone");
		String salary=request.getParameter("salary");
		String path="";
	    Person person=new Person();
		person.setUsername(username);
		person.setPassword(password);
		person.setSex(sex);
		person.setAge(Integer.parseInt(age));
		person.setEmail(email);
		person.setPhone(Long.parseLong(phone));
		person.setSalary(Double.parseDouble(salary));
		boolean boo=service.register(person);
		if(boo)
		{
		 path="/web/login.jsp";	
		 request.setAttribute("ok", "ע��ɹ������¼");	
		}
		else
		{
			path="/web/register.jsp";
			request.setAttribute("no", "������ע��");
		}
		request.getRequestDispatcher(path).forward(request, response);
	}
	
	
	

}
