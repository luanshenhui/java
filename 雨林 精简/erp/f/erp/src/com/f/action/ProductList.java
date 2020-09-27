package com.f.action;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.f.domain.Product;
import com.f.service.ProductService;
import com.f.service.ProductServiceImpl;


public class ProductList extends BaseAction{
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		//��ȡ��Ʒҵ�����
		ProductService service =new ProductServiceImpl();
		//��ȡ������Ʒ�� ����
		List<Product> list=service.getAll();
		//�洢
		
		request.setAttribute("productlist",list);
		
		
		//��תҳ��
		request.getRequestDispatcher("web/page/productlist.jsp").forward(request, response);
		
	}
}
