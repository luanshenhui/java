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
 * @author 冯学明
 *	让合法用户可以访问网站内部页面
 *	Filter过滤器 
 * 2015-2-12上午10:58:16
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
			//将请求向下传递，传递到请求需要访问的页面
			chain.doFilter(request, response);
		}else{
			res.sendRedirect("/erp/web/login.jsp");
		}
	}

	
	public void destroy() {
		
	}
}
