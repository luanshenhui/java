
package com.f.action;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ValidateAction extends BaseAction{
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session=request.getSession();
		//×¢Ïú
		session.invalidate();
		//Ìø×ª
		PrintWriter out= response.getWriter();
		
		out.write("<script>window.parent.location.href='web/login.jsp'</script>");
	}

}
