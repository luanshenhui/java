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
import com.lsh.service.CategoryService;
import com.lsh.service.CategoryServiceImpl;

/**
 * @author ������
 *
 * 2015-2-12����02:24:51
 */
public class ProductAdd extends HttpServlet {

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doPost(request, response);
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
//		ProductService service=new ProductServiceImpl();
//		String code=request.getParameter("code");
//		String name=request.getParameter("name");
//		String cid=request.getParameter("cid");
//		String info=request.getParameter("info");
//		String price=request.getParameter("price");
//		
//
//		CategoryService ser=new CategoryServiceImpl();
//		Category category=ser.getByID(Long.parseLong(cid));
//		Product product=new Product();
//		product.setCode(code);
//		product.setName(name);
//		product.setInfo(info);
//		product.setPrice(Double.parseDouble(price));
//		product.setCategory(category);
		CategoryService service=new CategoryServiceImpl();
		List<Category>list=service.getAll();
		
		
	//System.out.println(list);
			request.setAttribute("glist",list);
	
	
		request.getRequestDispatcher("/web/page/productadd.jsp").forward(request, response);
		
		
//		String path="";

//		if(service.add(product)){
//			path="productaction";
//		}else{
//			path="/web/page/productadd.jsp";
//			request.setAttribute("q", "����ʧ��");
//		}
//		response.sendRedirect(path);
	
	}
	
	

}
