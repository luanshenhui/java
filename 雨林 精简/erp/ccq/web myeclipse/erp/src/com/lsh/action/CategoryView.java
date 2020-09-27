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
 * 2015-2-11����09:11:25
 */
public class CategoryView extends HttpServlet {

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		CategoryService service=new CategoryServiceImpl();
		long id=Long.parseLong(request.getParameter("id"));
		Category category=service.getByID(id);
		request.setAttribute("category", category);
		
		request.getRequestDispatcher("/web/page/categoryview.jsp").forward(request, response);
//		request.getRequestDispatcher("cation").forward(request, response);
	}

}
