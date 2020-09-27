package hongling.service.assemble;

import hongling.business.AssembleManager;
import hongling.entity.Assemble;

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

import chinsoft.business.CurrentInfo;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class ImportAssemble extends BaseServlet {

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
		String fileName = new SimpleDateFormat("yy-MM-dd-mm-ss")
				.format(new Date()) + ".xls";
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
			ParseImportAssembleUtil parseUtil = new ParseImportAssembleUtil();

			List<Assemble> assembles = parseUtil.parseExcel(filepath);
			String messInfo = "";
			// 验证导入的数据是否完整
			if (assembles.size() == 1 && assembles.get(0).getID() != null
					&& !"".equals(assembles.get(0).getID().toString())
					&& assembles.get(0).getID() == 0) {
				messInfo = assembles.get(0).getTitleCn();
				output(messInfo);
				return;
			}

			// 检察导入的代码是否已存在
			if (!"".equals(parseUtil.validateImportCodes(assembles))) {
				messInfo = "导入失败,原因可能是:代码"
						+ parseUtil.validateImportCodes(assembles) + "已存在";
				output(messInfo);
				return;
			}
			// 检察导入的数据格式合法性
			if (!"".equals(parseUtil.validateImportData(assembles))) {
				messInfo = "导入失败,原因可能是:"
						+ parseUtil.validateImportData(assembles);
				output(messInfo);
				return;
			} else {
				// 验证数据的准确性(code是否存在)
				assembles = parseUtil.saveFormatImport(assembles);
				if (assembles.size() == 1 && assembles.get(0).getID() != null
						&& !"".equals(assembles.get(0).getID().toString())
						&& assembles.get(0).getID() == 0) {
					messInfo = "导入失败 :代码  " + assembles.get(0).getCode()
							+ " 的数据信息不正确";
				} else {
					// 获得当前登陆用户
					Member loginUser = CurrentInfo.getCurrentMember();
					for (Assemble temp : assembles) {
						temp.setCreateBy(loginUser.getName());
						temp.setCreateTime(new Date());
						temp.setStatus(1);
					}
					// System.out.println("可以导入");
					new AssembleManager().saveAssembleList(assembles);
				}
			}
			output(messInfo);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}
