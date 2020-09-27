package com.yulin.web.Servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ShoppingServlet extends HttpServlet{
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		String reqPath = request.getRequestURI();
		if(reqPath.endsWith("web04/add.do")){
		String name = request.getParameter("name");
		System.out.println(name);
		String path = request.getRealPath(this.getClass().getName());
		path = path.substring(0, path.lastIndexOf("\\"));
		System.out.println(path);
		String filePath = path+File.separator+"upload";
		System.out.println(filePath);
		File dir = new File(filePath);
		if(!dir.exists()){
			dir.mkdir();
			System.out.println("创建文件夹！");
		}
		File file = new File(filePath+File.separator+name+".txt");
		file.createNewFile();
		InputStream is = request.getInputStream();
		OutputStream os = new FileOutputStream(file);
		int in;
		while((in = is.read()) != -1){
			os.write(in);
		}				
		is.close();
		os.close();
		/*
			0,添加商品至数据库，表结构在shopping_script文件夹中。
			1,商品列表。
			2,购买商品,添加至购物车，需要再创建一个购物车类和一个购物车表。
			3,查看购物车。
			4,删除购物车当中的商品。
			5,修改购物车当中的商品的数量。
			6,删除购物车中的所有商品。
			7,购物车商品总价。
		*/
	}
}
}













