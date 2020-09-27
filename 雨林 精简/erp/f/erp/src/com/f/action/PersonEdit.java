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
 * @author 冯学明
 * 修改信息控制器
 * 2015-2-9下午1:07:56
 */
public class PersonEdit extends BaseAction{
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		//获取当前对象ID
		long id =Long.parseLong(request.getParameter("id"));
		
		Person person = new PersonServiceImpl().getByID(id);
		//获取修改后的信息
		String username=request.getParameter("username");
		String sex=request.getParameter("sex");
		int age=Integer.parseInt(request.getParameter("age"));
		String email=request.getParameter("email");
		long phone=Long.parseLong(request.getParameter("phone"));
		double salary=Double.parseDouble(request.getParameter("salary"));
		//修改信息
		person.setUsername(username);
		person.setSex(sex);
		person.setAge(age);
		person.setEmail(email);
		person.setPhone(phone);
		person.setSalary(salary);
		
		//上传到数据库
		//调用业务层方法
		
		PersonService service =new PersonServiceImpl();
		
		//定义跳转路径
		String path="";
		if(service.Uinformtion(person)){
			path="/web/page/personview.jsp";
			
		//更新页面数据	
			HttpSession session=request.getSession();
			session.setAttribute("person",person);
		}else{
			
			
			path="/web/page/personedit.jsp";
		}
		
		
		request.getRequestDispatcher(path).forward(request, response);
	}

}
