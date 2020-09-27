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
 * �鿴ȫ����������
 * @author ������
 *
 * 2015-2-10����02:23:50
 */
public class CategorylistAction extends BaseAction {

	
	
	protected void excute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
        CategoryService service=new CategoryServiceImpl();
		
		List<Category>list=service.getAll();
		request.setAttribute("all",list);
		request.getRequestDispatcher("/web/page/categorylist.jsp").forward(request, response);
		
	}

	
}
