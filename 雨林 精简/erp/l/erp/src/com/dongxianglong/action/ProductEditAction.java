package com.dongxianglong.action;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dongxianglong.domain.Category;
import com.dongxianglong.domain.Product;
import com.dongxianglong.service.CategoryService;
import com.dongxianglong.service.CategoryServiceImpl;
import com.dongxianglong.service.ProductService;
import com.dongxianglong.service.ProductServiceImpl;
/**
 * ÉÌÆ·±à¼­¿ØÖÆÆ÷
 * @author ¶­ÏéÁú
 *
 * 2015-2-12ÉÏÎç11:49:17
 */
public class ProductEditAction extends HttpServlet {

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		String id=request.getParameter("id");
		
		ProductService service=new ProductServiceImpl();
		Product product1=service.getByID(Long.parseLong(id));
		
		CategoryService service1=new CategoryServiceImpl();
    	 List<Category>catelist=service1.getAll();
		
		 request.setAttribute("catelist1", catelist);
		
		request.setAttribute("product1",product1);
		
		request.getRequestDispatcher("/web/page/productedit.jsp").forward(request, response);
	}

	
	
	
}
