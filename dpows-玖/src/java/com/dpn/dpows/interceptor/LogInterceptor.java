package com.dpn.dpows.interceptor;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.dpn.dpows.Constants;


/** 
 * 查看log的拦截器 
 */  
public class LogInterceptor implements HandlerInterceptor {
	
	private static final String LOG_INDEX = "/log/search/index";
	
	public void afterCompletion(HttpServletRequest request,
			HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		
		
	}

	public void postHandle(HttpServletRequest request, HttpServletResponse response,
			Object handler, ModelAndView modelAndView) throws Exception {
		
		
	}

	public boolean preHandle(HttpServletRequest request, HttpServletResponse response,
			Object handler) throws Exception {
		//获取请求的URL  
        String url = request.getRequestURI();  
        HttpSession session = request.getSession();
        if(url.equals("/dpows/log/search/list")){	
        	if(session.getAttribute(Constants.LOG_USR) != null){
        		if(session.getAttribute(Constants.LOG_USR).equals("dpnwhxm20171020")){
        			return true;
        		} else {
        			response.sendRedirect(request.getContextPath() + LOG_INDEX); 
            		return false;
        		}
        	} else {
        		response.sendRedirect(request.getContextPath() + LOG_INDEX); 
        		return false;
        	}
        } 
        if(session.getAttribute(Constants.LOG_USR) == null){
        	String logUser = request.getParameter("logUser");
        	if(logUser != null && !logUser.equals("")){
        		session.setAttribute(Constants.LOG_USR, logUser);
        		response.sendRedirect(request.getContextPath() + url); 
        		return true;
        	}
        }
        response.sendRedirect(request.getContextPath() + LOG_INDEX); 
		return false;
	}

}
