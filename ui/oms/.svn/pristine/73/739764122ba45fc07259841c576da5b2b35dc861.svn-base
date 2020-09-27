package cn.rkylin.oms.common.filters;

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

import cn.rkylin.oms.common.context.DefaultWebContext;
import cn.rkylin.oms.common.context.WebContextFactory;

/**
 * WebContext初始化
 * @create 2017年2月16日
 * @version 1.0
 * @author wangxiaoyi
 *
 */
public class WebContextFilter extends HttpServlet implements Filter {
	private static final long serialVersionUID = -6240322413032554648L;


	public void init(FilterConfig filterConfig) throws ServletException {
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        DefaultWebContext ctx = (DefaultWebContext)WebContextFactory.getWebContext();
        if(request instanceof HttpServletRequest && response instanceof HttpServletResponse){
        	ctx.setRequest((HttpServletRequest)request);
            ctx.setResponse((HttpServletResponse)response);
            ctx.setSession(((HttpServletRequest) request).getSession());
        }
        chain.doFilter(request, response);
    }

    public void destroy() {
        
    }
}