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
 * @author 冯学明
 *类别添加跳转
 * 2015-2-10下午3:17:54
 */
public class CategoryAdd extends BaseAction{
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		//获取数据
		String code=request.getParameter("code");
		String name=request.getParameter("name");
		String info=request.getParameter("info");
		//创建类别对象
		Category category=new Category(code,name,info);
		//创建类别服务对象
		CategoryService service =new CategoryServiceImpl();
		//添加操作
		if(service.add(category)){
			//request.getRequestDispatcher("CategoryList").forward(request, response);
			response.sendRedirect("CategoryList");
		}else{
			request.setAttribute("adderr","添加失败");
			request.getRequestDispatcher("web/page/categoryadd.jsp").forward(request, response);
		}
	
	}

}
