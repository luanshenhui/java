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
 * 过滤器的功能描述：让登录之后的合法用户可以访问page文件夹中的页面，如果非法访问则跳转到登录页面。
 * 
 * Filter是在所有servlet之前运行的。
 * 
 * @author 董祥龙
 * 
 *         2015-2-12上午10:58:49
 */
public class LoginFilter implements Filter {

	public void init(FilterConfig arg0) throws ServletException {

	//	System.out.println("过滤器的初始化方法");

	}

	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {

	//	System.out.println("过滤器的核心业务方法");

		HttpServletRequest req =(HttpServletRequest)request;
		HttpServletResponse res =(HttpServletResponse)response;
		HttpSession session = req.getSession();
		if (session.getAttribute("person") != null) {
			// 将请求继续向下传，传递到请求要访问的资源
			chain.doFilter(request, response);
		} else {
			// request.getRequestDispatcher("/web/login.jsp").forward(request,
			// response);
			res.sendRedirect("/erp/web/login.jsp");
		}

	}

	public void destroy() {

	//	System.out.println("过滤器的销毁方法");
	}

}
