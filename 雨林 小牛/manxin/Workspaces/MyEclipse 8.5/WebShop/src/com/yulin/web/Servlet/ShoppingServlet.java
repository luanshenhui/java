package com.yulin.web.Servlet;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.sun.faces.taglib.html_basic.InputSecretTag;
import com.yulin.web.entity.Shopping;
import com.yulin.web.entity.ShoppingCart;
import com.yulin.web.service.ShoppingCartService;
import com.yulin.web.service.ShoppingService;
import com.yulin.web.service.UploadService;

public class ShoppingServlet extends HttpServlet{
	
	
	
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		ShoppingService ss = new ShoppingService();
		HttpSession session = request.getSession();
		UploadService us = new UploadService();
		ShoppingCartService scs = new ShoppingCartService();
		/*编码格式*/
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		
		/*处理地址*/
		String shopPath = request.getRequestURI();
		shopPath = shopPath.substring(shopPath.lastIndexOf("/"), shopPath.lastIndexOf("."));
		
		/*处理请求*/
		if("/add".equals(shopPath)){
			/*图片上传处理,详见ServletImg*/
			DiskFileItemFactory dff = new DiskFileItemFactory();
			ServletFileUpload sfu = new ServletFileUpload(dff);
			String uploadPath = "";
			try {
				List<FileItem> fi = sfu.parseRequest(request);
				String str[] = new String[3];//商品的信息
				
				for(int i = 0; i < fi.size(); i++){
					FileItem item = fi.get(i);
					if(item.isFormField()){//判断这个数据是否是普通的表单数据
						str[i] = item.getString();//获得并将商品信息保存至数组
					}else{
						uploadPath = request.getRealPath(this.getClass().getName());
						new UploadService().upload(uploadPath,item,str[0]);//封装Service
					}
				}
				if(ss.insert(str[0],str[1],Integer.decode(str[2]))){
					System.out.println("添加成功！");
					response.sendRedirect("computer_list.do");
				}else{
					System.out.println("添加失败！");
				}
			} catch (FileUploadException e) {
				e.printStackTrace();
			}
		}else if("/computer_list".equals(shopPath)){
			ArrayList<Shopping> list = (ArrayList<Shopping>)ss.findAll();
			request.setAttribute("list", list);
			request.getRequestDispatcher("computer_list.jsp").forward(request, response);
		}else if("/toCart".equals(shopPath)){
			String t_name = request.getParameter("name");
			System.out.println(t_name);
			double t_price = 0;
			
			ArrayList<Shopping> shopCart = (ArrayList<Shopping>)scs.finfByName(t_name);
			for(int i = 0; i < shopCart.size(); i++){
				Shopping shopping = shopCart.get(i);
				t_price = shopping.getT_price();
			}
			if(scs.findCartByName(t_name).size() == 0){
				scs.insert(t_name, t_price, 1);
			}else{
				scs.updateNum(t_name);
			}
			response.sendRedirect("computer_list.do");
			
		}else if("/cart".equals(shopPath)){
			ArrayList<ShoppingCart> list = (ArrayList<ShoppingCart>)scs.findAll();
			request.setAttribute("list", list);
			request.getRequestDispatcher("cart.jsp").forward(request, response);
			
		}else if("/upNum".equals(shopPath)){
			String t_name = request.getParameter("name");
			System.out.println(t_name);
			double t_num = Integer.decode(request.getParameter("num"));
			System.out.println(t_num);
			if(scs.updateCartNum(t_name, t_num)){
				System.out.println("修改成功！");
//				response.sendRedirect("cart.do");
			}else{
				System.out.println("修改失败！");
			}
			response.sendRedirect("cart.do");
		}else if("/delete".equals(shopPath)){
			String t_name = request.getParameter("name");
			System.out.println(t_name);
			if(scs.delete(t_name)){
				System.out.println("删除成功！");
//				response.sendRedirect("cart.do");
			}else{
				System.out.println("删除失败！");
			}
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
