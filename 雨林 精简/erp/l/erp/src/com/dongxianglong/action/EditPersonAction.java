package com.dongxianglong.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.dongxianglong.domain.Person;
import com.dongxianglong.service.PersonService;
import com.dongxianglong.service.PersonServiceImpl;
/**
 * 
 * @author 董祥龙
 *
 * 2015-2-9下午02:06:25
 * 用户信息编辑控制器
 */
public class EditPersonAction extends BaseAction {

	

	protected void excute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		//根据表中的name值获取到其对应的value值
		  request.setCharacterEncoding("UTF-8");
		  String sex=request.getParameter("sex");
		  String  age=request.getParameter("age");
		  String email=request.getParameter("email");
		  String phone=request.getParameter("phone");
		  String salary=request.getParameter("salary");
		  //获取name为“id”的隐藏域的value值，即ID值
		  String ID=request.getParameter("id");
		  
		  int id=Integer.parseInt(ID);
		  PersonService service=new PersonServiceImpl();
		  //根据id向业务层要person对象。
		  Person person=service.getByID(id);
		  //用set方法修改person的属性。
		  person.setSex(sex);
		  person.setAge(Integer.parseInt(age));
		  person.setEmail(email);
		  person.setPhone(Long.parseLong(phone));
		  person.setSalary(Double.parseDouble(salary));
		  //通过业务层把数据库中的person记录修改，以达到目的。
		  service.update(person);
		  //管请求要会话session。
		 HttpSession session=request.getSession();
		 //把person的信息装入到会话中。方便拿取。
		  session.setAttribute("person", person);
		  String path="/web/page/personview.jsp";
		  request.getRequestDispatcher(path).forward(request, response);
		  
		  
	}
	
	
	
	
	

}
