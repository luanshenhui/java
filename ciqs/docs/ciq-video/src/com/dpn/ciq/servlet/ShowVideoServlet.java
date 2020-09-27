package com.dpn.ciq.servlet;

import java.awt.geom.AffineTransform;
import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;


public class ShowVideoServlet extends HttpServlet {
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
	        
			String mainPath = "E:\\";
			String fileMonth = request.getParameter("fileMonth");
			String fileDate = request.getParameter("fileDate");
			String fileName = request.getParameter("fileName");
			String filePath = request.getParameter("filePath");
			if(filePath!=null && !"".equals(filePath)){
				fileMonth = filePath.split(",")[0];
				fileDate = filePath.split(",")[1];
				fileName = filePath.split(",")[2];
			}
			
//			InputStream fis = new FileInputStream(mainPath+fileMonth+"\\"+fileDate+"\\"+fileName);
			OutputStream fos = response.getOutputStream();//输出流
			
			String _filePath = mainPath+fileMonth+"\\"+fileDate+"\\"+fileName;
		    File fin = new File(_filePath); //待转换的大图文件
		    int nw = 500;
		    
		    AffineTransform transform = new AffineTransform();
		    BufferedImage bis = ImageIO.read(fin); //读取图片
		    int w = bis.getWidth();
		    int h = bis.getHeight();
		    //double scale = (double)w/h;
		    int nh = (nw*h)/w ;
		    double sx = (double)nw/w;
		    double sy = (double)nh/h;
		    transform.setToScale(sx,sy); //setToScale(double sx, double sy) 将此变换设置为缩放变换。
//		    System.out.println(w + " " +h);
		    
		    AffineTransformOp ato = new AffineTransformOp(transform,null);
		    BufferedImage bid = new BufferedImage(nw,nh,BufferedImage.TYPE_3BYTE_BGR);
			   /*
			    * TYPE_3BYTE_BGR 表示一个具有 8 位 RGB 颜色分量的图像，
			    * 对应于 Windows 风格的 BGR 颜色模型，具有用 3 字节存
			    * 储的 Blue、Green 和 Red 三种颜色。
			   */
		     ato.filter(bis,bid);
		     
		     ImageIO.write(bid, "jpg", fos);
		    
			 fos.flush();
			 fos.close();		    
			
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
