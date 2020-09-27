package com.dpn.ciqqlc.common.component;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.dpn.ciqqlc.common.util.Constants;

public class ShowVideoServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
	protected static Log logger = LogFactory.getLog(ShowVideoServlet.class);
	/**
	 * Constructor of the object.
	 */
	public ShowVideoServlet() {
		super();
	}

	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			response.setContentType("text/html; charset=gbk");
//			String path = Constants.getMap("text")+request.getParameter("imgPath")+"\\"+request.getParameter("imgName");
//			String path = "D:/"+request.getParameter("imgPath");
			String path = Constants.UP_LOAD_P+request.getParameter("imgPath");
			File file = new File(path);
			if(file.exists()){
				InputStream fis = new FileInputStream(path);
				OutputStream fos = response.getOutputStream();
				BufferedInputStream bis = new BufferedInputStream(fis);
				BufferedOutputStream bos = new BufferedOutputStream(fos);
				// 设置缓存为1M
				byte[] buffer = new byte[1024];
				int bytesRead = 0;
				// 循环取出流中的数据
				while ((bytesRead = bis.read(buffer)) != -1) {
					bos.write(buffer, 0, bytesRead);
				}
				
				fis.close();
				bis.close();
				fos.close();
				bos.flush();
				bos.close();
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response){
		try {
			this.doGet(request, response);
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

	public void init() throws ServletException {
		// Put your code here
	}

}
