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
 * @author ��ѧ��
 *���������Ʒ ��ת
 * 2015-2-11����1:38:08
 */
public class ProductToAdd extends BaseAction{	
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		//�õ��������
		CategoryService service =new CategoryServiceImpl();
		List<Category> list=service.getAll();
		//�洢		
		request.setAttribute("categorylist",list);
		
		//��ת
		request.getRequestDispatcher("web/page/productadd.jsp").forward(request, response);
		
	}


}
