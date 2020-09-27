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
 * 
 * @author ��ѧ��
 *�����鿴���༭��ɾ��������
 * 2015-2-11����2:20:58
 */

public class CategoryOperate extends BaseAction{
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		//��ȡ��������
				String aname=(String)request.getParameter(("aname"));
				//��ȡ����id
				int cid= Integer.parseInt(request.getParameter("cid"));
				//��ȡ��������
				CategoryService service =new CategoryServiceImpl();
				//�õ����
				Category category= new CategoryServiceImpl().getByID(cid);
				//�鿴����
				
				if(aname.equals("View")){
					//�洢��ҳ��
					request.setAttribute("category",category);
					//��ת
					request.getRequestDispatcher("web/page/categoryview.jsp").forward(request, response);
				}
				if(aname.equals("Edit")){
					//��ȡ�޸ĺ������
					String code=request.getParameter("code");
					String name=request.getParameter("name");
					String info=request.getParameter("info");
					//�޸�����
					category.setCode(code);
					category.setName(name);
					category.setInfo(info);
						
					//�޸ĳɹ���ת
					if(service.update(category)){
						response.sendRedirect("CategoryList");
					}else{
						//request.setAttribute("adderr","���ʧ��");
						request.getRequestDispatcher("web/page/categoryadd.jsp").forward(request, response);
					}
				}
				//ɾ������
				if(aname.equals("Delete")){
					//ɾ��
					service.delete(cid);
					//��ת
					response.sendRedirect("CategoryList");
				}
	}
}
