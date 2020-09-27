package web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class NTest extends HttpServlet{
	public void service(HttpServletRequest request,
			HttpServletResponse response)throws IOException{
		//和表单的提交方式是相互绑定
		//request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		//页面的数据怎么到后台
		//在前台页面获取数值  文本框的内容  方法的参数和input
		//标签的name属性值保持一致
		String name = request.getParameter("name");
		String name1 = new String(name.
				getBytes("iso8859-1"),"utf-8");
		String age = request.getParameter("age");
		System.out.println(age);
		int age1 = Integer.parseInt(request.getParameter("age"));
		PrintWriter out = response.getWriter();
		out.print("你好"+name1 +"我的年龄是"+age1);
	}
}
