package com.lsh.act;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 
 * ��½�Ŀ����������������½������
 * 
 */
public class LoginAction extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}
	//B/S �������/���������ǻ��������Ӧ
//���������Ӧ����  HttpServletRequest request, HttpServletResponse response
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		//��ȡ������
		String username=request.getParameter("username");
		String password=request.getParameter("password");
		//��֤�û��Ƿ�Ϸ�
		String path="";
		if(username.equals("abc") && password.equals("123")){
			path="/page/success.html";
		}else{
			path="/page/login.html";
		}
		//��ת
		//(1)����ת��(����������ת)��path="/page/success.html"
		//(2)����Ӷ���(�ͻ�����ת):path="/web10t/page/login.html"
		//���ǵ�1�֣����������������󣬷�����ȡ����Դ��Ȼ����Դ���ݷ���������������������֪����������λ�ã����Ե�ַ�����䡣
			request.getRequestDispatcher(path).forward(request, response);
		
			//��2 ��::�������������󣬷���������Դ��·���������������������Լ�������Դ��������
		//��������·������������Դλ��,���Ե�ַ���ı�
			//response.sendRedirect(path);
			
			/**
			 * ��������ʽ
			 * get��������������е������Ե�ַ���ķ�ʽ����������(/web/login?a=1&b=2))
			 * ȱ�㣺����ȫ����С���ޣ�
			 * �ŵ㣺�������
			 * post��������������е�������http����ͷ�ķ�ʽ���������(/web/login)
			 * ��ȱ��Ե�
			 */
	}

}
