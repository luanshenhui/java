package web;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

public class FileUpLoadDemo extends HttpServlet{

	private static final long serialVersionUID = 1L;
	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		DiskFileItemFactory factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);
		try {
			List<FileItem> list = upload.parseRequest(request);
			for(int i = 0; i < list.size(); i++){
				FileItem item = list.get(i);
				if(item.isFormField()){
					String name = item.getString();
					System.out.println(name);
				}else{
					ServletContext sc = getServletContext();
					String filename = item.getName();
					String path = sc.getRealPath("upload");
					File file = new File(filename + File.separator + path);
					item.write(file);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	} 
	
}
