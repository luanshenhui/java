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
 *查看全部类别控制器
 * 2015-2-10下午2:13:47
 */
public class CategoryList extends BaseAction{
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		//获取类别对象
		CategoryService service =new CategoryServiceImpl();
		//获取所有类别的 集合
		List<Category> list=service.getAll();
		//存储		
		request.setAttribute("categorylist",list);

		//跳转页面
		request.getRequestDispatcher("web/page/categorylist.jsp").forward(request, response);
		
	}
}
