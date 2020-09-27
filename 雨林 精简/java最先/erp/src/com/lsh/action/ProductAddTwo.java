/**
 * 
 */
package com.lsh.action;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lsh.domain.Category;
import com.lsh.domain.Product;
import com.lsh.service.CategoryService;
import com.lsh.service.CategoryServiceImpl;
import com.lsh.service.ProductService;
import com.lsh.service.ProductServiceImpl;

/**
 * @author ������
 *
 * 2015-2-13����10:17:34
 */
public class ProductAddTwo extends HttpServlet {

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		ProductService service=new ProductServiceImpl();
		String code=request.getParameter("code");
		String name=request.getParameter("name");
		String cid=request.getParameter("cid");
		String info=request.getParameter("info");
		String price=request.getParameter("price");
		

		CategoryService ser=new CategoryServiceImpl();
		Category category=ser.getByID(Long.parseLong(cid));
		Product product=new Product();
		product.setCode(code);
		product.setName(name);
		product.setInfo(info);
		product.setPrice(Double.parseDouble(price));
		product.setCategory(category);	
		String path="";

		if(service.add(product)){
			path="productaction";
			request.getRequestDispatcher(path).forward(request, response);
//			request.setAttribute("ProductTwo", product);
		}else{
			path="/web/page/productadd.jsp";
			request.setAttribute("q", "����ʧ��");
		}
		
	
	}
	
	

}
