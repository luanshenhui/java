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
 * @author 冯学明
 *对商品查看，编辑，删除控制器
 * 2015-2-11下午2:20:48
 */
public class ProductOperate extends BaseAction{
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		//获取超链接名
		String aname=(String)request.getParameter(("aname"));
		//获取对象id
		int pid= Integer.parseInt(request.getParameter("pid"));
		//获取商品服务对象
		ProductService service =new ProductServiceImpl();
		//拿到商品
		Product product= new ProductServiceImpl().getByID(pid);
		//查看操作
		if(aname.equals("View")){
			//存储至页面
		request.setAttribute("product",product);
			//跳转
		request.getRequestDispatcher("web/page/productview.jsp").forward(request, response);
			
		}
		//编辑操做

		if(aname.equals("Edit")){
			//获取修改后的数据
		
			String code=request.getParameter("code");
			String name=request.getParameter("name");
			String info=request.getParameter("info");
			int cid=Integer.parseInt(request.getParameter("cid"));
			
			double price=Double.parseDouble(request.getParameter("price"));
			Category category=new CategoryServiceImpl().getByID(cid);
			//修改数据	
			product.setCode(code);
			product.setName(name);
			product.setInfo(info);
			product.setPrice(price);
			product.setCategory(category);
			//修改成功跳转
			if(service.update(product)){
				response.sendRedirect("ProductList");
			}else{
				//request.setAttribute("adderr","添加失败");
				//request.getRequestDispatcher("web/page/categoryadd.jsp").forward(request, response);
			}
			
	}
		//删除操作
		if(aname.equals("Delete")){
			//删除
			service.delete(pid);
			//跳转
			response.sendRedirect("ProductList");
		}
	}

}
