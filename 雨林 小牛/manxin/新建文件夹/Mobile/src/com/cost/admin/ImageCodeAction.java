package com.cost.admin;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.InputStream;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import com.cost.action.BaseAction;
import com.cost.util.ImageUtil;

public class ImageCodeAction
	extends BaseAction{
	
	//输出
	private InputStream imageStream;
	
	public String execute() {
		//1.调用图片生成工具，生成一个图片及验证码
		Map<String,BufferedImage> map = 
			ImageUtil.createImage();
		
		//2.将map里的验证码取出
		String code = null;
		Set<String> set = map.keySet();
		Iterator<String> it = set.iterator();
		while(it.hasNext()) {
			code = it.next();
		}
		
		//3.将验证码放入session，后面验证要用
		session.put("imageCode", code);
		
		//4.将map里的图片取出
		BufferedImage image = 
			map.get(code);
		try {
			imageStream = 
				ImageUtil.getInputStream(image);
		} catch (IOException e) {
			e.printStackTrace();
			return "error";
		}
		
		return "success";
	}

	public InputStream getImageStream() {
		return imageStream;
	}

	public void setImageStream(InputStream imageStream) {
		this.imageStream = imageStream;
	}

}

