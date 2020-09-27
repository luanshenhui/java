package com.f.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.f.domain.Person;
import com.f.service.PersonService;
import com.f.service.PersonServiceImpl;
/**
 * 
 * @author ��ѧ��
 * �޸���Ϣ������
 * 2015-2-9����1:07:56
 */
public class PersonEdit extends BaseAction{
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		//��ȡ��ǰ����ID
		long id =Long.parseLong(request.getParameter("id"));
		
		Person person = new PersonServiceImpl().getByID(id);
		//��ȡ�޸ĺ����Ϣ
		String username=request.getParameter("username");
		String sex=request.getParameter("sex");
		int age=Integer.parseInt(request.getParameter("age"));
		String email=request.getParameter("email");
		long phone=Long.parseLong(request.getParameter("phone"));
		double salary=Double.parseDouble(request.getParameter("salary"));
		//�޸���Ϣ
		person.setUsername(username);
		person.setSex(sex);
		person.setAge(age);
		person.setEmail(email);
		person.setPhone(phone);
		person.setSalary(salary);
		
		//�ϴ������ݿ�
		//����ҵ��㷽��
		
		PersonService service =new PersonServiceImpl();
		
		//������ת·��
		String path="";
		if(service.Uinformtion(person)){
			path="/web/page/personview.jsp";
			
		//����ҳ������	
			HttpSession session=request.getSession();
			session.setAttribute("person",person);
		}else{
			
			
			path="/web/page/personedit.jsp";
		}
		
		
		request.getRequestDispatcher(path).forward(request, response);
	}

}
