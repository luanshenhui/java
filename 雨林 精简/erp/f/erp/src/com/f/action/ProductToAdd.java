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
import javax.servlet.http.HttpSession;

import com.f.domain.Category;
import com.f.service.CategoryService;
import com.f.service.CategoryServiceImpl;



/**
 * @author 冯学明
 *配置添加商品 跳转
 * 2015-2-11下午1:38:08
 */
public class ProductToAdd extends BaseAction{	
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		//拿到所有类别
		CategoryService service =new CategoryServiceImpl();
		List<Category> list=service.getAll();
		//存储		
		request.setAttribute("categorylist",list);
		
		//跳转
		request.getRequestDispatcher("web/page/productadd.jsp").forward(request, response);
		
	}


}
