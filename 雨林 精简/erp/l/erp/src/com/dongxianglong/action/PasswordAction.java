package com.dongxianglong.action;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.dongxianglong.domain.Person;
import com.dongxianglong.service.PersonService;
import com.dongxianglong.service.PersonServiceImpl;

/**
 *密码修改控制器
 * @author 董祥龙
 *
 * 2015-2-9下午03:47:40
 */
public class PasswordAction extends HttpServlet {

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		 
		request.setCharacterEncoding("UTF-8");
		
		String password=request.getParameter("password");
		
		String newpassword=request.getParameter("newpassword");
		
		String repassword=request.getParameter("repassword");
		String path="";
		PersonService service=new PersonServiceImpl();
		//获取http会话
		HttpSession session=request.getSession();
		//管会话要Person对象
		Person person=(Person)session.getAttribute("person");
		if(person.getPassword().equals(password))
		{
			if(newpassword.equals(repassword))
			{
				
				person.setPassword(newpassword);
				service.update(person);
				//path="/web/login.jsp";
				session.invalidate();
				PrintWriter out=response.getWriter();
				out.write("<script>window.parent.location.href='web/login.jsp'</script>");
			}
			else
			{
				//注册失败
				//path="/web/page/passwordedit.jsp";
				request.setAttribute("error", "密码不一致");
				request.getRequestDispatcher("/web/page/passwordedit.jsp").forward(request, response);
			}
			
		}
		
	}
	
	
	
	

}
