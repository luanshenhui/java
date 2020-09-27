package com.yulin.web;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DemoServlet extends HttpServlet{
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");
		
		ArrayList<String> list = new ArrayList<String>();
		if(list.size() == 0){
			list.add("呵呵");
			list.add("哈哈");
			list.add("嘿嘿");
			list.add("嘻嘻");
			list.add("咔咔");
		}
		request.setAttribute("list", list);
		request.getRequestDispatcher("index.jsp").forward(request, response);
	}
}
