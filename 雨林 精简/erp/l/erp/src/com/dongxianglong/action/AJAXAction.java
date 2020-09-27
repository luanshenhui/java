package com.dongxianglong.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dongxianglong.domain.Person;
import com.dongxianglong.service.PersonService;
import com.dongxianglong.service.PersonServiceImpl;

/**
 * ��¼ҳ���û�Ψһ�Լ��Ŀ�����
 * ʹ��AJAX������jQuery���
 * @author ������
 *
 * 2015-2-12����10:31:34
 */
public class AJAXAction extends BaseAction {


	protected void excute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		

		//�ӿͻ��˻�ȡ����
		request.setCharacterEncoding("UTF-8");
		String username=request.getParameter("username");
		username=URLDecoder.decode(username,"UTF-8");
		
		
		PersonService service=new PersonServiceImpl();
		Person person=service.getPersonByName(username);
		
		//��ͻ��˷�������
		response.setContentType("text/xml;charset=utf-8");
		PrintWriter out=response.getWriter();
		
		if(person==null)
		{
			out.print("���û�������!");
			
		}else
		{
			out.print("���û�����!");
		}
		
		
	}

	
	


	
	
	

}
