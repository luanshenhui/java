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
 * 登录页面用户唯一性检查的控制器
 * 使用AJAX技术和jQuery框架
 * @author 董祥龙
 *
 * 2015-2-12上午10:31:34
 */
public class AJAXAction extends BaseAction {


	protected void excute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		

		//从客户端获取数据
		request.setCharacterEncoding("UTF-8");
		String username=request.getParameter("username");
		username=URLDecoder.decode(username,"UTF-8");
		
		
		PersonService service=new PersonServiceImpl();
		Person person=service.getPersonByName(username);
		
		//向客户端发送请求
		response.setContentType("text/xml;charset=utf-8");
		PrintWriter out=response.getWriter();
		
		if(person==null)
		{
			out.print("此用户不存在!");
			
		}else
		{
			out.print("此用户存在!");
		}
		
		
	}

	
	


	
	
	

}
