/**
 * 
 */
package com.lsh.action;

import javax.servlet.http.HttpServlet;

/**
 * @author ������
 *
 * 2015-2-11����03:08:17
 */

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
 *         2015-2-11����11:06:25
 */
public class CategoryEditChange extends HttpServlet {

	// �����޸�ҳ��
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		this.doPost(request, response);
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		CategoryService service = new CategoryServiceImpl();
		long id = Long.parseLong(request.getParameter("id"));
		Category category = service.getByID(id);
		category.setCode(request.getParameter("code"));
		category.setInfo(request.getParameter("info"));
		category.setName(request.getParameter("name"));

		if (service.update(category)) {
			//request.setAttribute("category", category);
			request.getRequestDispatcher("/cation").forward(request, response);

		}else{
			response.sendRedirect("web/login.jsp");
		}

	}

}
