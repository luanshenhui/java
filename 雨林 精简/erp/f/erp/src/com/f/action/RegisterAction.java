package com.f.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.f.DAO.RoleactionDAOImpl;
import com.f.domain.Person;
import com.f.domain.Roleaction;
import com.f.service.PersonService;
import com.f.service.PersonServiceImpl;


public class RegisterAction extends BaseAction{
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		//��ȡע����Ϣ
		String username= request.getParameter("username");
		String password=request.getParameter("password");
		String sex=request.getParameter("sex");
		String age =request.getParameter("age");
		String email=request.getParameter("email");
		String phone =request.getParameter("phone");
		String salary =request.getParameter("salary");
		//��������
		Person person=new Person(username,password,sex,Integer.parseInt(age),email,Long.parseLong(phone),Double.parseDouble(salary));
		
//		Roleaction r=new RoleactionDAOImpl().getByID(1);
//		person.setRoleaction(r);
		
		String path="";
		PersonService service=new PersonServiceImpl();
		//��Ӽ�¼
		if(service.register(person)){
			request.setAttribute("success","ע��ɹ�");
			path="/web/login.jsp";	
		}else{
			request.setAttribute("Registererr", "�û��Ѵ���");
			path="/web/register.jsp";
		}
		request.getRequestDispatcher(path).forward(request, response);
				
	}
}
