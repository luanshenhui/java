package com.dongxianglong.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dongxianglong.domain.Product;
import com.dongxianglong.service.ProductService;
import com.dongxianglong.service.ProductServiceImpl;

/**
 * 查看单个商品控制器
 * @author 董祥龙
 *
 * 2015-2-12上午09:17:32
 */
public class ProductViewAction extends HttpServlet {

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
          
		String id=request.getParameter("id");
		
		ProductService service=new ProductServiceImpl();
		Product product=service.getByID(Long.parseLong(id));
		request.setAttribute("productview", product);
		request.getRequestDispatcher("/web/page/productview.jsp").forward(request, response);
	}
	
	
	

}
