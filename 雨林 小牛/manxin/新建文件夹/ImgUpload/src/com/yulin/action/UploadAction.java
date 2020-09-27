package com.yulin.action;

import java.io.File;

import org.apache.struts2.ServletActionContext;

import com.yulin.FileUtil;

public class UploadAction {
	//����
	private File some;//������������ʱ�ļ�
	private String someFileName;//ԭʼ�ļ���
	
	public String execute(){
		if(some == null)
			return "error";
		//1.ƴдһ���벿����Ŀ��Ե�·��
		String path = "upload/" + someFileName;
		//2.�������·���õ�����·��
		path = ServletActionContext.getServletContext().getRealPath(path);
		//3.����ʱ�ļ����Ƶ�����·����
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
