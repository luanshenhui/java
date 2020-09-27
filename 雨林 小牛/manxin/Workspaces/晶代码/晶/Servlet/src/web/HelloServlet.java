package web;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class HelloServlet extends HttpServlet{
	public void service(HttpServletRequest request,
			HttpServletResponse response) 
	throws ServletException,IOException{
		//生成一个消息头(content-type),告诉
		//浏览器，返回的是一个html文档。
		response.setContentType("text/html");
		//通过response对象获得一个输出流
		PrintWriter out = response.getWriter();
		//输出
		out.println(
				"<div style='font-size:60px;" +
				"font-style:italic;'>Hello World</div>");
		//关闭流
		out.close();
	}
}
