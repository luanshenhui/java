package web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class GreetingServlet extends HttpServlet{
	public void service(HttpServletRequest request,
			HttpServletResponse response) 
	throws ServletException,IOException{
		//通过request对象获得请求参数值
		String name = request.getParameter("name");
		String[] interest = 
			request.getParameterValues("interest");
		//处理请求
		String msg = "hello " + name;
		//输出
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.println(msg);
		for(int i=0;i<interest.length;i++){
			out.println(interest[i] + "<br/>");
		}
		out.close();
	}

}
