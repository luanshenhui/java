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

import com.lsh.domain.Category;
import com.lsh.domain.Product;
import com.lsh.service.CategoryService;
import com.lsh.service.CategoryServiceImpl;
import com.lsh.service.ProductService;
import com.lsh.service.ProductServiceImpl;

/**
 * @author èïÉ÷»Ô
 *
 * 2015-2-12ÏÂÎç01:46:46
 */
public class ProductAction extends HttpServlet {

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
		
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		ProductService service=new ProductServiceImpl();
		List<Product>list=service.getAll();
	
		
		
		
			request.setAttribute("Product",list);
		request.getRequestDispatcher("/web/page/productlist.jsp").forward(request, response);
	}


	
	

}
