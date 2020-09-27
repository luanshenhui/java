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
 * 商品添加控制器
 * @author 董祥龙
 *
 * 2015-2-11下午02:46:25
 */
public class ProductAddAction extends HttpServlet {

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
          
		 request.setCharacterEncoding("UTF-8");
		 
		 String code=request.getParameter("code");
		 String name=request.getParameter("name");
		 String price=request.getParameter("price");
		 String info=request.getParameter("info");
		 String cid=request.getParameter("cid");
		 ProductService service=new ProductServiceImpl();
	 CategoryService service1=new CategoryServiceImpl();

		 Product product=new Product();
		 
		 product.setCode(code);
		 product.setName(name);
		 product.setPrice(Double.parseDouble(price));
		 product.setInfo(info);
		 product.setCategory(service1.getByID(Long.parseLong(cid)));
		 boolean boo=service.add(product);
		 if(boo)
		 {
			 response.sendRedirect("/erp/productlist");
		 }
		 else
		 {
			 response.sendRedirect("/erp/web/page/productadd.jsp");
			 
		 }
		 
		 
		
	}
	
	
	
	

}
