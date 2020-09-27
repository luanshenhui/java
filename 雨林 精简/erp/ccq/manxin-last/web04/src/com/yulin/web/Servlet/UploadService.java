package com.yulin.web.Servlet;

import java.io.File;
import java.io.IOException;

import org.apache.commons.fileupload.FileItem;

public class UploadService {

	public void upload(String uploadPath, FileItem item, String name) 
		throws IOException{
		uploadPath = uploadPath.substring(0, 
				uploadPath.lastIndexOf("\\")+1);
		//获得项目在服务器中的绝对路径
		uploadPath = uploadPath + "upload"; //upload文件夹的路径
		File file = new File(uploadPath);
		if(!file.exists()){
			file.mkdir();
		}
		String houZhui = item.getName().substring(
				item.getName().lastIndexOf("."));//获得图片的后缀
		String filePath = uploadPath+File.separator+name+houZhui;
		//File.separator :　文件夹的分隔符
		System.out.println(filePath);
		File photo = new File(filePath);
		photo.createNewFile();
		try {
			item.write(photo);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}
