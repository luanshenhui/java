package hongling.service.fabricwareroom;

import hongling.business.AssembleManager;
import hongling.business.FabricWareroomManager;
import hongling.entity.Assemble;
import hongling.entity.FabricWareroom;
import hongling.service.assemble.ParseImportAssembleUtil;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.util.Streams;
import org.apache.commons.io.FilenameUtils;

import chinsoft.business.CurrentInfo;
import chinsoft.core.Utility;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class ImportFabricwareroom extends BaseServlet {
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("进来了------------------");
		String path = this.getServletConfig().getServletContext().getRealPath("/")+ "pages\\fabricwareroom\\upload";
		File saveDir = new File(path);
		if (!saveDir.isDirectory()) { // 判断文件夹是否已存在
			System.out.println("文件不存在");
			saveDir.mkdir(); // 新建文件夹
		}
		String filepath = "";
		try {
			if (ServletFileUpload.isMultipartContent(request)) {
				DiskFileItemFactory dff = new DiskFileItemFactory();// 创建该对象
				dff.setRepository(saveDir);// 指定上传文件的临时目录
				dff.setSizeThreshold(1024000);// 指定在内存中缓存数据大小,单位为byte
				ServletFileUpload sfu = new ServletFileUpload(dff);// 创建该对象
				sfu.setFileSizeMax(5000000);// 指定单个上传文件的最大尺寸
				sfu.setSizeMax(10000000);// 指定一次上传多个文件的总尺寸
				sfu.setHeaderEncoding("utf-8");// 指定 为utf-8编码
				FileItemIterator fii = sfu.getItemIterator(request);// 解析request
																	// 请求,并返回FileItemIterator集合
				while (fii.hasNext()) {
					FileItemStream fis = fii.next();// 从集合中获得一个文件流
					if (!fis.isFormField() && fis.getName().length() > 0) {// 过滤掉表单中非文件域
						//String upname = fis.getName();// 获得上传文件的文件名
						String upname=UUID.randomUUID().toString().replace("-","").concat(".").concat(FilenameUtils.getExtension(fis.getName()));
						BufferedInputStream in = new BufferedInputStream(fis.openStream());// 获得文件输入流
						filepath = saveDir + "\\" + upname;
						BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(new File(filepath)));// 获得文件输出流
						Streams.copy(in, out, true);// 开始把文件写到你指定的上传文件夹
						List<FabricWareroom> fabrics=new FabricWareroomManager().initExcel(filepath);
						for (FabricWareroom fabricWareroom : fabrics) {
							new FabricWareroomManager().saveFabricWareroom(fabricWareroom);
						}
					}
				}
			}
		} catch (FileUploadException e) {
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}