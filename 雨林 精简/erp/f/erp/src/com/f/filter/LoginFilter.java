/**
 * 
 */
package com.f.filter;

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
 * @author ��ѧ��
 *	�úϷ��û����Է�����վ�ڲ�ҳ��
 *	Filter������ 
 * 2015-2-12����10:58:16
 */
public class LoginFilter implements Filter {

	public void init(FilterConfig arg0) throws ServletException {
		
	}

	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		
		
		HttpServletResponse res=(HttpServletResponse)response;
		
		HttpServletRequest req=(HttpServletRequest)request;
		HttpSession session=req.getSession();
		if(session.getAttribute("person")!=null){
			//���������´��ݣ����ݵ�������Ҫ���ʵ�ҳ��
			chain.doFilter(request, response);
		}else{
			res.sendRedirect("/erp/web/login.jsp");
		}
	}

	
	public void destroy() {
		
	}
}
