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
 * Àà±ð±à¼­¿ØÖÆÆ÷
 * @author ¶­ÏéÁú
 *
 * 2015-2-10ÏÂÎç07:10:01
 */
public class CategoryEditAction extends BaseAction {

	

	
	protected void excute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
        String id=request.getParameter("id");
		
		CategoryService service=new CategoryServiceImpl();
		
		Category category2=service.getByID(Long.parseLong(id));
		request.setAttribute("category2",category2);
		request.getRequestDispatcher("/web/page/categoryedit.jsp").forward(request, response);

	}
	
	

}
