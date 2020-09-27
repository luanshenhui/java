package com.netctoss.login.action;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

import com.netctoss.util.BaseAction;
import com.netctoss.util.ImageUtil;

public class ImageAction extends BaseAction{

	private InputStream imageStream;
	
	
	public InputStream getImageStream() {
		return imageStream;
	}


	public void setImageStream(InputStream imageStream) {
		this.imageStream = imageStream;
	}


	public String execute(){
		Map<String,BufferedImage> map=ImageUtil.createImage();
		//将map里的图片取出
		String code=map.keySet().iterator().next();
		session.put("code",code);
		//将图片取出来
		BufferedImage image=map.get(code);
		try {
			imageStream=ImageUtil.getInputStream(image);
		} catch (IOException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}

}
