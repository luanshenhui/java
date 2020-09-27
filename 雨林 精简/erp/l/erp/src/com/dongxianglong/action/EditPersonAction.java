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
 * @author ������
 *
 * 2015-2-9����02:06:25
 * �û���Ϣ�༭������
 */
public class EditPersonAction extends BaseAction {

	

	protected void excute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		//���ݱ��е�nameֵ��ȡ�����Ӧ��valueֵ
		  request.setCharacterEncoding("UTF-8");
		  String sex=request.getParameter("sex");
		  String  age=request.getParameter("age");
		  String email=request.getParameter("email");
		  String phone=request.getParameter("phone");
		  String salary=request.getParameter("salary");
		  //��ȡnameΪ��id�����������valueֵ����IDֵ
		  String ID=request.getParameter("id");
		  
		  int id=Integer.parseInt(ID);
		  PersonService service=new PersonServiceImpl();
		  //����id��ҵ���Ҫperson����
		  Person person=service.getByID(id);
		  //��set�����޸�person�����ԡ�
		  person.setSex(sex);
		  person.setAge(Integer.parseInt(age));
		  person.setEmail(email);
		  person.setPhone(Long.parseLong(phone));
		  person.setSalary(Double.parseDouble(salary));
		  //ͨ��ҵ�������ݿ��е�person��¼�޸ģ��ԴﵽĿ�ġ�
		  service.update(person);
		  //������Ҫ�Ựsession��
		 HttpSession session=request.getSession();
		 //��person����Ϣװ�뵽�Ự�С�������ȡ��
		  session.setAttribute("person", person);
		  String path="/web/page/personview.jsp";
		  request.getRequestDispatcher(path).forward(request, response);
		  
		  
	}
	
	
	
	
	

}
