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
 * @author 冯学明
 *登录页面用户唯一性检查的控制器
 * 2015-2-12上午10:31:48
 */

public class AJAXAciton extends BaseAction {
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
	
		//取名
		String username=request.getParameter("username");
		username=URLDecoder.decode(username, "UTF-8");
		//获取person对象
		PersonService service=new PersonServiceImpl();
		
		Person person =service.getPersonByName(username);
		
		//向客户端发送请求
		response.setContentType("text/xml;charset=utf-8");
		
		PrintWriter out=response.getWriter();
		
		if(person==null){
			out.print("此用户不存在!!");
			
		}else{
			out.print("用户存在!");
		}
	}

}
