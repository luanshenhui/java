/**
 * 
 */
package com.lsh.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lsh.domain.Category;
import com.lsh.service.CategoryService;
import com.lsh.service.CategoryServiceImpl;

/**
 * @author ������
 *
 * 2015-2-11����10:09:48
 */
public class CategoryDel extends HttpServlet{

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		CategoryService service=new CategoryServiceImpl();
		Long id=Long.parseLong(request.getParameter("id"));
	//	Category category=service.getByID(id);
		
		boolean boo=service.delele(id);
		if(boo){
			//response.sendRedirect("/web/page/categoryview.jsp");
			response.sendRedirect("cation");
		}
		
	}
	
}
