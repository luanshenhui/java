package com.yulin.web.control;

import java.io.IOException;
import java.util.Arrays;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Servlet2 extends HttpServlet {
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		System.out.println("service.....");
		req.getCookies();
		Cookie[] cs = req.getCookies();
		
		System.out.println("cs:"+Arrays.toString(cs));
		if (cs == null) {
			Cookie cookie = new Cookie("hehe", "1234");
//			cookie.setPath("/web03/cookie");
			cookie.setMaxAge(10000000);
			resp.addCookie(cookie);
		}else{
			for(Cookie c : cs){
				System.out.println(c.getValue());
				System.out.println(c.getComment());
				System.out.println(c.getPath());
				System.out.println(c.getPath());
				
				if(c.getName().equals("hehe")){
					System.out.println(c.getValue());
				}else{
					Cookie cookie = new Cookie("hehe", "1234");
//					cookie.setPath("web03/cookie");
					cookie.setMaxAge(10000000);
					resp.addCookie(cookie);
				}
			}
		}
	}
}
