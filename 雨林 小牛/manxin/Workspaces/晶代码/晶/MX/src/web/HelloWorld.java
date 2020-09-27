package web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class HelloWorld extends HttpServlet{
	//service必须是这名字  如果写错了 报405
	public void service(HttpServletRequest request,
			            HttpServletResponse  response){
		//告诉浏览器返回的格式是html
		response.setContentType("text/html");
		try {
			PrintWriter out = response.getWriter();
			out.println("helloworld");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
