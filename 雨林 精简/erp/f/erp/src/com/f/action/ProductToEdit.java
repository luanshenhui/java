package com.f.action;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.f.domain.Category;
import com.f.domain.Product;
import com.f.service.CategoryService;
import com.f.service.CategoryServiceImpl;
import com.f.service.ProductServiceImpl;



/**
 * 
 * @author 冯学明
 *编辑商品跳转
 * 2015-2-11下午2:56:49
 */
public class ProductToEdit extends BaseAction{
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		//获取当前的ID
		int id= Integer.parseInt(request.getParameter("pid"));
		//拿到商品
		Product product= new ProductServiceImpl().getByID(id);
		
		//拿到所有类别
		CategoryService service =new CategoryServiceImpl();
		List<Category> list=service.getAll();
		//存储至页面
		request.setAttribute("product",product);		
		request.setAttribute("categorylist",list);
		String aname=request.getParameter("aname");
		request.setAttribute("aname",aname);
		
		//跳转
		request.getRequestDispatcher("web/page/productedit.jsp").forward(request, response);
		
	}

}
