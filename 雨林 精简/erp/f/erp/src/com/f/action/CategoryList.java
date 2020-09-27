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
 *�鿴ȫ����������
 * 2015-2-10����2:13:47
 */
public class CategoryList extends BaseAction{
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		//��ȡ������
		CategoryService service =new CategoryServiceImpl();
		//��ȡ�������� ����
		List<Category> list=service.getAll();
		//�洢		
		request.setAttribute("categorylist",list);

		//��תҳ��
		request.getRequestDispatcher("web/page/categorylist.jsp").forward(request, response);
		
	}
}
