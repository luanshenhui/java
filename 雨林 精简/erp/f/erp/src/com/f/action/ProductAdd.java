/**
 * 
 */
package com.f.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.f.domain.Category;
import com.f.domain.Product;
import com.f.service.CategoryServiceImpl;
import com.f.service.ProductService;
import com.f.service.ProductServiceImpl;



/**
 * @author ��ѧ��
 * �����Ʒ������
 * 2015-2-11����1:31:16
 */
public class ProductAdd extends BaseAction{
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		//��ȡ����
		int cid=Integer.parseInt(request.getParameter("cid"));
		String code=request.getParameter("code");
		String name=request.getParameter("name");
		double price=Double.parseDouble(request.getParameter("price"));
		String info=request.getParameter("info");
		//������Ʒ����
		//�������
		Category category=new CategoryServiceImpl().getByID(cid);
		Product product=new Product();
		product.setCode(code);
		product.setName(name);
		product.setPrice(price);
		product.setInfo(info);
		product.setCategory(category);
		//������Ʒ�������
		ProductService service =new ProductServiceImpl();
		//��Ӳ���
		if(service.add(product)){
			response.sendRedirect("ProductList");
		}else{
			request.setAttribute("adderr","���ʧ��");
			request.getRequestDispatcher("web/page/productadd.jsp").forward(request, response);
		}
	
	}

}
