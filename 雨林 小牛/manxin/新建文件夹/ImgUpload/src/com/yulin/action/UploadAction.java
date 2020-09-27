package com.yulin.action;

import java.io.File;

import org.apache.struts2.ServletActionContext;

import com.yulin.FileUtil;

public class UploadAction {
	//输入
	private File some;//拦截器给的临时文件
	private String someFileName;//原始文件名
	
	public String execute(){
		if(some == null)
			return "error";
		//1.拼写一个与部署项目相对的路径
		String path = "upload/" + someFileName;
		//2.根据相对路径得到绝对路径
		path = ServletActionContext.getServletContext().getRealPath(path);
		//3.将临时文件复制到绝对路径下
		FileUtil.copy(some, new File(path));
		return "success";
	}

	public File getSome() {
		return some;
	}

	public void setSome(File some) {
		this.some = some;
	}

	public String getSomeFileName() {
		return someFileName;
	}

	public void setSomeFileName(String someFileName) {
		this.someFileName = someFileName;
	}
	
}
