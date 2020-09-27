/**
 * 
 */
package com.f.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.f.domain.Category;
import com.f.domain.Product;
import com.f.service.CategoryServiceImpl;
import com.f.service.ProductService;
import com.f.service.ProductServiceImpl;



/**
 * @author 冯学明
 * 添加商品控制器
 * 2015-2-11下午1:31:16
 */
public class ProductAdd extends BaseAction{
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		//获取数据
		int cid=Integer.parseInt(request.getParameter("cid"));
		String code=request.getParameter("code");
		String name=request.getParameter("name");
		double price=Double.parseDouble(request.getParameter("price"));
		String info=request.getParameter("info");
		//创建商品对象
		//查找类别
		Category category=new CategoryServiceImpl().getByID(cid);
		Product product=new Product();
		product.setCode(code);
		product.setName(name);
		product.setPrice(price);
		product.setInfo(info);
		product.setCategory(category);
		//创建商品服务对象
		ProductService service =new ProductServiceImpl();
		//添加操作
		if(service.add(product)){
			response.sendRedirect("ProductList");
		}else{
			request.setAttribute("adderr","添加失败");
			request.getRequestDispatcher("web/page/productadd.jsp").forward(request, response);
		}
	
	}

}
