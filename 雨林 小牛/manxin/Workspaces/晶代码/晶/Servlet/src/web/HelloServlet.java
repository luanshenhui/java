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
		//����һ����Ϣͷ(content-type),����
		//����������ص���һ��html�ĵ���
		response.setContentType("text/html");
		//ͨ��response������һ�������
		PrintWriter out = response.getWriter();
		//���
		out.println(
				"<div style='font-size:60px;" +
				"font-style:italic;'>Hello World</div>");
		//�ر���
		out.close();
	}
}
