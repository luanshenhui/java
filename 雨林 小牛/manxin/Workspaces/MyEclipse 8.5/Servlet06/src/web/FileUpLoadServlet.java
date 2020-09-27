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
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

public class FileUpLoadServlet extends HttpServlet{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		//step1:创建DiskFileItemFactory对象,该对象为解析器提供解析时的缺省模式的配置
		DiskFileItemFactory factory = new DiskFileItemFactory();
		//step2:创建解析器
		ServletFileUpload sfu = new ServletFileUpload(factory);
		//step3:使用解析器解析(InputStream),解析器会将一个表单域(比如,一个文件输入框)
		//中的数据封装到一个FileItem对象上。
		//FileItem对象上提供了相应的方法来获取表单域中的数据
		try{
			List<FileItem> items = sfu.parseRequest(request);
			for(int i = 0; i < items.size();i++){
				FileItem item = items.get(i);
				if(item.isFormField()){
					//是一个普通的表单域
					String username = item.getString();
					System.out.println("username:" + username);
				}else{
					//是一个上传文件域，该文件保存到某个文件夹下面
					ServletContext sctx = getServletContext();
					//依据逻辑路径“upload”获得实际部署时的物理路径
					String path = sctx.getRealPath("upload");
					System.out.println("path:" + path);
					//读取文件名
					String filename = item.getName();
					System.out.println("filename:" + filename);
					File file = new File(path + File.separator + filename);
					item.write(file);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}




























