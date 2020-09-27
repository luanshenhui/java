package com.yulin.web.Servlet;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.yulin.web.service.UploadService;

public class ServletImg extends HttpServlet{
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");
		
		DiskFileItemFactory dff = new DiskFileItemFactory();
		//创建一个用来处理上传数据的工厂类对象
		ServletFileUpload sfu = new ServletFileUpload(dff);
		//一个容器，用来解析request对象及其表单中的上传数据，这个类需要用到上面的工厂类
		try {
			//解析请求,获得数据集，包含所有的表单数据
			List<FileItem> fi = sfu.parseRequest(request);
			String ss[] = new String[3];//商品的信息
			//判断数据集中的数据是表单数据还是文件数据
			for(int i = 0; i < fi.size(); i++){
				FileItem item = fi.get(i);
				if(item.isFormField()){//判断这个数据是否是普通的表单数据
					ss[i] = item.getString();//获得并将商品信息保存至数组
//					System.out.println(item.getString());
				}else{
//					System.out.println(item.getString());
					//把图片输出到某一个文件夹
					String uploadPath = request.getRealPath(this.getClass().getName());
					new UploadService().upload(uploadPath,item,ss[0]);//封装Service
				}
			}
			//保存商品 	new Computer(ss[0],ss[1],ss[2]);
		} catch (FileUploadException e) {
			e.printStackTrace();
		}
	}
}
