package com.f.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.f.domain.Person;
import com.f.service.PersonService;
import com.f.service.PersonServiceImpl;
/**
 * 
 * @author ��ѧ��
 *��¼ҳ���û�Ψһ�Լ��Ŀ�����
 * 2015-2-12����10:31:48
 */

public class AJAXAciton extends BaseAction {
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
	
		//ȡ��
		String username=request.getParameter("username");
		username=URLDecoder.decode(username, "UTF-8");
		//��ȡperson����
		PersonService service=new PersonServiceImpl();
		
		Person person =service.getPersonByName(username);
		
		//��ͻ��˷�������
		response.setContentType("text/xml;charset=utf-8");
		
		PrintWriter out=response.getWriter();
		
		if(person==null){
			out.print("���û�������!!");
			
		}else{
			out.print("�û�����!");
		}
	}

}
