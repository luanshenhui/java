package Text;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CommentFilter extends HttpServlet{
	
	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("comementServlet's service brgin...");
		response.setContentType("text/html;chatset=utf-8");
		PrintWriter out = response.getWriter();
		request.setCharacterEncoding("utf-8");
		String content = request.getParameter("content");
		out.println("你的评论是:" + content);
		System.out.println("comementServlet's service end...");
	}
}
