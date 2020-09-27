package cn.com.cgbchina.common.utils;

import com.google.common.base.Throwables;
import lombok.extern.slf4j.Slf4j;
import net.sf.jxls.transformer.XLSTransformer;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Workbook;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.Map;

/**
 * fileName参数为输出给前台下载的时候 下载的文件名 filePath为要下载的模板文件的绝对路径
 * 
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/6/24.
 */
@Slf4j
public class ExportUtils {
	/**
	 * 处理所有检查型异常版本 如果出现检找到查型异常 文件未找到等等 会吸收掉掉异常 页面不报错
	 * 
	 * @param response
	 * @param fileName
	 * @param filePath
	 * @param contextMap
	 */
	public static void exportTemplate(HttpServletResponse response, String fileName, String filePath,
			Map<String, Object> contextMap) {
		InputStream inputStream = null;
		OutputStream outputStream = null;
		try {
			response.reset();
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Disposition",
					"attachment;filename=" + new String(fileName.getBytes("UTF-8"), "iso8859-1") + ";target=_blank");
			inputStream = new FileInputStream(filePath);
			outputStream = response.getOutputStream();
			XLSTransformer transformer = new XLSTransformer();
			Workbook workbook = transformer.transformXLS(inputStream, contextMap);
			workbook.write(outputStream);
			outputStream.flush();
			outputStream.close();
		} catch (UnsupportedEncodingException e) {
			log.error("export excel template", e);
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			log.error("export excel template", e);
			e.printStackTrace();
		} catch (IOException e) {
			log.error("export excel template", e);
			e.printStackTrace();
		} catch (InvalidFormatException e) {
			log.error("export excel template", e);
			e.printStackTrace();
		} finally {
			try {
				if (inputStream != null) {
					inputStream.close();
				}
				if (outputStream != null) {
					outputStream.close();
				}
			} catch (IOException e) {
				log.error("fail to close inputstream , error:{}", Throwables.getStackTraceAsString(e));
			}
		}
	}

	/**
	 * 
	 * @param workbook
	 * @param contextMap
	 */
	public static void exportTemplate(Workbook workbook, Map<String, Object> contextMap) {
		XLSTransformer transformer = new XLSTransformer();
		transformer.transformWorkbook(workbook, contextMap);
	}
}
