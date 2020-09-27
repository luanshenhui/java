package web;

import java.io.IOException;
import java.net.URLEncoder;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CookieServlet extends HttpServlet{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		Cookie c = new Cookie("username",  URLEncoder.encode("过儿", "utf-8"));
		c.setMaxAge(40);
		response.addCookie(c);
		Cookie c2 = new Cookie("pwd", "test");
		response.addCookie(c2);
	}
}
