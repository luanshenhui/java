package com.dpn.ciqqlc.common.component;

import java.io.File;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.dpn.ciqqlc.common.util.Constants;

@SuppressWarnings("serial")
public class Videoservlet extends HttpServlet{
	protected static Log logger = LogFactory.getLog(Videoservlet.class);
	/**
	 * Constructor of the object.
	 */
	public Videoservlet() {
		super();
	}


	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
			this.doPost(request, response);
	}


	@SuppressWarnings("rawtypes")
	public void doPost(HttpServletRequest request, HttpServletResponse response){
		
		try {
				File uploadFile = null;
				
				DateFormat df1 = new SimpleDateFormat("yyyyMM");
				DateFormat df2 = new SimpleDateFormat("yyyyMMdd");
				
				Date date = new Date(System.currentTimeMillis());
				//String tempContents = "E:\\tmp\\";//临时目录
				String tempContents = Constants.UP_LOAD_P+Constants.UP_LOAD_TMP;
				
				//String fileSaveMonth = "E:\\"+df1.format(date);//附件保存月目录
				String fileSaveMonth = Constants.UP_LOAD_P+df1.format(date);//附件保存月目录
				if(!(new File(fileSaveMonth).isDirectory())){
					new File(fileSaveMonth).mkdir();
				}
				
				//String fileSaveContents = "E:\\"+df1.format(date)+"\\"+df2.format(date);//附件保存日目录
				String fileSaveContents = Constants.UP_LOAD_P+df1.format(date)+"\\"+df2.format(date);//附件保存日目录
				if(!(new File(fileSaveContents).isDirectory())){
					new File(fileSaveContents).mkdir();
				}
				
				DiskFileItemFactory diskFactory = new DiskFileItemFactory();
				diskFactory.setSizeThreshold(4096);
				diskFactory.setRepository(new File(tempContents));

				ServletFileUpload upload = new ServletFileUpload(diskFactory);

				
				List fileItems = upload.parseRequest(request);
				Iterator iter = fileItems.iterator();

				while (iter.hasNext()) {
					FileItem item = (FileItem) iter.next();
					if (!item.isFormField()) {
						String filename = item.getName();
//						filename = filename.substring(filename.lastIndexOf("/"),filename.length());
						uploadFile = new File(fileSaveContents +"/"+filename);
						item.write(uploadFile);
					}
				}
		
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		
		
	}

	public void init() throws ServletException {
		// Put your code here
	}

}
