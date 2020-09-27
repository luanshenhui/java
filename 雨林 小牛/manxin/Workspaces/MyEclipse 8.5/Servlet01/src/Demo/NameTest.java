package Demo;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class NameTest extends HttpServlet{

	private static final long serialVersionUID = 1L;
	
	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html;charset=utf-8");
		request.setCharacterEncoding("utf-8");
		String name = request.getParameter("name");
//		String name1 = new String(name.getBytes("iso8859-1"),"utf-8");//编码解析2
		String age = request.getParameter("age");
		int age1 = (age.equals("") ? 0 : Integer.parseInt(age));
		
//		int age2 = request.getParameter("age") == "" ? 0 : Integer.parseInt(request.getParameter("age"));
		
		PrintWriter out = response.getWriter();
		out.println("您好！" + name + ",您的年龄是：" + age1);
	}
}
