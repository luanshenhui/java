/**
 * 
 */
package com.lsh.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;

import javax.activation.URLDataSource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lsh.domain.Person;
import com.lsh.service.PersonService;
import com.lsh.service.PersonServiceImpl;

/**
 * @author 栾慎辉
 *
 * 2015-2-12上午10:35:21
 * 
 * 用户唯一性检查的控制器
 * 使用ajax和jqrey框架
 */
public class AJAXAction extends HttpServlet {

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	this.doPost(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		//从客户端获取数据
		request.setCharacterEncoding("UTF-8");
		String username=request.getParameter("username");
		username=URLDecoder.decode(username,"UTF-8");
		
		PersonService service=new PersonServiceImpl();
		Person person=service.getPersonByName(username);
		//向客户端发送请求
		
		response.setContentType("text/xml;charset=utf-8");
		PrintWriter out=response.getWriter();
		
		if(person==null){
			out.print("次人不存在");
		}else{
			out.print("次人存在");
			
		}
	}
	
	

}
