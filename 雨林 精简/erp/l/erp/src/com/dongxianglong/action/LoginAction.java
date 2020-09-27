/**
 * 
 */
package com.dongxianglong.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.dongxianglong.domain.Person;
import com.dongxianglong.service.PersonService;
import com.dongxianglong.service.PersonServiceImpl;

/**
 * @author 董祥龙
 * 
 *         2015-2-6上午09:23:38 登录控制器
 */
public class LoginAction extends BaseAction {


	protected void excute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		// 业务层代码
		request.setCharacterEncoding("UTF-8");

		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String path = "";

		PersonService service = new PersonServiceImpl();
		boolean boo = service.isLogin(username, password);
		if (boo) {
			// 登录成功

			// 设置成功页面
			path = "/web/page/main.jsp";
			// 把当前用户对象存储在session范围中。
			Person person = service.getPersonByName(username);
			//获取会话对象
			HttpSession session = request.getSession();
			session.setAttribute("person", person);

		} else {
			path = "/web/login.jsp";
			request.setAttribute("false", "用户名或密码错误");
		}
		request.getRequestDispatcher(path).forward(request, response);
		
	}

}
