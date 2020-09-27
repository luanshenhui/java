package com.dongxianglong.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dongxianglong.service.ProductService;
import com.dongxianglong.service.ProductServiceImpl;
/**
 * ÉÌÆ·É¾³ý¿ØÖÆÆ÷
 * @author ¶­ÏéÁú
 *
 * 2015-2-12ÏÂÎç01:33:49
 */
public class ProductDeletAction extends HttpServlet {

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		String id=request.getParameter("id");
		
		ProductService service=new ProductServiceImpl();
		boolean boo=service.delete(Long.parseLong(id));
		if(boo)
		{
		request.getRequestDispatcher("/productlist").forward(request, response);	
		}
		
	}
	
	
	

}
