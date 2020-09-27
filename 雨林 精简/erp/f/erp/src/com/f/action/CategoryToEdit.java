/**
 * 
 */
package com.f.action;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.omg.PortableInterceptor.ForwardRequest;

import com.f.domain.Category;
import com.f.service.CategoryService;
import com.f.service.CategoryServiceImpl;

/**
 * @author 冯学明
 *类别修改
 * 2015-2-10下午3:17:54
 */
public class CategoryToEdit extends BaseAction{
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		//获取当前的ID
		int id= Integer.parseInt(request.getParameter("cid"));
		//拿到类别
		Category category= new CategoryServiceImpl().getByID(id);
		String aname=request.getParameter("aname");
		
		//存储至页面
		request.setAttribute("aname", aname);
		request.setAttribute("Category",category);
		//跳转
		request.getRequestDispatcher("web/page/categoryedit.jsp").forward(request, response);
	}

}
