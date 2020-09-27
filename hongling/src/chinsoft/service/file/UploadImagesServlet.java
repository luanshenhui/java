package chinsoft.service.file;

import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.Serializable;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateFormatUtils;

import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGImageEncoder;

//  xhEditor文件上传的Java - Servlet实现.

//  @ author WeiMiao

//  @ refer to easinchu

//  @ version 2

//  @ description 增加html5上传功能的支持

@SuppressWarnings("deprecation")
public class UploadImagesServlet extends HttpServlet {

	private static final long serialVersionUID = 1541334866883495283L;

	//private static String baseDir = "/UploadFile/"; // 上传文件存储目录

	private static String fileExt = "jpg,jpeg,bmp,gif,png";

	private static Long maxSize = 0l;


	@Override
	public void init() throws ServletException {


		fileExt = this.getInitParameter("fileExt"); // 获取文件类型参数

		if (StringUtils.isEmpty(fileExt))
			fileExt = "jpg,jpeg,gif,bmp,png";

		String maxSize_str = this.getInitParameter("maxSize"); // 获取文件大小参数

		if (StringUtils.isNotEmpty(maxSize_str)) {

			maxSize = new Long(maxSize_str);

		} else {

			maxSize = Long.valueOf("5242880"); // 5M

		}


	}

	// 上传文件数据处理过程

	@SuppressWarnings("unchecked")
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html; charset=UTF-8");

		response.setHeader("Cache-Control", "no-cache");

		String err = "";

		String newFileName = "";

