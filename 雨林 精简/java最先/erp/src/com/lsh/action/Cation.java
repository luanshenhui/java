/**
 * 
 */
package com.lsh.action;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.lsh.domain.Category;
import com.lsh.service.CategoryService;
import com.lsh.service.CategoryServiceImpl;

/**
 * @author ������
 *
 * 2015-2-10����02:30:51
 */
public class Cation extends HttpServlet {

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
		
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		CategoryService service=new CategoryServiceImpl();
		List<Category>list=service.getAll();
	//	HttpSession session=request.getSession();
		
		
			request.setAttribute("Category",list);
	
		request.getRequestDispatcher("/web/page/categorylist.jsp").forward(request, response);
	}


	
	

}
