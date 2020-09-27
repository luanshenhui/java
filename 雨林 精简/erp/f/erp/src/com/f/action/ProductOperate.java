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
 *����Ʒ�鿴���༭��ɾ��������
 * 2015-2-11����2:20:48
 */
public class ProductOperate extends BaseAction{
	@Override
	protected void exectute(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		//��ȡ��������
		String aname=(String)request.getParameter(("aname"));
		//��ȡ����id
		int pid= Integer.parseInt(request.getParameter("pid"));
		//��ȡ��Ʒ�������
		ProductService service =new ProductServiceImpl();
		//�õ���Ʒ
		Product product= new ProductServiceImpl().getByID(pid);
		//�鿴����
		if(aname.equals("View")){
			//�洢��ҳ��
		request.setAttribute("product",product);
			//��ת
		request.getRequestDispatcher("web/page/productview.jsp").forward(request, response);
			
		}
		//�༭����

		if(aname.equals("Edit")){
			//��ȡ�޸ĺ������
		
			String code=request.getParameter("code");
			String name=request.getParameter("name");
			String info=request.getParameter("info");
			int cid=Integer.parseInt(request.getParameter("cid"));
			
			double price=Double.parseDouble(request.getParameter("price"));
			Category category=new CategoryServiceImpl().getByID(cid);
			//�޸�����	
			product.setCode(code);
			product.setName(name);
			product.setInfo(info);
			product.setPrice(price);
			product.setCategory(category);
			//�޸ĳɹ���ת
			if(service.update(product)){
				response.sendRedirect("ProductList");
			}else{
				//request.setAttribute("adderr","���ʧ��");
				//request.getRequestDispatcher("web/page/categoryadd.jsp").forward(request, response);
			}
			
	}
		//ɾ������
		if(aname.equals("Delete")){
			//ɾ��
			service.delete(pid);
			//��ת
			response.sendRedirect("ProductList");
		}
	}

}
