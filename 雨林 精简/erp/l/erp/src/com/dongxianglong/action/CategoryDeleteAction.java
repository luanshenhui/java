package com.dongxianglong.action;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dongxianglong.service.CategoryService;
import com.dongxianglong.service.CategoryServiceImpl;

/**
 * Àà±ðÉ¾³ý¿ØÖÆÆ÷
 * @author ¶­ÏéÁú
 *
 * 2015-2-11ÉÏÎç10:59:26
 */
public class CategoryDeleteAction extends BaseAction {

	
	

	
	protected void excute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
String id=request.getParameter("id");
		
		CategoryService service=new CategoryServiceImpl();
		boolean boo=service.delete(Long.parseLong(id));
		if(boo)
		{
			request.getRequestDispatcher("/catelist").forward(request, response);
		}
		
		
		
	}
	
	
	

}
