package web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class HelloWorld extends HttpServlet{
	//service������������  ���д���� ��405
	public void service(HttpServletRequest request,
			            HttpServletResponse  response){
		//������������صĸ�ʽ��html
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
