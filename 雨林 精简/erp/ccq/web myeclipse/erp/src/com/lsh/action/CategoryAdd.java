/**
 * 
 */
package com.lsh.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lsh.domain.Category;
import com.lsh.service.CategoryService;
import com.lsh.service.CategoryServiceImpl;

/**
 * @author ������
 *
 * 2015-2-10����06:25:26
 */
public class CategoryAdd extends HttpServlet {

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		CategoryService service=new CategoryServiceImpl();
		String code=request.getParameter("code");
		String name=request.getParameter("name");
		String info=request.getParameter("info");
		Category category=new Category(code,name,info);
		
		String path="";
		if(service.add(category)){
			path="cation";
		}else{
			path="/web/page/categoryadd.jsp";
			request.setAttribute("q", "����ʧ��");
		}
		response.sendRedirect(path);
	
	}
	
	

}
