/**
 * 
 */
package com.f.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.omg.PortableInterceptor.ForwardRequest;

import com.f.domain.Category;
import com.f.service.CategoryService;
import com.f.service.CategoryServiceImpl;

/**
 * @author ��ѧ��
 *��������ת
 * 2015-2-10����3:17:54
 */
public class CategoryAdd extends BaseAction{
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		//��ȡ����
		String code=request.getParameter("code");
		String name=request.getParameter("name");
		String info=request.getParameter("info");
		//����������
		Category category=new Category(code,name,info);
		//�������������
		CategoryService service =new CategoryServiceImpl();
		//��Ӳ���
		if(service.add(category)){
			//request.getRequestDispatcher("CategoryList").forward(request, response);
			response.sendRedirect("CategoryList");
		}else{
			request.setAttribute("adderr","���ʧ��");
			request.getRequestDispatcher("web/page/categoryadd.jsp").forward(request, response);
		}
	
	}

}
