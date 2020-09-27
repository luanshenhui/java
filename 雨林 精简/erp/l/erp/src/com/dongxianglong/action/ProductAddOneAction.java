package com.dongxianglong.action;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dongxianglong.domain.Category;
import com.dongxianglong.service.CategoryService;
import com.dongxianglong.service.CategoryServiceImpl;

public class ProductAddOneAction extends HttpServlet {

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		 CategoryService service1=new CategoryServiceImpl();
     	 List<Category>catelist=service1.getAll();
		
		 request.setAttribute("catelist", catelist);
		 
		 request.getRequestDispatcher("/web/page/productadd.jsp").forward(request, response);
   
		 

		
		
	}
	
	
	

}
