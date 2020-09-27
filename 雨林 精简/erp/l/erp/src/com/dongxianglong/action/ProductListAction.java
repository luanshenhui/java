package com.dongxianglong.action;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dongxianglong.domain.Product;
import com.dongxianglong.service.ProductService;
import com.dongxianglong.service.ProductServiceImpl;

/**
 * 查看所有商品控制器
 * @author 董祥龙
 *
 * 2015-2-11下午01:37:03
 */
public class ProductListAction extends HttpServlet {

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		ProductService service=new ProductServiceImpl();
		List<Product>list=service.getAll();
		request.setAttribute("allproduct", list);		
		
		request.getRequestDispatcher("/web/page/productlist.jsp").forward(request, response);
	}

	
	
}
