package cn.com.cgbchina.batch.util;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Map;

import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

import org.jxls.common.Context;

/**
 * 报表工具代理 工具 导出报表、上传文件、记录数据库
 * 
 * @author xiewl
 * @version 2016年5月20日 上午11:40:37
 */
@Slf4j
public class ExcelUtilAgency {

	@Setter
	@Getter
	private int maxLimitNum; // 导出单个sheet最大限制数，超出则以分sheet形式导出
	@Setter
	@Getter
	private String diskPath;// 导出文件存放的本地硬盘路径

	private final static String HSSF_POSTFIX = ".xls";// 03版Excel后缀
	private final static String XSSF_POSTFIX = ".xlsx";// 07版Excel后缀
	private final static String DEFAULT_POSTFIX = XSSF_POSTFIX; // 默认文件版本
	private final static String ZIP_POSTFIX = ".zip";// 压缩文件后缀

	/**
	 * 导出Excel 代理
	 * 
	 * @param data 导出数据 类型可以为List及其子类 和 org.jxls.common.Context
	 * @param template 模版 可传入String 模版名称 或者 模本InputStream
	 * @param outputPath 导出文件路径
	 * @return 返回已经修正的导出文件路径
	 * @throws IOException
	 */
	public <T, V> String exportExcel(T data, V template, String outputPath) throws IOException {
		return exportExcel(data, template, outputPath, null);
	}

	/**
	 * 导出Excel 代理
	 * 
	 * @param data 导出数据 类型可以为List及其子类 和 org.jxls.common.Context
	 * @param template 模版 可传入String 模版名称 或者 模本InputStream
	 * @param outputPath 导出文件路径
	 * @param params 表格额外数据
	 * @return 返回已经修正的导出文件路径
	 * @throws IOException
	 */
	public <T, V> String exportExcel(T data, V template, String outputPath, Map<String, String> params)
			throws IOException {
		if (List.class.isAssignableFrom(data.getClass())) {// 数据类型为list 或List的子类
			if (String.class.isAssignableFrom(template.getClass())) {// 模版类型为String，即为模版名称
				ExcelUtil.exportExcel((List<?>) data, (String) template, outputPath, maxLimitNum, params);
			} else {// 模版类型为IO流
				ExcelUtil.exportExcel((List<?>) data, (InputStream) template, outputPath, maxLimitNum, params);
			}
		} else {// 数据为Context
			if (String.class.isAssignableFrom(template.getClass())) {
				ExcelUtil.exportExcelByCustom((Context) data, (String) template, outputPath);
			} else {// 模版类型为IO流
				ExcelUtil.exportExcelByCustom((Context) data, (InputStream) template, outputPath);
			}
		}
		return outputPath;
	}

	/**
	 * 校验输出文件路径 eg: 20160624\周报表\商户销售明细周报表_20160624。xls
	 * 
	 * @return
	 */
	public String encodingOutputFilePath(String outpath, String fileName, String batchDate) {
		String checkPath = batchDate + "\\" + outpath + "\\" + fileName + "_" + batchDate;
		checkPath = contentsDiskPath(checkPath);
		checkPath = valudateFileName(checkPath);
		return checkPath;
	}

	/**
	 * 大数据分成多个Excel文件情况下，添加文件名序号
	 * 
	 * @param filePath
	 * @param no
	 * @return
	 */
	public String addExcelNo(String filePath, int pageNo) {
		filePath = valudateFileName(filePath);
		if (filePath.contains(HSSF_POSTFIX)) {
			filePath = filePath.replaceAll(HSSF_POSTFIX, "_" + pageNo + HSSF_POSTFIX);
		} else if (filePath.contentEquals(XSSF_POSTFIX)) {
			filePath = filePath.replaceAll(XSSF_POSTFIX, "_" + pageNo + XSSF_POSTFIX);
		}
		return filePath;
	}

	/**
	 * Description :修改后缀名 将xls/xxls 后缀名改为zip
	 * 
	 * @param filePath
	 * @return
	 */
	public String replacePostfix(String filePath) {
		if (filePath.contains(HSSF_POSTFIX)) {
			filePath = filePath.replaceAll(HSSF_POSTFIX, ZIP_POSTFIX);
		} else if (filePath.contentEquals(XSSF_POSTFIX)) {
			filePath = filePath.replaceAll(XSSF_POSTFIX, ZIP_POSTFIX);
		}
		return filePath;
	}

	/**
	 * 调用压缩工具 并删除源文件
	 * 
	 * @param destPath
	 * @param srcPaths
	 * @return
	 */
	public String zipFiles(String destPath, List<String> srcPaths) {
		destPath = contentsDiskPath(destPath);
		return ZipUtil.zipFilesWithDelSrcFiles(destPath, srcPaths);
	}

	/**
	 * 校验文件名称后缀
	 * 
	 * @param checkPath
	 * @return
	 */
	private String valudateFileName(String checkPath) {
		if (!checkPath.contains(HSSF_POSTFIX) && !checkPath.contains(XSSF_POSTFIX)) {// 检查文件后缀
			checkPath = checkPath + DEFAULT_POSTFIX;
		}
		return checkPath;
	}

	/**
	 * 检查是否有硬盘路径
	 * 
	 * @param checkPath
	 * @return
	 */
	private String contentsDiskPath(String checkPath) {
		// 添加根目录路径
		checkPath = diskPath + checkPath;
		// 校验文件夹路径是否存在,不存在则创建相应路径的文件夹
		String dirPath = checkPath.substring(0, checkPath.lastIndexOf(File.separatorChar));
		File file = new File(dirPath);
		if (!file.exists()) {
			file.mkdirs();
		}
		return checkPath;
	}

}
