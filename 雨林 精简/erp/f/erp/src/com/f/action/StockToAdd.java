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

import com.f.domain.Product;
import com.f.service.ProductService;
import com.f.service.ProductServiceImpl;



/**
 * @author ��ѧ��
 * ��ת     ����������
 * 2015-2-12����2:28:42
 */
public class StockToAdd extends BaseAction {
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		//��ȡ��Ʒ����
		ProductService service=new ProductServiceImpl();
		List<Product> list=service.getAll();
		//�洢��ҳ��
		request.setAttribute("productlist",list);
	
		//��ת����ӿ�����
		request.getRequestDispatcher("web/page/stockadd.jsp").forward(request, response);
	
	}

}
