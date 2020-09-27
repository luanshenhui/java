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
import com.f.service.CategoryService;
import com.f.service.CategoryServiceImpl;

/**
 * @author 冯学明
 *
 * 2015-2-11下午4:14:52
 */
public class CategoryEdit extends BaseAction{
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		//获取对象id
		int cid= Integer.parseInt(request.getParameter("cid"));
		//获取类服务对象
		CategoryService service =new CategoryServiceImpl();
		//拿到类别
		Category category= new CategoryServiceImpl().getByID(cid);
		//查看操作
		//获取修改后的数据
		String code=request.getParameter("code");
		String name=request.getParameter("name");
		String info=request.getParameter("info");
		//修改数据
		category.setCode(code);
		category.setName(name);
		category.setInfo(info);
			
		//修改成功跳转
		if(service.update(category)){
			response.sendRedirect("CategoryList");
		}else{
			//request.setAttribute("adderr","添加失败");
			request.getRequestDispatcher("web/page/categoryadd.jsp").forward(request, response);
		}
	}

}
