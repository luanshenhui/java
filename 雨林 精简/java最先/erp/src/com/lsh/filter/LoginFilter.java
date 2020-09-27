package com.lsh.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


/**
 * 
 * @author 栾慎辉
 *
 * 2015-2-12上午11:06:20
 * 
 * 	q	合发用户可以通过page页面,非法到主页面
 * 
 * filter在所有servlet前运行
 */






public class LoginFilter implements Filter {

	public void init(FilterConfig arg0) throws ServletException {
		// TODO Auto-generated method stub
		
		System.out.println("过滤器初始化方法");
	}

	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		// TODO Auto-generated method stub
		System.out.println("核心业务");
		HttpServletRequest req=(HttpServletRequest)request;
		HttpServletResponse res=(HttpServletResponse)response;
		HttpSession session=req.getSession();
		
		if(session.getAttribute("person")!=null){
			//将请求继续向下传递
			chain.doFilter(request, response);
		}else{
			//req.getRequestDispatcher("web/login.jsp").forward(request, response);
			res.sendRedirect("/erp/web/login.jsp");
		}
		
	}
	
	public void destroy() {
		// TODO Auto-generated method stub
		
	}




	



}