		if ("application/octet-stream".equals(request.getContentType())) { // HTML5上传
			try {
				String dispoString = request.getHeader("Content-Disposition");

				int iFindStart = dispoString.indexOf("name=\"") + 6;

				int iFindEnd = dispoString.indexOf("\"", iFindStart);

				iFindStart = dispoString.indexOf("filename=\"") + 10;

				iFindEnd = dispoString.indexOf("\"", iFindStart);

				String sFileName = dispoString.substring(iFindStart, iFindEnd);

				int i = request.getContentLength();

				byte buffer[] = new byte[i];

				int j = 0;

				while (j < i) { // 获取表单的上传文件

					int k = request.getInputStream().read(buffer, j, i - j);

					j += k;

				}

				if (buffer.length == 0) { // 文件是否为空

					printInfo(response, "上传文件不能为空", "");

					return;

				}

				if (maxSize > 0 && buffer.length > maxSize) { // 检查文件大小

					printInfo(response, "上传文件的大小超出限制", "");

					return;

				}

				String filepathString = getSavePath(sFileName, response);

				if ("不允许上传此类型的文件".equals(filepathString))
					return; // 检查文件类型

				OutputStream out = new BufferedOutputStream(
						new FileOutputStream(this.getServletConfig()
								.getServletContext().getRealPath("")
								+ filepathString, true));

				out.write(buffer);

				out.close();

				//newFileName = request.getContextPath() + filepathString;
				/*//项目名称
				String projPath = this.getServletConfig()
				.getServletContext().getRealPath("");
				String projName = projPath.substring(projPath.lastIndexOf("\\"));
				newFileName = projName + filepathString;
				newFileName = newFileName.replaceAll("\\\\", "/");*/
				String _filePath = this.getServletConfig().getServletContext().getRealPath("")+filepathString;
				_filePath = zipImageFile(_filePath,600,0,"-zp");
				_filePath = _filePath.substring(_filePath.indexOf("upload")-1);
				//项目名称
				String projPath = this.getServletConfig()
				.getServletContext().getRealPath("");
				String projName = projPath.substring(projPath.lastIndexOf("\\"));
				newFileName = projName + _filePath;				
				newFileName = newFileName.replaceAll("\\\\", "/");

			} catch (Exception ex) {

				System.out.println(ex.getMessage());

				newFileName = "";

				err = "错误: " + ex.getMessage();

			}

		} else {

			DiskFileUpload upload = new DiskFileUpload();
			upload.setHeaderEncoding("utf8");

			try {

				List<FileItem> items = upload.parseRequest(request);

				Map<String, Serializable> fields = new HashMap<String, Serializable>();

				Iterator<FileItem> iter = items.iterator();

				while (iter.hasNext()) {

					FileItem item = iter.next();

					if (item.isFormField())

						fields.put(item.getFieldName(), item.getString());

					else

						fields.put(item.getFieldName(), item);

				}

				FileItem uploadFile = (FileItem) fields.get("filedata"); // 获取表单的上传文件

				String fileNameLong = uploadFile.getName(); // 获取文件上传路径名称

				if (uploadFile.getSize() == 0) { // 文件是否为空

					printInfo(response, "上传文件不能为空", "");

					return;

				}

				if (maxSize > 0 && uploadFile.getSize() > maxSize) { // 检查文件大小

					printInfo(response, "上传文件的大小超出限制", "");

					return;

				}

				String filepathString = getSavePath(fileNameLong, response);

				if ("不允许上传此类型的文件".equals(filepathString))
					return; // 检查文件类型

				File savefile = new File(this.getServletConfig()
						.getServletContext().getRealPath("")
						+ filepathString);
				uploadFile.write(savefile); // 存储上传文件
				
				String _filePath = savefile.getPath();
				_filePath = zipImageFile(_filePath,600,0,"-zp");
				_filePath = _filePath.substring(_filePath.indexOf("upload")-1);
				//项目名称
				String projPath = this.getServletConfig()
				.getServletContext().getRealPath("");
				String projName = projPath.substring(projPath.lastIndexOf("\\"));
				newFileName = projName + _filePath;				
				newFileName = newFileName.replaceAll("\\\\", "/");
			} catch (Exception ex) {

				System.out.println(ex.getMessage());

				newFileName = "";

				err = "错误: " + ex.getMessage();

			}

		}
		response.setCharacterEncoding("utf-8");
		// 前面加!表示上传完成直接显示图片
		printInfo(response, err, "!" + newFileName);

	}

	public String getSavePath(String sFileName, HttpServletResponse response)throws IOException {
		String extensionName = sFileName
				.substring(sFileName.lastIndexOf(".") + 1); // 获取文件扩展名

		if (("," + fileExt.toLowerCase() + ",").indexOf(","
				+ extensionName.toLowerCase() + ",") < 0) { // 检查文件类型

			printInfo(response, "不允许上传此类型的文件", "");

			return "不允许上传此类型的文件";

		}
		//文件保存位置，当前项目下的upload/attachment
		String uploadDir = File.separatorChar +"upload" + File.separatorChar + "images" + File.separatorChar;
		//每天上传的文件根据日期存放在不同的文件夹
		String autoCreatedDateDirByParttern = "yyyy" + File.separatorChar + "MM" + File.separatorChar + "dd"
				+ File.separatorChar;
		String autoCreatedDateDir = DateFormatUtils.format(new java.util.Date(), autoCreatedDateDirByParttern);
		String saveDirPath = uploadDir + autoCreatedDateDir; // 文件存储的相对路径
		String saveFilePath = this.getServletConfig().getServletContext()
		.getContextPath()
		+ saveDirPath; // 文件存储在容器中的绝对路径
		File fileDir = new File(saveFilePath); // 构建文件目录以及目录文件

		if (!fileDir.exists()) {

			fileDir.mkdirs();

		}

		String filename = UUID.randomUUID().toString(); // 重命名文件

		return saveDirPath + filename + "." + extensionName;
	}

	// 使用I/O流输出 json格式的数据

	public void printInfo(HttpServletResponse response, String err,
			String newFileName) throws IOException {

		response.setContentType("text/plain");

		response.setCharacterEncoding("UTF-8");

		PrintWriter out = response.getWriter();

		out
				.println("{\"err\":\"" + err + "\",\"msg\":\"" + newFileName
						+ "\"}");

		out.flush();

		out.close();

	}

	/*
	 * *
	 * 压缩图片文件
	 * 
	 * @param oldFile 要进行压缩的文件全路径
	 * 
	 * @param width 宽度
	 * 
	 * @param height 高度
	 * 
	 * @param smallIcon 压缩后图片的后缀
	 * 
	 * @return 返回压缩后的文件的全路径
	 */
	public static String zipImageFile(String oldFile, int width, int height,String smallIcon) {
		if (oldFile == null||(width==0&&height==0)) {
			return null;
		}
		String newImage = null;
		try {
			
			Image srcFile = ImageIO.read(new File(oldFile));
			int w = srcFile.getWidth(null);
			int h = srcFile.getHeight(null);
			if(width>=w||height>=h){
				return oldFile;
			}
			if(width!=0&&height==0){
				height = (int)Math.round((h * width * 1.0 / w));
			}
			if(width==0&&height!=0){
				width = (int)Math.round((w * height * 1.0 / h));
			}
			if(width!=0&&height!=0){
				//得到合适的压缩大小，按比例。
				if ( w >= h)
				{
			
					height = (int)Math.round((h * width * 1.0 / w));
				}
				else 
				{
					
					width = (int)Math.round((w * height * 1.0 / h));
				}
			}
			/** 宽,高设定 */
			BufferedImage tag = new BufferedImage(width, height,
					BufferedImage.TYPE_INT_RGB);
			tag.getGraphics().drawImage(srcFile, 0, 0, width, height, null);
			String filePrex = oldFile.substring(0, oldFile.lastIndexOf('.'));
			/** 压缩后的文件名 */
			newImage = filePrex + smallIcon
					+ oldFile.substring(filePrex.length());

			FileOutputStream out = new FileOutputStream(newImage);

			JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(out);
			//JPEGEncodeParam jep = JPEGCodec.getDefaultJPEGEncodeParam(tag);
			/** 压缩质量 */
			//jep.setQuality(1f, true);
			encoder.encode(tag);
			out.close();

		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		if(new File(newImage).exists()){
			//删除原文件
			boolean flg = new File(oldFile).delete();
			if(flg){
				return newImage;
			}else{
				//删除压缩后的文件保留原文件
				if(new File(oldFile).exists()){
					new File(newImage).delete();
					return oldFile;
				}
			}
		}else{
			return oldFile;
		}
		return "";
	}
}
