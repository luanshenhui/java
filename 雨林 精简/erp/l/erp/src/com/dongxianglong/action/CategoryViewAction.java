package com.dongxianglong.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dongxianglong.domain.Category;
import com.dongxianglong.service.CategoryService;
import com.dongxianglong.service.CategoryServiceImpl;
/**
 * 查看单个类别控制器
 * @author 董祥龙
 *
 * 2015-2-10下午06:19:59
 */
public class CategoryViewAction extends BaseAction {


	protected void excute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		String id=request.getParameter("id");
	    CategoryService service=new CategoryServiceImpl();
	    Category category1=service.getByID(Long.parseLong(id));
	    request.setAttribute("categoryview", category1);
	    
	    request.getRequestDispatcher("/web/page/categoryview.jsp").forward(request, response);
		
	}
	
	
	

}
