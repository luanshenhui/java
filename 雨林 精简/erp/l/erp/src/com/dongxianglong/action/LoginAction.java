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
 * @author ������
 * 
 *         2015-2-6����09:23:38 ��¼������
 */
public class LoginAction extends BaseAction {


	protected void excute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		// ҵ������
		request.setCharacterEncoding("UTF-8");

		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String path = "";

		PersonService service = new PersonServiceImpl();
		boolean boo = service.isLogin(username, password);
		if (boo) {
			// ��¼�ɹ�

			// ���óɹ�ҳ��
			path = "/web/page/main.jsp";
			// �ѵ�ǰ�û�����洢��session��Χ�С�
			Person person = service.getPersonByName(username);
			//��ȡ�Ự����
			HttpSession session = request.getSession();
			session.setAttribute("person", person);

		} else {
			path = "/web/login.jsp";
			request.setAttribute("false", "�û������������");
		}
		request.getRequestDispatcher(path).forward(request, response);
		
	}

}
