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

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		this.doPost(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		String username=req.getParameter("username");
		String password=req.getParameter("password");
		String repassword=req.getParameter("repassword");
		String sex=req.getParameter("sex");
		String age=req.getParameter("age");
		String email=req.getParameter("email");
		String phone=req.getParameter("phone");
		String salary=req.getParameter("salary");
		
		Person person=new Person(username,password,sex,Integer.parseInt(age),email,Long.parseLong(phone),Double.parseDouble(salary));
		
		PersonService service=new PersonServiceImpl();
		boolean boo=service.register(person);
		String path="";
		if(boo){
			req.setAttribute("good","×¢²á³É¹¦");
			path="/web/page/main.jsp";
		}else{
			//path="/web/Register.jsp";
			path="/web/Register.jsp";
			req.setAttribute("null","×¢²áÊ§°Ü");
			
		}
		req.getRequestDispatcher(path).forward(req, resp);
	}

}
