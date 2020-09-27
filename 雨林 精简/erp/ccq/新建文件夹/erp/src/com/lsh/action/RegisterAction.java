package com.lsh.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lsh.domain.Person;
import com.lsh.service.PersonService;
import com.lsh.service.PersonServiceImpl;

public class RegisterAction extends HttpServlet {


	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String username=request.getParameter("username");
		System.out.println(username);
		String password=request.getParameter("password");
		System.out.println(password);
	//	String repassword=request.getParameter("repassword");
		String sex=request.getParameter("sex");
		System.out.println(sex);
		String age=request.getParameter("age");
		System.out.println("age");
		String email=request.getParameter("email");
		System.out.println(email);
		String phone=request.getParameter("phone");
		System.out.println(phone);
		String salary=request.getParameter("salary");
		System.out.println(salary);
		Person person=new Person(username,password,sex,Integer.parseInt(age),email,Long.parseLong(phone),Double.parseDouble(salary));
		
		PersonService service=new PersonServiceImpl();
		boolean boo=service.register(person);
		String path="";
		if(boo){
		//	request.setAttribute("good","ע��ɹ�");
			path="/web/login.jsp";
		}else{
			//path="/web/Register.jsp";
			path="/web/Register.jsp";
		//	request.setAttribute("null","ע��ʧ��");
			
		}
		request.getRequestDispatcher(path).forward(request, response);
		//response.sendRedirect(path);
	}

}
