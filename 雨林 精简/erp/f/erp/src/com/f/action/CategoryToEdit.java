/**
 * 
 */
package com.f.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.omg.PortableInterceptor.ForwardRequest;

import com.f.domain.Category;
import com.f.service.CategoryService;
import com.f.service.CategoryServiceImpl;

/**
 * @author ��ѧ��
 *����޸�
 * 2015-2-10����3:17:54
 */
public class CategoryToEdit extends BaseAction{
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		//��ȡ��ǰ��ID
		int id= Integer.parseInt(request.getParameter("cid"));
		//�õ����
		Category category= new CategoryServiceImpl().getByID(id);
		String aname=request.getParameter("aname");
		
		//�洢��ҳ��
		request.setAttribute("aname", aname);
		request.setAttribute("Category",category);
		//��ת
		request.getRequestDispatcher("web/page/categoryedit.jsp").forward(request, response);
	}

}
