package web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class NTest extends HttpServlet{
	public void service(HttpServletRequest request,
			HttpServletResponse response)throws IOException{
		//�ͱ����ύ��ʽ���໥��
		//request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		//ҳ���������ô����̨
		//��ǰ̨ҳ���ȡ��ֵ  �ı��������  �����Ĳ�����input
		//��ǩ��name����ֵ����һ��
		String name = request.getParameter("name");
		String name1 = new String(name.
				getBytes("iso8859-1"),"utf-8");
		String age = request.getParameter("age");
		System.out.println(age);
		int age1 = Integer.parseInt(request.getParameter("age"));
		PrintWriter out = response.getWriter();
		out.print("���"+name1 +"�ҵ�������"+age1);
	}
}
