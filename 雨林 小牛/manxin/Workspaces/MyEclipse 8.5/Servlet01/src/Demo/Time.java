package Demo;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Time extends HttpServlet{
	
	private static final long serialVersionUID = 1L;
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html");
		Date d = new Date();
		SimpleDateFormat c  = new SimpleDateFormat("yyyy-MM-dd");
		String a = c.format(d);
		PrintWriter out = response.getWriter();
		out.println(a);
	}

}
