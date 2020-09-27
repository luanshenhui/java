package com.dongxianglong.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * �������Ĺ����������õ�¼֮��ĺϷ��û����Է���page�ļ����е�ҳ�棬����Ƿ���������ת����¼ҳ�档
 * 
 * Filter��������servlet֮ǰ���еġ�
 * 
 * @author ������
 * 
 *         2015-2-12����10:58:49
 */
public class LoginFilter implements Filter {

	public void init(FilterConfig arg0) throws ServletException {

	//	System.out.println("�������ĳ�ʼ������");

	}

	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {

	//	System.out.println("�������ĺ���ҵ�񷽷�");

		HttpServletRequest req =(HttpServletRequest)request;
		HttpServletResponse res =(HttpServletResponse)response;
		HttpSession session = req.getSession();
		if (session.getAttribute("person") != null) {
			// ������������´������ݵ�����Ҫ���ʵ���Դ
			chain.doFilter(request, response);
		} else {
			// request.getRequestDispatcher("/web/login.jsp").forward(request,
			// response);
			res.sendRedirect("/erp/web/login.jsp");
		}

	}

	public void destroy() {

	//	System.out.println("�����������ٷ���");
	}

}
