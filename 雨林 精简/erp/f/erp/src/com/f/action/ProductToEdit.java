package com.f.action;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.f.domain.Category;
import com.f.domain.Product;
import com.f.service.CategoryService;
import com.f.service.CategoryServiceImpl;
import com.f.service.ProductServiceImpl;



/**
 * 
 * @author ��ѧ��
 *�༭��Ʒ��ת
 * 2015-2-11����2:56:49
 */
public class ProductToEdit extends BaseAction{
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		//��ȡ��ǰ��ID
		int id= Integer.parseInt(request.getParameter("pid"));
		//�õ���Ʒ
		Product product= new ProductServiceImpl().getByID(id);
		
		//�õ��������
		CategoryService service =new CategoryServiceImpl();
		List<Category> list=service.getAll();
		//�洢��ҳ��
		request.setAttribute("product",product);		
		request.setAttribute("categorylist",list);
		String aname=request.getParameter("aname");
		request.setAttribute("aname",aname);
		
		//��ת
		request.getRequestDispatcher("web/page/productedit.jsp").forward(request, response);
		
	}

}
