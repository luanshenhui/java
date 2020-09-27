package cn.com.cgbchina.common.utils;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.jxls.area.Area;
import org.jxls.area.CommandData;
import org.jxls.area.XlsArea;
import org.jxls.builder.AreaBuilder;
import org.jxls.builder.xls.XlsCommentAreaBuilder;
import org.jxls.command.EachCommand;
import org.jxls.common.CellRef;
import org.jxls.common.Context;
import org.jxls.reader.ReaderBuilder;
import org.jxls.reader.ReaderConfig;
import org.jxls.reader.XLSReader;
import org.jxls.transform.poi.PoiTransformer;
import org.jxls.util.JxlsHelper;
import org.jxls.util.TransformerFactory;
import org.xml.sax.SAXException;

import lombok.extern.slf4j.Slf4j;

/**
 * @author xiewl
 * @version 2016年5月5日 上午9:36:25 Jxl操作Excel工具类
 */
@Slf4j
public class ExcelUtil {

	private ExcelUtil() {
	}

	/**
	 * 导出Excel
	 * 
	 * @param data 所需导出数据
	 * @param templatePath 模版路径
	 * @param outputPath 导出路径
	 * @throws IOException
	 */
	public static <T> void exportExcel(List<T> data, String templatePath, String outputPath, int maxLimitNum)
			throws IOException {
		InputStream templateInputStream = new FileInputStream(templatePath);// 导出模版
		exportExcel(data, templateInputStream, outputPath, maxLimitNum, null);
	}

	/**
	 * 导出Excel
	 * 
	 * @param data 所需导出数据
	 * @param templatePath 模版路径
	 * @param outputPath 导出路径
	 * @param params 表格额外数据
	 * @throws IOException
	 */
	public static <T> void exportExcel(List<T> data, String templatePath, String outputPath, int maxLimitNum,
			Map<String, String> params) throws IOException {
		InputStream templateInputStream = new FileInputStream(templatePath);// 导出模版
		exportExcel(data, templateInputStream, outputPath, maxLimitNum, params);
	}

	/**
	 * 导出Excel
	 * 
	 * @param data 所需导出数据
	 * @param templateInputStream 导出模版io流
	 * @param outputPath 导出路径
	 * @param maxLimitNum 导出单个sheet最大限制数，超出则以分sheet形式导出
	 * @throws IOException
	 */
	public static <T> void exportExcel(List<T> data, InputStream templateInputStream, String outputPath,
			int maxLimitNum, Map<String, String> params) throws IOException {
		if (data != null && data.size() > 0) {
			if (data.size() < maxLimitNum) {
				exportSingleSheet(data, templateInputStream, outputPath, params);
			} else {
				List<List<T>> groupsData = new ArrayList<List<T>>();
				int groupNum = (int) Math.ceil((double) data.size() / (double) maxLimitNum);
				for (int i = 0; i < groupNum; i++) {
					if (i == groupNum - 1) {
						groupsData.add(data.subList(i * maxLimitNum, data.size()));
					} else {
						groupsData.add(data.subList(i * maxLimitNum, (i + 1) * maxLimitNum));
					}
				}
				long s = System.currentTimeMillis();
				System.out.println("======" + groupsData.size());
				exportSheets(groupsData, templateInputStream, outputPath, params);
				long t = System.currentTimeMillis() - s;
				System.out.println(t);
			}
		} else {
			log.error("没有获取数据");
		}
	}

	/**
	 * 方法说明:输出报表 格式为单个sheet的Excel
	 * 
	 * @param data 输出数据
	 * @param templateInputStream 导出模版io流
	 * @param outputPath 输出路径
	 * @throws FileNotFoundException 找不到模版文件
	 * 
	 */
	private static <T> void exportSingleSheet(List<T> data, InputStream templateInputStream, String outputPath,
			Map<String, String> params) throws FileNotFoundException {
		OutputStream os = new FileOutputStream(outputPath);
		if (templateInputStream != null) {
			Context context = new Context();
			context.putVar("list", data);
			if (params != null) {
				for (String key : params.keySet()) {
					context.putVar(key, params.get(key));
				}
			}
			try {
				JxlsHelper.getInstance().processTemplate(templateInputStream, os, context);
				if (templateInputStream != null) {
					templateInputStream.close();
				}
			} catch (IOException e) {
				log.error("导出Excel文件出错:" + e.getMessage());
				e.printStackTrace();
			}
		}
	}

