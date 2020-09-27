package cn.lsh.web.controller.login.com;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.lsh.web.mapper.login.domain.ManagerDomain;
import cn.lsh.web.mapper.login.domain.UserDomain;


public class WebIntercepApp implements Filter {

	private List<String> path = new ArrayList<String>();

	
	public void init(FilterConfig filterConfig) throws ServletException {
		path.add("/login/login.action");
		path.add("/login/init.action");
		path.add("/login/getYzm.action");
		path.add("/login/groupDownload.action");
		path.add("/login/createPerson.action");
		path.add("/login/getRolelist.action");
		path.add("/login/register.action");
		path.add("/login/inputNewPassword.action");
		path.add("/login/updateUser.action");
		path.add("/login/updateManager.action");
		path.add("/login/getLeaveTime.action");
		path.add("/login/selectWatchNum.action");
		path.add("/login/insertFolt.action");
		path.add("/login/findPersonOn.action");
		path.add("/login.html");
	}
	
	public void doFilter(ServletRequest req, ServletResponse res,FilterChain chain) throws IOException, ServletException {
		// 获取request
		HttpServletRequest request = (HttpServletRequest) req;
		// 获取response
		HttpServletResponse response = (HttpServletResponse) res;
		// 获取路径
		String uri = request.getRequestURI();
		String contextPath = request.getContextPath();
		String url = uri.replace(contextPath, "");
		boolean filter = false;
		
		ManagerDomain user=(ManagerDomain) request.getSession().getAttribute("userSession");
		System.err.println("-------------session--------------"+user);
		if(null!=user){
			filter = true;
		}
		for (String p : path) {
			if (url.contains(p)) {
				filter = true;
			}
		}
		if (filter) {
			chain.doFilter(request, response);
			return;
		}
		String requestedWith = request.getHeader("X-Requested-With");
		if (requestedWith != null && requestedWith.contains("XMLHttpRequest")) {
			response.setHeader("sessionstatus", "0");
		}
		if (true) {
			response.sendRedirect(request.getContextPath()+ "/login.html");
		}

	}

	
	public void destroy() {
		// TODO Auto-generated method stub

	}

	public List<String> getPath() {
		return path;
	}

	public void setPath(List<String> path) {
		this.path = path;
	}

}
