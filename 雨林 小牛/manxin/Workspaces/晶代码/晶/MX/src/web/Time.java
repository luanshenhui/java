package web;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Time extends HttpServlet{

	private static final long serialVersionUID = 1L;
	
	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		Date d = new Date();
		SimpleDateFormat c = new SimpleDateFormat("yyyy-MM-dd");
		String a = c.format(d);
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.println(a);
	}

}
