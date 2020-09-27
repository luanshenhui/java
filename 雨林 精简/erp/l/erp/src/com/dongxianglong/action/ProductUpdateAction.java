package com.dongxianglong.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dongxianglong.domain.Product;
import com.dongxianglong.service.CategoryService;
import com.dongxianglong.service.CategoryServiceImpl;
import com.dongxianglong.service.ProductService;
import com.dongxianglong.service.ProductServiceImpl;

/**
 * 商品更新控制器
 * @author 董祥龙
 *
 * 2015-2-12下午01:07:29
 */
public class ProductUpdateAction extends HttpServlet {

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		request.setCharacterEncoding("UTF-8");
		
		String id=request.getParameter("id");
		String code=request.getParameter("code");
		String name=request.getParameter("name");
		String price=request.getParameter("price");
		String info=request.getParameter("info");
		String cid=request.getParameter("cid");
		
		ProductService service=new ProductServiceImpl();
		CategoryService service1=new CategoryServiceImpl();
		
		Product product=service.getByID(Long.parseLong(id));
		product.setCode(code);
		product.setName(name);
		product.setPrice(Double.parseDouble(price));
		product.setInfo(info);
		product.setCategory(service1.getByID(Long.parseLong(cid)));
		boolean boo=service.update(product);
      if(boo)
      {
    	request.getRequestDispatcher("/productlist").forward(request, response);  
    	  
      }
      else
      {
    	  request.getRequestDispatcher("/web/page/productedit.jsp").forward(request, response);
      }
		
		
	}
	
	
	
	

}
