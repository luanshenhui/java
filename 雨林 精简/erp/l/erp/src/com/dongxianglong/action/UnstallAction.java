package com.dongxianglong.action;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 注销控制器
 * @author 董祥龙
 *
 * 2015-2-9下午06:27:16
 */
public class UnstallAction extends HttpServlet {

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		//向请求要会话
		HttpSession session=request.getSession();
		session.invalidate();
		PrintWriter out=response.getWriter();
		out.write("<script>window.parent.location.href='web/login.jsp'</script>");
		
	}
	
	
	

}
