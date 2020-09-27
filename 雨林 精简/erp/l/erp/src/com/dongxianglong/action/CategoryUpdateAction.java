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
 * 类别更新控制器
 * @author 董祥龙
 *
 * 2015-2-10下午07:14:43
 */
public class CategoryUpdateAction extends BaseAction {

	
	protected void excute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String id=request.getParameter("id");
		String name=request.getParameter("name");
		
		String info=request.getParameter("info");
		
		CategoryService service=new CategoryServiceImpl();
		Category cate=service.getByID(Long.parseLong(id));
		cate.setName(name);
		cate.setInfo(info);
		
		boolean boo=service.update(cate);
		if(boo){
			request.getRequestDispatcher("/catelist").forward(request, response);
		//response.sendRedirect("/erp/catelist");
		}
		else
		{
			response.sendRedirect("/erp/web/page/categoryedit.jsp");
		}
		
	}
	
	

}
