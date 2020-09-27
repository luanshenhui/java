package com.dongxianglong.action;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dongxianglong.domain.Category;
import com.dongxianglong.service.CategoryService;
import com.dongxianglong.service.CategoryServiceImpl;
/**
 * 类别添加控制器
 * @author 董祥龙
 *
 * 2015-2-10下午03:35:08
 */
public class CategoryAddAction extends BaseAction {

	
	
	protected void excute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
request.setCharacterEncoding("UTF-8");
		
		String code=request.getParameter("code");
		String name=request.getParameter("name");
		String info=request.getParameter("info");
		
		CategoryService service=new CategoryServiceImpl();
		Category category=new Category();
		category.setCode(code);
		category.setName(name);
		category.setInfo(info);
		boolean boo=service.add(category);
		if(boo){
			
		//request.getRequestDispatcher("/catelist").forward(request, response);
			response.sendRedirect("/erp/catelist");
		}
		else
		{
		//request.getRequestDispatcher("/web/page/categoryadd.jsp").forward(request, response);
			response.sendRedirect("/erp/web/page/categoryadd.jsp");
		}
		
		
		
	}
	
}
