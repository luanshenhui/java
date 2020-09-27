package com.yulin.web.Servlet;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
public class ShoppingServlet2 extends HttpServlet {
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			request.setCharacterEncoding("utf-8");
			response.setCharacterEncoding("utf-8");
//			response.setContentType("charset=utf-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		/* 处理特殊表单 */
		DiskFileItemFactory dff = new DiskFileItemFactory();
		//创建一个用来处理上传数据的工厂类对象
		
		ServletFileUpload sfu = new ServletFileUpload(dff);
		//一个容器，用来解析request对象及其表单中的上传数据，这个类需要用到上面的工厂类
		
		try {
			List<FileItem> fi = sfu.parseRequest(request); 
			//解析请求,获得数据集，包含所有的表单数据。
			String ss[] = new String[3]; //商品的信息
			/* 判断数据集中的数据是表单数据还是文件数据 */
			for(int i = 0; i < fi.size(); i++){
				FileItem item = fi.get(i);
				if(item.isFormField()){//判断这个数据是否是普通的表单数据
					ss[i] = item.getString(); //获得并将商品信息保存至数组
				}else{
					//把图片输出到某一个文件夹
					/**
					 * 1.获得路径
					 * 2.创建文件夹
					 * 3.创建文件
					 * 4.向文件中写入数据
					 */
					String uploadPath = 
						request.getRealPath(this.getClass().getName());
					//获得当前项目在服务器中的路径。
					new UploadService().upload(uploadPath, item, ss[0]);
				}
			}
			//保存商品 
			//insert(new Computer(ss[0], ss[1], ss[2]));
			
		} catch (FileUploadException e) {
			e.printStackTrace();
		}
	}
}



