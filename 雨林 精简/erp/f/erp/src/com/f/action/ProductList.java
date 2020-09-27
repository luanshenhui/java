package com.f.action;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.f.domain.Product;
import com.f.service.ProductService;
import com.f.service.ProductServiceImpl;


public class ProductList extends BaseAction{
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		//获取商品业务对象
		ProductService service =new ProductServiceImpl();
		//获取所有商品的 集合
		List<Product> list=service.getAll();
		//存储
		
		request.setAttribute("productlist",list);
		
		
		//跳转页面
		request.getRequestDispatcher("web/page/productlist.jsp").forward(request, response);
		
	}
}
