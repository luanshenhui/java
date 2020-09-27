package cn.com.cgbchina.common.utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import org.jxls.common.Context;

import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

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
	private final static Pattern DATE_PATTERNT = Pattern.compile("[0-9]{8}");// 检测是否为日期的正则表达式

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
		outputPath = encodingOutputFilePath(outputPath);
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
	 * 校验输出文件路径
	 * 
	 * @param checkPath 待检查的路径
	 * @return
	 */
	private String encodingOutputFilePath(String checkPath) {
		// 校验是否有硬盘路径 如果没有添加硬盘路径
		if (!checkPath.contains("/") || !checkPath.contains("\\")) {
			if (StringUtils.isEmpty(diskPath)) {
				String msg = "ExcelUtilAgency 没有在spring中定义diskPath(硬盘路径)";
				log.error(msg);
				throw new IllegalArgumentException(msg);
			}
			checkPath = diskPath + "\\" + checkPath;
		}
		// 校验是否有文件日期 如果没有添加文件日期 eg: 商品销售日报表.xls 修改为 商品销售日报表_20150425.xls
		if (!DATE_PATTERNT.matcher(checkPath).find()) {
			if (checkPath.contains(HSSF_POSTFIX)) {
				checkPath = checkPath.replace(HSSF_POSTFIX, "_" + BatchDateUtil.fmtDate(new Date()) + HSSF_POSTFIX);
			} else if (checkPath.contains(XSSF_POSTFIX)) {
				checkPath = checkPath.replace(XSSF_POSTFIX, "_" + BatchDateUtil.fmtDate(new Date()) + XSSF_POSTFIX);
			} else {
				checkPath = checkPath + "_" + BatchDateUtil.fmtDate(new Date()) + DEFAULT_POSTFIX;
			}
		}
		if (!checkPath.contains(HSSF_POSTFIX) && !checkPath.contains(XSSF_POSTFIX)) {// 检查文件后缀
			checkPath = checkPath + DEFAULT_POSTFIX;
		}
		return checkPath;
	}
}
