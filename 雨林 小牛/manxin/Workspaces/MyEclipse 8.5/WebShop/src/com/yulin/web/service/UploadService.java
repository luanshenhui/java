package com.yulin.web.service;

import java.io.File;
import java.io.IOException;

import org.apache.commons.fileupload.FileItem;

public class UploadService {

	public void upload(String uploadPath, FileItem item, String name) throws IOException{
		uploadPath = uploadPath.substring(0, uploadPath.lastIndexOf("\\") + 1);
		//获得项目在服务器中的绝对路径
		uploadPath = uploadPath + "upload";//upload文件夹的路径
		File file = new File(uploadPath);
		if(!file.exists()){
			file.mkdir();
		}
		//获得图片的后缀
		String houZhui = item.getName().substring(item.getName().lastIndexOf("."));
		String filePath = uploadPath + File.separator + name + houZhui;//ss[0]商品的名字    
		//File.separator ： 文件夹的分隔符
//		System.out.println(filePath);
		File photo = new File(filePath);
		photo.createNewFile();
//		OutputStream os = new FileOutputStream(photo);
//		InputStream is = item.getInputStream();//获得数据流
//		int in;
//		while((in = is.read()) != -1){
//			os.write(in);
//		}
//		is.close();
//		os.close();
		try {
			item.write(photo);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}