	/**
	 * 通过配置导出多个sheet的Excel文件
	 * 
	 * @param data
	 * @param templateInputStream 导出模版io流
	 * @param outputPath
	 * @throws IOException
	 */
	private static <T> void exportSheets(List<List<T>> data, InputStream templateInputStream, String outputPath,
			Map<String, String> params) throws IOException {
		OutputStream outputStream = new FileOutputStream(outputPath);
		PoiTransformer transformer = (PoiTransformer) TransformerFactory.createTransformer(templateInputStream,
				outputStream);
		AreaBuilder areaBuilder = new XlsCommentAreaBuilder(transformer);
		List<Area> xlsAreaList = areaBuilder.build();
		// 获取第一个模版区域
		XlsArea xlsArea = (XlsArea) xlsAreaList.get(0);

		// 复制第一个模版区域范围，提供给(分sheet循环命令)
		XlsArea dataArea = new XlsArea(xlsArea.getAreaRef(), transformer);
		List<CommandData> commandDatas = xlsArea.getCommandDataList();

		// 新建(分sheet循环命令)
		EachCommand eachSheetCommand = new EachCommand("list", "data", dataArea);
		eachSheetCommand.setCellRefGenerator(new SimpleCellRefGenerator());// 分sheet生成器

		// 复制出模版中循环导出数据的命令
		CommandData listCommandData = new CommandData(commandDatas.get(0).getAreaRef(),
				commandDatas.get(0).getCommand());

		// 将循环导出数据的命令加入到(分sheet循环命令)
		eachSheetCommand.getAreaList().get(0).getCommandDataList().add(listCommandData);

		// 清除原命令，将新嵌套的命令添加到原有模版区域
		commandDatas.remove(0);
		commandDatas.add(new CommandData(xlsArea.getAreaRef(), eachSheetCommand));

		Context context = new Context();
		context.putVar("data", data);
		if (params != null) {
			for (String key : params.keySet()) {
				context.putVar(key, params.get(key));
			}
		}
		xlsArea.applyAt(new CellRef("Sheet1!A1"), context);
		xlsArea.processFormulas();
		transformer.write();// 导出数据
		if (templateInputStream != null) {
			templateInputStream.close();
		}
	}

	/**
	 * 用户自定义导出模版 直接引用jxls导出工具
	 * 
	 * @param context 自定义导出数据
	 * @param templatePath 模版路径
	 * @param fileOutputPath 输出文件路径
	 * @throws IOException
	 */
	public static void exportExcelByCustom(Context context, String templatePath, String fileOutputPath)
			throws IOException {
		InputStream templateInputStream = new FileInputStream(templatePath);// 导出模版
		FileOutputStream fileOutputStream = new FileOutputStream(fileOutputPath);
		JxlsHelper.getInstance().processTemplate(templateInputStream, fileOutputStream, context);
	}

	/**
	 * 用户自定义导出模版 直接引用jxls导出工具
	 * 
	 * @param context 自定义导出数据
	 * @param templateInputStream 模版的文件流
	 * @param fileOutputPath 输出文件路径
	 * @throws IOException
	 */
	public static void exportExcelByCustom(Context context, InputStream templateInputStream, String fileOutputPath)
			throws IOException {
		FileOutputStream fileOutputStream = new FileOutputStream(fileOutputPath);
		JxlsHelper.getInstance().processTemplate(templateInputStream, fileOutputStream, context);
	}

	/**
	 * 对Excel文件进行数据读取
	 * 
	 * @param dataBeans 返回的数据集合
	 * @param dataFile Excel数据文件
	 * @param inputConfigName 导入数据配置名称
	 * @throws InvalidFormatException
	 * @throws IOException
	 * @throws SAXException
	 */
	public static void importExcelToData(Map<String, Object> dataBeans, File dataFile, String inputConfigName)
			throws InvalidFormatException, IOException, SAXException {
		InputStream dataIO = new FileInputStream(dataFile);
		importExcelToData(dataBeans, dataIO, inputConfigName);
	}

	/**
	 * 对Excel文件进行数据读取
	 * 
	 * @param dataBeans 返回的数据集合
	 * @param dataIO Excel数据文件IO流
	 * @param inputConfigName 导入数据配置路径
	 * @throws InvalidFormatException
	 * @throws IOException
	 * @throws SAXException
	 */
	public static void importExcelToData(Map<String, Object> dataBeans, InputStream dataIO, String xmlconfig)
			throws InvalidFormatException, IOException, SAXException {
		if (xmlconfig != null && !"".equals(xmlconfig)) {
			InputStream xmlConfigIO = new FileInputStream(xmlconfig);
			if (xmlConfigIO != null) {
				importExcelToData(dataBeans, dataIO, xmlConfigIO);
			}
		}
	}

	/**
	 * 对Excel文件进行数据读取
	 * 
	 * @param dataBeans 返回的数据集合
	 * @param dataIO Excel数据文件IO流
	 * @param xmlConfigIO 导入配置所转换的IO流
	 * @throws IOException
	 * @throws SAXException
	 * @throws InvalidFormatException
	 */
	public static void importExcelToData(Map<String, Object> dataBeans, InputStream dataIO, InputStream xmlConfigIO)
			throws IOException, SAXException, InvalidFormatException {
		XLSReader xlsReader = ReaderBuilder.buildFromXML(xmlConfigIO);
		ReaderConfig.getInstance().setSkipErrors(true);// 跳过错误
		ReaderConfig.getInstance().setUseDefaultValuesForPrimitiveTypes(true);// 转换错误则填写默认的信息
		xlsReader.read(dataIO, dataBeans);
	}
}
