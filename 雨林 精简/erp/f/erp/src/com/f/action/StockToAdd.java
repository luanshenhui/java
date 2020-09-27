/**
 * 
 */
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



/**
 * @author 冯学明
 * 跳转     进货控制器
 * 2015-2-12下午2:28:42
 */
public class StockToAdd extends BaseAction {
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		//获取商品集合
		ProductService service=new ProductServiceImpl();
		List<Product> list=service.getAll();
		//存储至页面
		request.setAttribute("productlist",list);
	
		//跳转至添加控制器
		request.getRequestDispatcher("web/page/stockadd.jsp").forward(request, response);
	
	}

}
