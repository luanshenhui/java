package hongling.service.assemble;

import hongling.business.StyleProcessManager;
import hongling.entity.StyleProcess;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.util.Streams;
import chinsoft.service.core.BaseServlet;

public class ImportStyleProcess extends BaseServlet {

	private static final long serialVersionUID = 1L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		String path = this.getServletConfig().getServletContext()
				.getRealPath("/")
				+ "pages\\style_assemble\\upload";
		// System.out.println(path);
		File saveDir = new File(path);
		if (!saveDir.isDirectory()) { // 判断文件夹是否已存在
			System.out.println("文件不存在");
			saveDir.mkdir(); // 新建文件夹
		}
		// 设置导出文件名
		 String fileName = new SimpleDateFormat("yy-MM-dd-mm-ss").format(new Date()) + ".xls";
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
						BufferedInputStream in = new BufferedInputStream(
								fis.openStream());// 获得文件输入流
						filepath = saveDir + "\\" + fileName;
						BufferedOutputStream out = new BufferedOutputStream(
								new FileOutputStream(new File(filepath)));// 获得文件输出流
						Streams.copy(in, out, true);// 开始把文件写到你指定的上传文件夹
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

		try {
			ParseImportStyleUtil parseUtil = new ParseImportStyleUtil();
			List<StyleProcess> styleprocess = parseUtil.parseExcel(filepath);
			String messInfo = "";
			// 检察导入的数据合法性
			if (null != parseUtil.validateImportData(styleprocess) && !"".equals(parseUtil.validateImportData(styleprocess))) {
				messInfo = "导入失败,原因可能是:  \n"
						+ parseUtil.validateImportData(styleprocess);

			} else {
				// 无重复code 校验通过 可以导入
				styleprocess = parseUtil.saveFormatImport(styleprocess);
				if (styleprocess.size() == 1 && styleprocess.get(0).getID() != null
						&& !"".equals(styleprocess.get(0).getID().toString())
						&& styleprocess.get(0).getID() == 0) {
					messInfo = "导入失败 :代码  " + styleprocess.get(0).getStyleCode()
							+ " 的数据信息不正确";
				} else {
					new StyleProcessManager().saveStyleProcessList(styleprocess);
				}
			}
			output(messInfo);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}
