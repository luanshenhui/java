/**
 * 
 */
package com.f.action;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.f.domain.Person;
import com.f.service.PersonService;
import com.f.service.PersonServiceImpl;

/**
 * @author 冯学明
 * 
 *         2015-2-9下午3:31:04
 */
public class PasswordEdit extends BaseAction {
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		//获取密码
		String oldpassword =request.getParameter("oldpassword");
		String newpassword =request.getParameter("newpassword");
		String againpassword =request.getParameter("againpassword");
		//获取当前对象
		HttpSession session=request.getSession();
		
		Person person=(Person)session.getAttribute("person");
		
		//验证密码
		PersonService service =new PersonServiceImpl();

		String  path="";
		if(person.getPassword().equals(oldpassword) && newpassword.equals(againpassword)){
			
			//修改密码
			person.setPassword(newpassword);
			
			service.Upassword(person);
			//注销当前会话
			session=request.getSession();
			session.invalidate();
			PrintWriter out= response.getWriter();
			
			out.write("<script>window.parent.location.href='web/login.jsp'</script>");
			
		}else{
			path="web/page/passwordedit.jsp";
			
			request.setAttribute("passworderr", "密码错误");
			request.getRequestDispatcher(path).forward(request, response);
		}
	}
}
