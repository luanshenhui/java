/**
 * 
 */
package com.lsh.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author ������
 *
 * 2015-2-9����05:55:55
 */
public class EditPasd extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String oldpassword=request.getParameter("oldpassword");
		String newpassword=request.getParameter("newpassword");
		String repassword=request.getParameter("repassword");
		
		if(oldpassword.equals(anObject)){
			
		}
	}
	
	

}
