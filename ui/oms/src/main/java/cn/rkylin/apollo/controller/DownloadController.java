package cn.rkylin.apollo.controller;

import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import cn.rkylin.apollo.common.util.DateUtils;
import cn.rkylin.apollo.common.util.ExportSalesDownloadUtil;
import cn.rkylin.apollo.common.util.ListUtils;
import cn.rkylin.core.controller.AbstractController;

/**
 * Copyright (C), 2016-2020, cn.rkylin.apollo FileName: DownloadController.java
 * 
 * @Description: 金蝶数据模板上传下载
 * @author zhangXinyuan
 * @Date 2016-8-28 上午 11:49
 * @version 1.00
 */
@Controller
@RequestMapping("/download")
public class DownloadController extends AbstractController {
	private Log log = LogFactory.getLog(DownloadController.class);
	private static final String TO_SALES_ORDER_DOWNLOAD = "/views/download/salesOrderDownload";
	private static final String TO_Purchase_ORDER_DOWNLOAD = "/views/download/purchaseOrderDownload";
	private static final String TO_SALES_OUTSTORAGE_DOWNLOAD = "/views/download/salesOutStorageDownload";
	private static final SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
	@Resource(name = "redisTemplate")
	private RedisTemplate<String, String> redisTemplate;

	/**
	 * 进入销售订单模板下载页
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/toSalesOrder")
	public ModelAndView toSalesOrder(HttpServletRequest request) {
		return new ModelAndView(TO_SALES_ORDER_DOWNLOAD);
	}

	/**
	 * 进入采购订单模板下载页
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/toPurchaseOrder")
	public ModelAndView toPurchaseOrder(HttpServletRequest request) {
		return new ModelAndView(TO_Purchase_ORDER_DOWNLOAD);
	}

	/**
	 * 进入销售出库模板下载页
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/tosalesOutStorage")
	public ModelAndView tosalesOutStorage(HttpServletRequest request) {
		return new ModelAndView(TO_SALES_OUTSTORAGE_DOWNLOAD);
	}

	/**
	 * 销售订单下载解析再上传,支持多个sheet(此方法暂时未用到)
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping("/salesOrderDownload")
	public void salesOrderDownload(HttpServletRequest request, HttpServletResponse response,
			@RequestParam("uploadOrderExcel") MultipartFile uploadOrderExcel) {
		Workbook wb = null;
		HSSFWorkbook workbook = new HSSFWorkbook();
		try {
			if (StringUtils.isNotEmpty(uploadOrderExcel.getOriginalFilename())) {
				String fileName = uploadOrderExcel.getOriginalFilename();
				String fileSuffix = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length());
				if ("xlsx".equals(fileSuffix)) {
					wb = new XSSFWorkbook(uploadOrderExcel.getInputStream());
				} else if ("xls".equals(fileSuffix)) {
					wb = new HSSFWorkbook(uploadOrderExcel.getInputStream());
				}
				int sheetSize = wb.getNumberOfSheets();
				log.info("总sheet页数为：" + sheetSize);
				List<List<Map<String, Object>>> sheetList = new ArrayList<List<Map<String, Object>>>();
				//Map<String, Object> sheetNameMap = new HashMap<String, Object>();
				for (int i = 0; i < sheetSize; i++) { // sheet （本次需求默认1个shett）
					int shettNum = i;
					Sheet sheet = wb.getSheetAt(i);
					int numberRows = sheet.getPhysicalNumberOfRows();
					int numberCells = 0;
					log.info("总行数为：" + numberRows);
					// 列头
					List<String> columnsList = new ArrayList<String>();
					List<List<String>> columnsNameList = new ArrayList<List<String>>();
					for (int j = 0; j < numberRows - numberRows + 1; j++) { // rows
						Row rows = sheet.getRow(j);
						numberCells = rows.getPhysicalNumberOfCells();
						log.info("总列数为：" + numberCells);
						for (int z = 0; z < numberCells; z++) { // cells
							Cell cell = rows.getCell(z);
							String salesOrderColumns = cell.getStringCellValue();
							// 为生成Excel数据组装的数据格式
							columnsList.add(salesOrderColumns);
							// 为生成二维数组组装的数据格式
							List<String> columnTitleList = new ArrayList<String>();
							columnTitleList.add(salesOrderColumns);
							columnTitleList.add(salesOrderColumns);
							columnTitleList.add("string");
							columnTitleList.add("n");
							columnsNameList.add(columnTitleList);
							log.info("列值为：" + salesOrderColumns);
						}
					}
					// 二维数组负责Excel表头
					String[][] reportTitles = new String[columnsNameList.size()][];
					for (int c = 0; c < columnsNameList.size(); c++) {
						List<String> columnList = columnsNameList.get(c);
						reportTitles[c] = columnList.toArray(new String[0]);
					}

					// 从第二行开始记录key - value (列名 - 值) Excel需要的数据
					List<Map<String, Object>> salesOrderDataList = new ArrayList<Map<String, Object>>();
					for (int j = 1; j < numberRows; j++) { // rows
						Row rows = sheet.getRow(j);
						if (null != rows) {
							Map<String, Object> columnsMap = new LinkedHashMap<String, Object>();
							// 总列数以第一列为准：numberCells
							for (int z = 0; z < numberCells; z++) { // cells
								Cell cell = rows.getCell(z);
								// 对数据做特殊处理，根据key名称 和描述的规则进行value数据转换或者获取
								columnsMap.put(columnsList.get(z), cellTypeFormat(cell));
								log.info("列值为：" + cellTypeFormat(cell));
							}
							salesOrderDataList.add(columnsMap);
						}
					}
					// 期望生成多个sheet Excel 调用生成Excel 工具类
					// 创建工作簿实例
					new ExportSalesDownloadUtil().SalesExportExcel(workbook, shettNum, salesOrderDataList, reportTitles,
							sheet.getSheetName());
				}
				ByteArrayOutputStream output = new ByteArrayOutputStream();
				workbook.write(output);
				byte[] bytes = output.toByteArray();
				response.setContentLength(bytes.length);
				byte[] fileNameByte = ("上传模板.xls").getBytes("GBK");
				String fileNames = new String(fileNameByte, "ISO8859-1");
				response.setHeader("Content-Disposition", "attachment;filename=" + fileNames);
				response.getOutputStream().write(bytes);
				log.info(sheetList);
			}
		} catch (Exception e) {
			log.error("解析Excel异常。", e);
		}
	}

	/**
	 * 销售订单数据源模板解析
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping("/salesOrderdataSourcePars")
	public void salesOrderdataSourcePars(HttpServletRequest request, HttpServletResponse response,
			@RequestParam("salesUploadOrderExcel") MultipartFile[] salesUploadOrderExcel) {
		Workbook wb = null;
		try {
			if (null != salesUploadOrderExcel && salesUploadOrderExcel.length > 0) {
				Map<String, Object> mapCell = new LinkedHashMap<String, Object>();
				for (int i = 0; i < salesUploadOrderExcel.length; i++) { // 上传多个文件
					MultipartFile salesOrderFile = salesUploadOrderExcel[i];
					if (StringUtils.isNotEmpty(salesOrderFile.getOriginalFilename())) {
						String fileName = salesOrderFile.getOriginalFilename();
						int strIndex = fileName.lastIndexOf(".");
						String strFileName = fileName.substring(0, strIndex);
						String fileSuffix = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length());
						if ("xlsx".equalsIgnoreCase(fileSuffix)) {
							wb = new XSSFWorkbook(salesOrderFile.getInputStream());
						} else if ("xls".equalsIgnoreCase(fileSuffix)) {
							wb = new HSSFWorkbook(salesOrderFile.getInputStream());
						}
						if (i < 3 && !strFileName.contains("销售")) { // 此目的是前三个都是数据源，后一个是模板
							for (int n = 0; n < 1; n++) { // (本次需求默认1个shett)
								Sheet sheet = wb.getSheetAt(n);
								int numberRows = sheet.getPhysicalNumberOfRows(); // 获取所有的行
								log.info("总行数为：" + numberRows);
								for (int j = 1; j < numberRows; j++) { // 获取行
									Row rows = sheet.getRow(j);
									Cell cell = null;
									if (null != rows) {
										// 获取想要的列放到容器中（这里的容器是一个MAP,Excel列从0开始）
										String zeroColumn = null;
										if (strFileName.contains("客户") || strFileName.contains("部门")
												|| strFileName.contains("物料")) {
											cell = rows.getCell(0); // 获取客户，部门，物料第一列值
											zeroColumn = cellTypeFormat(cell);
										}
										if (strFileName.contains("客户")) {
											cell = rows.getCell(2); // 获取第三列值
											String twoColumn = cellTypeFormat(cell);
											mapCell.put(twoColumn, zeroColumn); // 客户数据源中的第三列和第一列是key-value关系
										}
										if (strFileName.contains("部门")) {
											cell = rows.getCell(1); // 获取第二列值
											String noeColumn = cellTypeFormat(cell);
											mapCell.put(noeColumn, zeroColumn); // 部门数据源中的第二列和第一列是key-value关系
										}
										if (strFileName.contains("物料")) {
											cell = rows.getCell(5); // 获取第六列值
											String sixColumn = cellTypeFormat(cell);
											cell = rows.getCell(16); // 获取第十四列值
											String thirteenColumn = cellTypeFormat(cell);
											cell = rows.getCell(102); // 获取第一百零二列值,不需要小数位
											String oneAndTwoColumn = cellTypeFormat(cell);
											if (null != oneAndTwoColumn) {
												BigDecimal rate = new BigDecimal(oneAndTwoColumn).setScale(0,BigDecimal.ROUND_UP);
												oneAndTwoColumn = String.valueOf(rate);
											}
											String ztColumn = zeroColumn + "," + thirteenColumn + "," + oneAndTwoColumn;
											mapCell.put(sixColumn, ztColumn); // 物料数据源中的第六列和第一列,十三列是key-value,value关系
										}
									}
								}
							}
						}
						// 格式化要导出的模板数据
						if (i == 3 && strFileName.contains("销售")) {
							salesOrderDownTemplate(response, wb, mapCell);
						}
					}
				}
			}

		} catch (Exception e) {
			log.error("解析Excel异常。", e);
		}
	}

	/**
	 * 销售订单模板下载
	 */
	private void salesOrderDownTemplate(HttpServletResponse response, Workbook wb, Map<String, Object> dataSourceMap) {
		HSSFWorkbook workbook = new HSSFWorkbook();
		try {
			int sheetSize = wb.getNumberOfSheets();
			log.info("总sheet页数为：" + sheetSize);
			for (int i = 0; i < 1; i++) { // sheet （本次需求默认1个shett）
				int shettNum = i;
				Sheet sheet = wb.getSheetAt(i);
				int numberRows = sheet.getPhysicalNumberOfRows();
				int numberCells = 0;
				log.info("总行数为：" + numberRows);
				// 列头
				List<String> columnsList = new ArrayList<String>();
				List<List<String>> columnsNameList = new ArrayList<List<String>>();
				for (int j = 0; j < numberRows - numberRows + 1; j++) { // rows
					Row rows = sheet.getRow(j);
					numberCells = rows.getPhysicalNumberOfCells();
					log.info("总列数为：" + numberCells);
					for (int z = 0; z < numberCells; z++) { // cells
						Cell cell = rows.getCell(z);
						String salesOrderColumns = cell.getStringCellValue();
						// 为生成Excel数据组装的数据格式
						columnsList.add(salesOrderColumns);
						// 为生成二维数组组装的数据格式
						List<String> columnTitleList = new ArrayList<String>();
						columnTitleList.add(salesOrderColumns);
						columnTitleList.add(salesOrderColumns);
						columnTitleList.add("string");
						columnTitleList.add("n");
						columnsNameList.add(columnTitleList);
						log.info("列值为：" + salesOrderColumns);
					}
				}
				// 二维数组负责Excel表头
				String[][] reportTitles = new String[columnsNameList.size()][];
				for (int c = 0; c < columnsNameList.size(); c++) {
					List<String> columnList = columnsNameList.get(c);
					reportTitles[c] = columnList.toArray(new String[0]);
				}

				// 从第二行开始记录key - value (列名 - 值) Excel需要的数据
				List<Map<String, Object>> salesOrderDataList = new ArrayList<Map<String, Object>>();
				for (int j = 1; j < numberRows; j++) { // 行
					Row rows = sheet.getRow(j);
					if (null != rows) {
						Map<String, Object> columnsMap = new LinkedHashMap<String, Object>();
						// 总列数以第一行的列为准：numberCells
						for (int z = 0; z < numberCells; z++) { // 列
							Cell cell = rows.getCell(z);
							// 对数据做特殊处理，根据key名称 和描述的规则进行value数据转换或者获取
							String cellFormatValue = null;
							if ("业务员_代码".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "999";
								}
							} else if ("业务员".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "无";
								}
							} else if ("汇率类型".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "公司汇率";
								}
							} else if ("销售范围".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "赊购";
								}
							} else if ("计划类别".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "标准";
								}
							} else if ("建议交货日期".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = DateUtils.getCurrentDateStr();
								}
							} else if ("计划模式".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "MTS计划模式";
								}
							} else if ("交货日期".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = DateUtils.getCurrentDateStr();
								}
							} else if ("含税单价".equals(columnsList.get(z))) {
								cellFormatValue = cellTypeFormat(cell);
								if (StringUtils.isNotEmpty(cellFormatValue)) {
									cellFormatValue = String.valueOf(
											new BigDecimal(cellFormatValue).setScale(2, BigDecimal.ROUND_HALF_UP));
								}
							} else if ("折扣率(%)".equals(columnsList.get(z))) {
								cellFormatValue = cellTypeFormat(cell);
								if (StringUtils.isNotEmpty(cellFormatValue)) {
									cellFormatValue = String.valueOf(
											new BigDecimal(cellFormatValue).setScale(2, BigDecimal.ROUND_HALF_UP));
								}
							} else {
								cellFormatValue = cellTypeFormat(cell);
							}
							columnsMap.put(columnsList.get(z), cellFormatValue);
						}
						salesOrderDataList.add(columnsMap);
					}
				}
				/* 特殊列名处理从数据源容器Map中获取 */
				// 根据业务填写的购货单位获取单位_代码
				for (Map<String, Object> map : salesOrderDataList) {
					if (null != map.get("购货单位")) {
						if (null != dataSourceMap.get(map.get("购货单位"))) {
							String purchaseCode = String.valueOf(dataSourceMap.get(map.get("购货单位")));
							map.put("购货单位_代码", purchaseCode);
						}
					}
					// 根据业务填写的部门获取代码
					if (null != map.get("部门")) {
						if (null != dataSourceMap.get(map.get("部门"))) {
							String deptCode = String.valueOf(dataSourceMap.get(map.get("部门")));
							map.put("部门_代码", deptCode);
						}

					}
					// 根据业务输入的助记码获取 代码，单位，税率
					if (null != map.get("产品代码")) {
						if (null != dataSourceMap.get(map.get("产品代码"))) {
							String productCode = String.valueOf(dataSourceMap.get(map.get("产品代码")));
							if (StringUtils.isNotEmpty(productCode)) {
								String[] pCode = productCode.split(",");
								map.put("产品代码", pCode[0]);
								map.put("单位", pCode[1]);
								map.put("税率(%)", new BigDecimal(pCode[2]).setScale(0, BigDecimal.ROUND_UP));
							}

						}
					}
					// 价税合计 = 含税单价*数量
					if (null == map.get("价税合计") || "".equals(map.get("价税合计"))) {
						BigDecimal unitPrice = BigDecimal.ZERO;
						BigDecimal number = null;
						if (null != map.get("含税单价")) {
							unitPrice = new BigDecimal(String.valueOf(map.get("含税单价")));
						}
						if (null != map.get("数量")) {
							number = new BigDecimal(String.valueOf(map.get("数量")));
						}
						map.put("价税合计", (unitPrice.multiply(number).setScale(2, BigDecimal.ROUND_HALF_UP)));
					}
					// 实际含税单价 = 含税单价
					if (null == map.get("实际含税单价") || "".equals(map.get("实际含税单价"))) {
						if (null != map.get("含税单价")) {
							BigDecimal unitPrice = new BigDecimal(String.valueOf(map.get("含税单价")));
							map.put("实际含税单价", unitPrice);
						}
					}
					// 金额 =价税合计/（1+【税率/100】）
					if (null == map.get("金额") || "".equals(map.get("金额"))) {
						BigDecimal unitSumPrice = BigDecimal.ZERO;
						BigDecimal rateCalculation = BigDecimal.ZERO;
						if (null != map.get("价税合计")) {
							unitSumPrice = (BigDecimal) map.get("价税合计");
						}
						// 税率 / 100 + 1
						if (null != map.get("税率(%)")) {
							BigDecimal rate = (BigDecimal) map.get("税率(%)");
							// 税率除以100+1
							rateCalculation = rate.divide(new BigDecimal(100)).add(new BigDecimal(1));
						}
						// 价税合计/（1+税率/100） 四舍五入保留两位小数
						map.put("金额", unitSumPrice.divide(rateCalculation, 3,RoundingMode.FLOOR).setScale(2, BigDecimal.ROUND_HALF_UP));
					}
				}
				// 支持多个sheet Excel
				new ExportSalesDownloadUtil().SalesExportExcel(workbook, shettNum, salesOrderDataList, reportTitles,
						sheet.getSheetName());
			}
			ByteArrayOutputStream output = new ByteArrayOutputStream();
			workbook.write(output);
			byte[] bytes = output.toByteArray();
			response.setContentLength(bytes.length);
			byte[] fileNameByte = ("销售订单.xls").getBytes("utf-8");
			String fileNames = new String(fileNameByte, "ISO8859-1");
			response.setHeader("Content-Disposition", "attachment;filename=" + fileNames);
			response.getOutputStream().write(bytes);
		} catch (Exception e) {
			log.error("销售订单模板下载异常。", e);
		}

	}

	/**
	 * 采购订单数据源模板解析
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping("/purchaseOrderdataSourcePars")
	public void purchaseOrderdataSourcePars(HttpServletRequest request, HttpServletResponse response,
			@RequestParam("purchaseUploadOrderExcel") MultipartFile[] purchaseUploadOrderExcel) {
		Workbook wb = null;
		try {
			if (null != purchaseUploadOrderExcel && purchaseUploadOrderExcel.length > 0) {
				Map<String, Object> mapCell = new LinkedHashMap<String, Object>();
				for (int i = 0; i < purchaseUploadOrderExcel.length; i++) { // 上传多个文件
					MultipartFile purchaseOrderFile = purchaseUploadOrderExcel[i];
					if (StringUtils.isNotEmpty(purchaseOrderFile.getOriginalFilename())) {
						String fileName = purchaseOrderFile.getOriginalFilename();
						int strIndex = fileName.lastIndexOf(".");
						String strFileName = fileName.substring(0, strIndex);
						String fileSuffix = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length());
						if ("xlsx".equalsIgnoreCase(fileSuffix)) {
							wb = new XSSFWorkbook(purchaseOrderFile.getInputStream());
						} else if ("xls".equalsIgnoreCase(fileSuffix)) {
							wb = new HSSFWorkbook(purchaseOrderFile.getInputStream());
						}
						if (i < 3 && !strFileName.contains("采购")) { // 此目的是前三个都是数据源，后一个是模板
							for (int n = 0; n < 1; n++) { // (本次需求默认1个shett)
								Sheet sheet = wb.getSheetAt(n);
								int numberRows = sheet.getPhysicalNumberOfRows(); // 获取所有的行
								log.info("总行数为：" + numberRows);
								for (int j = 1; j < numberRows; j++) { // 获取行
									Row rows = sheet.getRow(j);
									Cell cell = null;
									if (null != rows) {
										// 获取想要的列放到容器中（这里的容器是一个MAP,Excel列从0开始）
										String zeroColumn = null;
										if (strFileName.contains("供应商") || strFileName.contains("部门")
												|| strFileName.contains("物料")) {
											cell = rows.getCell(0); // 获取客户，部门，物料第一列值
											zeroColumn = cellTypeFormat(cell);
										}
										if (strFileName.contains("供应商")) {
											cell = rows.getCell(1); // 获取第二列值
											String twoColumn = cellTypeFormat(cell);
											mapCell.put(twoColumn, zeroColumn); // 客户数据源中的第三列和第一列是key-value关系
										}
										if (strFileName.contains("部门")) {
											cell = rows.getCell(1); // 获取第二列值
											String deptColumn = cellTypeFormat(cell);
											mapCell.put(deptColumn, zeroColumn); // 部门数据源中的第二列和第一列是key-value关系
										}
										if (strFileName.contains("物料")) {
											cell = rows.getCell(5); // 获取第六列值
											String sixColumn = cellTypeFormat(cell);
											cell = rows.getCell(14); // 获取第十四列值
											String fourteenColumn = cellTypeFormat(cell);
											String ztColumn = zeroColumn + "," + fourteenColumn;
											mapCell.put(sixColumn, ztColumn); // 物料数据源中的第六列和第一列,十四列是key-value,value关系
										}
									}
								}
							}
						}
						// 格式化要导出的模板数据
						if (i == 3 && strFileName.contains("采购")) {
							purchaseOrderDownTemplate(response, wb, mapCell);
						}
					}
				}
			}

		} catch (Exception e) {
			log.error("解析采购订单Excel异常。", e);
		}
	}

	/**
	 * 采购订单模板下载
	 */
	private void purchaseOrderDownTemplate(HttpServletResponse response, Workbook wb,
			Map<String, Object> dataSourceMap) {
		HSSFWorkbook workbook = new HSSFWorkbook();
		try {
			int sheetSize = wb.getNumberOfSheets();
			log.info("总sheet页数为：" + sheetSize);
			for (int i = 0; i < 1; i++) { // sheet （本次需求默认1个shett）
				int shettNum = i;
				Sheet sheet = wb.getSheetAt(i);
				int numberRows = sheet.getPhysicalNumberOfRows();
				int numberCells = 0;
				log.info("总行数为：" + numberRows);
				// 列头
				List<String> columnsList = new ArrayList<String>();
				List<List<String>> columnsNameList = new ArrayList<List<String>>();
				for (int j = 0; j < numberRows - numberRows + 1; j++) { // rows
					Row rows = sheet.getRow(j);
					numberCells = rows.getPhysicalNumberOfCells();
					log.info("总列数为：" + numberCells);
					for (int z = 0; z < numberCells; z++) { // cells
						Cell cell = rows.getCell(z);
						String salesOrderColumns = cell.getStringCellValue();
						// 为生成Excel数据组装的数据格式
						columnsList.add(salesOrderColumns);
						// 为生成二维数组组装的数据格式
						List<String> columnTitleList = new ArrayList<String>();
						columnTitleList.add(salesOrderColumns);
						columnTitleList.add(salesOrderColumns);
						columnTitleList.add("string");
						columnTitleList.add("n");
						columnsNameList.add(columnTitleList);
						log.info("列值为：" + salesOrderColumns);
					}
				}
				// 二维数组负责Excel表头
				String[][] reportTitles = new String[columnsNameList.size()][];
				for (int c = 0; c < columnsNameList.size(); c++) {
					List<String> columnList = columnsNameList.get(c);
					reportTitles[c] = columnList.toArray(new String[0]);
				}

				// 从第二行开始记录key - value (列名 - 值) Excel需要的数据
				List<Map<String, Object>> purchaseOrderDataList = new ArrayList<Map<String, Object>>();
				for (int j = 1; j < numberRows; j++) { // 行
					Row rows = sheet.getRow(j);
					if (null != rows) {
						Map<String, Object> columnsMap = new LinkedHashMap<String, Object>();
						// 总列数以第一行的列为准：numberCells
						for (int z = 0; z < numberCells; z++) { // 列
							Cell cell = rows.getCell(z);
							// 对数据做特殊处理，根据key名称 和描述的规则进行value数据转换或者获取
							String cellFormatValue = null;
							if ("业务员_代码".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "999";
								}
							} else if ("业务员".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "无";
								}
							} else if ("汇率类型".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "公司汇率";
								}
							} else if ("采购范围".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "购销";
								}
							} else if ("采购模式".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "普通采购";
								}
							} else if ("计划类别".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "标准";
								}
							} else if ("交货日期".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = DateUtils.getCurrentDateStr();
								}
							} else if ("计划模式".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "MTS计划模式";
								}
							} else if ("检验方式".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "免检";
								}
							} else if ("是否检验".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "0";
								}
							} else {
								cellFormatValue = cellTypeFormat(cell);
							}
							columnsMap.put(columnsList.get(z), cellFormatValue);
						}
						purchaseOrderDataList.add(columnsMap);
					}
				}
				/* 特殊列名处理从数据源容器Map中获取 */
				// 根据业务填写的供应商获取供应商_代码
				for (Map<String, Object> map : purchaseOrderDataList) {
					if (null != map.get("供应商") && !"".equals(map.get("供应商"))) {
						if (null != dataSourceMap.get(map.get("供应商"))) {
							String purchaseCode = String.valueOf(dataSourceMap.get(map.get("供应商")));
							map.put("供应商_代码", purchaseCode);
						}
					}
					// 根据业务填写的部门获取代码
					if (null != map.get("部门")) {
						if (null != dataSourceMap.get(map.get("部门"))) {
							String deptCode = String.valueOf(dataSourceMap.get(map.get("部门")));
							map.put("部门_代码", deptCode);
						}
					}
					// 根据业务输入的助记码获取 代码，单位，税率
					if (null != map.get("物料代码")) {
						if (null != dataSourceMap.get(map.get("物料代码"))) {
							String materialCode = String.valueOf(dataSourceMap.get(map.get("物料代码")));
							if (StringUtils.isNotEmpty(materialCode)) {
								String[] pCode = materialCode.split(",");
								map.put("物料代码", pCode[0]);
								map.put("单位", pCode[1]);
							}
						}
					}
				}
				// 支持多个sheet Excel
				new ExportSalesDownloadUtil().SalesExportExcel(workbook, shettNum, purchaseOrderDataList, reportTitles,
						sheet.getSheetName());
			}
			ByteArrayOutputStream output = new ByteArrayOutputStream();
			workbook.write(output);
			byte[] bytes = output.toByteArray();
			response.setContentLength(bytes.length);
			byte[] fileNameByte = ("采购订单.xls").getBytes("utf-8");
			String fileNames = new String(fileNameByte, "ISO8859-1");
			response.setHeader("Content-Disposition", "attachment;filename=" + fileNames);
			response.getOutputStream().write(bytes);
		} catch (Exception e) {
			log.error("采购订单Excel下载异常。", e);
		}

	}

	/**
	 * 销售出库数据源模板解析
	 * 
	 * @param request
	 * @param response
	 */

	@RequestMapping("/salesOutStorageDataSourcePars")
	public void salesOutStorageDataSourcePars(HttpServletRequest request, HttpServletResponse response,
			@RequestParam("salesOutStorageExcel") MultipartFile[] salesOutStorageExcel) {
		Workbook wb = null;
		try {
			if (null != salesOutStorageExcel && salesOutStorageExcel.length > 0) {
				Map<String, Object> mapCell = new LinkedHashMap<String, Object>();
				List<Map<String, Object>> listCell = new ArrayList<Map<String, Object>>();
				for (int i = 0; i < salesOutStorageExcel.length; i++) { // 上传多个文件
					MultipartFile salesOutStorageFile = salesOutStorageExcel[i];
					if (StringUtils.isNotEmpty(salesOutStorageFile.getOriginalFilename())) {
						String fileName = salesOutStorageFile.getOriginalFilename();
						int strIndex = fileName.lastIndexOf(".");
						String strFileName = fileName.substring(0, strIndex);
						String fileSuffix = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length());
						if ("xlsx".equalsIgnoreCase(fileSuffix)) {
							wb = new XSSFWorkbook(salesOutStorageFile.getInputStream());
						} else if ("xls".equalsIgnoreCase(fileSuffix)) {
							wb = new HSSFWorkbook(salesOutStorageFile.getInputStream());
						}
						if (i < 5 && !strFileName.contains("销售")) { // 此目的是前5个都是数据源，后一个是模板
							for (int n = 0; n < 1; n++) { // (本次需求默认1个shett)
								Sheet sheet = wb.getSheetAt(n);
								int numberRows = sheet.getPhysicalNumberOfRows(); // 获取所有的行
								log.info("总行数为：" + numberRows);
								for (int j = 1; j < numberRows; j++) { // 获取行
									Row rows = sheet.getRow(j);
									Cell cell = null;
									if (null != rows) {
										String storageCell = null;
										if (strFileName.contains("库存")) {
											Map<String, Object> storageCellMap = new HashMap<String, Object>();
											cell = rows.getCell(0);
											storageCell = cellTypeFormat(cell);
											storageCellMap.put("materialCode", storageCell); // 物料代码
											cell = rows.getCell(6);
											storageCell = cellTypeFormat(cell);
											storageCellMap.put("batchNumber", storageCell); // 批号
											cell = rows.getCell(9);
											storageCell = cellTypeFormat(cell);
											storageCellMap.put("warehouseName", storageCell); // 仓库名称
											cell = rows.getCell(11);
											storageCell = cellTypeFormat(cell);
											storageCellMap.put("positionName", storageCell); // 仓位名称
											cell = rows.getCell(12);
											storageCell = cellTypeFormat(cell);
											storageCellMap.put("productDate", storageCell); // 生产/采购日期
											cell = rows.getCell(13);
											storageCell = cellTypeFormat(cell);
											storageCellMap.put("shelfLife", storageCell); // 保质期
											cell = rows.getCell(14);
											storageCell = cellTypeFormat(cell);
											storageCellMap.put("maturityDate", storageCell); // 到期日
											cell = rows.getCell(16);
											storageCell = cellTypeFormat(cell);
											storageCellMap.put("unitNumber", storageCell); // 基本单位数量
											listCell.add(storageCellMap);
										} else {
											// 获取想要的列放到容器中（这里的容器是一个MAP,Excel列从0开始）
											String zeroColumn = null;
											if (strFileName.contains("客户") || strFileName.contains("部门")
													|| strFileName.contains("物料") || strFileName.contains("仓库")) {
												cell = rows.getCell(0); // 获取客户,部门,物料,仓库第一列值
												zeroColumn = cellTypeFormat(cell);
											}
											if (strFileName.contains("客户")) {
												cell = rows.getCell(1); // 获取第二列值
												String twoColumn = cellTypeFormat(cell);
												mapCell.put(twoColumn, zeroColumn); // 客户数据源中的第二列和第一列是key-value关系
											}
											if (strFileName.contains("部门")) {
												cell = rows.getCell(1); // 获取第二列值
												String deptColumn = cellTypeFormat(cell);
												mapCell.put(deptColumn, zeroColumn); // 部门数据源中的第二列和第一列是key-value关系
											}
											if (strFileName.contains("物料")) {
												cell = rows.getCell(5); // 获取第六列值
												String sixColumn = cellTypeFormat(cell);
												cell = rows.getCell(16); // 获取第十七列值
												String SeventeenColumn = cellTypeFormat(cell);
												String ztColumn = zeroColumn + "," + SeventeenColumn;
												mapCell.put(sixColumn, ztColumn); // 物料数据源中的第六列和第一列,十七列是key-value,value关系
											}
											if (strFileName.contains("仓库")) {
												cell = rows.getCell(1); // 获取第二列值
												String twoColumn = cellTypeFormat(cell);
												mapCell.put(twoColumn, zeroColumn); // 仓库数据源中的第二列和第一列是key-value关系
											}
										}
									}
								}
							}
						}
						// 格式化要导出的模板数据
						if (i == 5 && strFileName.contains("销售")) {
							salesOutStorageDownTemplate(response, wb, mapCell, listCell);
						}
					}
				}
			}

		} catch (Exception e) {
			log.error("解析销售出库Excel异常。", e);
		}
	}

	/**
	 * 销售出库模板下载
	 */
	private void salesOutStorageDownTemplate(HttpServletResponse response, Workbook wb,
			Map<String, Object> dataSourceMap, List<Map<String, Object>> storageList) {
		HSSFWorkbook workbook = new HSSFWorkbook();
		try {
			int sheetSize = wb.getNumberOfSheets();
			log.info("总sheet页数为：" + sheetSize);
			for (int i = 0; i < 1; i++) { // sheet （本次需求默认1个shett）
				int shettNum = i;
				Sheet sheet = wb.getSheetAt(i);
				int numberRows = sheet.getPhysicalNumberOfRows();
				int numberCells = 0;
				log.info("总行数为：" + numberRows);
				// 列头
				List<String> columnsList = new ArrayList<String>();
				List<List<String>> columnsNameList = new ArrayList<List<String>>();
				for (int j = 0; j < numberRows - numberRows + 1; j++) { // rows
					Row rows = sheet.getRow(j);
					numberCells = rows.getPhysicalNumberOfCells();
					log.info("总列数为：" + numberCells);
					for (int z = 0; z < numberCells; z++) { // cells
						Cell cell = rows.getCell(z);
						String salesOrderColumns = cell.getStringCellValue();
						// 为生成Excel数据组装的数据格式
						columnsList.add(salesOrderColumns);
						// 为生成二维数组组装的数据格式
						List<String> columnTitleList = new ArrayList<String>();
						columnTitleList.add(salesOrderColumns);
						columnTitleList.add(salesOrderColumns);
						columnTitleList.add("string");
						columnTitleList.add("n");
						columnsNameList.add(columnTitleList);
						if (z == numberCells - 1) {
							// columnsList.add("计划出库数量");
							List<String> addColumnTitleList = new ArrayList<String>();
							addColumnTitleList.add("计划出库数量");
							addColumnTitleList.add("计划出库数量");
							addColumnTitleList.add("string");
							addColumnTitleList.add("n");
							columnsNameList.add(addColumnTitleList);
						}
						log.info("列值为：" + salesOrderColumns);
					}
				}
				// 二维数组负责Excel表头
				String[][] reportTitles = new String[columnsNameList.size()][];
				for (int c = 0; c < columnsNameList.size(); c++) {
					List<String> columnList = columnsNameList.get(c);
					reportTitles[c] = columnList.toArray(new String[0]);
				}

				// 从第二行开始记录key - value (列名 - 值) Excel需要的数据
				List<Map<String, Object>> purchaseOrderDataList = new ArrayList<Map<String, Object>>();
				for (int j = 1; j < numberRows; j++) { // 行
					Row rows = sheet.getRow(j);
					if (null != rows) {
						Map<String, Object> columnsMap = new LinkedHashMap<String, Object>();
						// 总列数以第一行的列为准：numberCells
						for (int z = 0; z < numberCells; z++) { // 列
							Cell cell = rows.getCell(z);
							// 对数据做特殊处理，根据key名称 和描述的规则进行value数据转换或者获取
							String cellFormatValue = null;
							if ("发货_代码".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "999";
								}
							} else if ("发货".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "无";
								}
							} else if ("保管_代码".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "999";
								}
							} else if ("保管".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "无";
								}
							} else if ("销售业务类型".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "销售出库类型";
								}
							} else if ("业务员_代码".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "999";
								}
							} else if ("业务员".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "无";
								}
							} else if ("主管_代码".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "999";
								}
							} else if ("主管".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "无";
								}
							} else if ("销售单价".equals(columnsList.get(z))) {
								cellFormatValue = cellTypeFormat(cell);
								if (StringUtils.isNotEmpty(cellFormatValue)) {
									cellFormatValue = String.valueOf(
											new BigDecimal(cellFormatValue).setScale(2, BigDecimal.ROUND_HALF_UP));
								}
							} else if ("销售金额".equals(columnsList.get(z))) {
								cellFormatValue = cellTypeFormat(cell);
								if (StringUtils.isNotEmpty(cellFormatValue)) {
									cellFormatValue = String.valueOf(
											new BigDecimal(cellFormatValue).setScale(2, BigDecimal.ROUND_HALF_UP));
								}
							} else if ("折扣额".equals(columnsList.get(z))) {
								cellFormatValue = cellTypeFormat(cell);
								if (StringUtils.isNotEmpty(cellFormatValue)) {
									cellFormatValue = String.valueOf(
											new BigDecimal(cellFormatValue).setScale(2, BigDecimal.ROUND_HALF_UP));
								}
							} else if ("计划模式".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "MTS计划模式";
								}
							} else if ("检验是否良品".equals(columnsList.get(z))) {
								if (StringUtils.isEmpty(cellTypeFormat(cell))) {
									cellFormatValue = "是";
								}
							} else {
								cellFormatValue = cellTypeFormat(cell);
							}

							columnsMap.put(columnsList.get(z), cellFormatValue);
						}
						columnsMap.put("计划出库数量", columnsMap.get("实发数量"));
						purchaseOrderDataList.add(columnsMap);
					}
				}
				/* 特殊列名处理从数据源容器Map中获取 */
				// 根据业务填写的供应商获取供应商_代码
				List<Map<String, Object>> addToList = new ArrayList<Map<String, Object>>();
				for (Map<String, Object> map : purchaseOrderDataList) {
					if (null != map.get("购货单位") && !"".equals(map.get("购货单位"))) {
						if (null != dataSourceMap.get(map.get("购货单位"))) {
							String purchaseCode = String.valueOf(dataSourceMap.get(map.get("购货单位")));
							map.put("购货单位_代码", purchaseCode);
						}
					}
					// 根据业务填写的部门名称获取代码
					if (null != map.get("部门")) {
						if (null != dataSourceMap.get(map.get("部门"))) {
							String deptCode = String.valueOf(dataSourceMap.get(map.get("部门")));
							map.put("部门_代码", deptCode);
						}
					}
					// 产品代码 根据助记码找代码和单位
					if (null != map.get("产品代码") && !"".equals(map.get("产品代码"))) {
						if (null != dataSourceMap.get(map.get("产品代码"))) {
							String productCode = String.valueOf(dataSourceMap.get(map.get("产品代码")));
							if (StringUtils.isNotEmpty(productCode)) {
								String[] pCode = productCode.split(",");
								map.put("产品代码", pCode[0]);
								map.put("单位", pCode[1]);
							}
						}
					}
					// 把实发数量的后四位小数去掉，并同时赋给新增的列 计划出库数量
					if (null != map.get("实发数量") && !"".equals(map.get("实发数量"))) {
						map.put("实发数量", String.valueOf(new BigDecimal(map.get("实发数量").toString()).setScale(0, BigDecimal.ROUND_UP)));
						map.put("计划出库数量", String.valueOf(new BigDecimal(map.get("实发数量").toString()).setScale(0, BigDecimal.ROUND_UP)));
					}
					// 根据发货仓库名称取代码
					if (null != map.get("发货仓库") && !"".equals(map.get("发货仓库"))) {
						if (null != dataSourceMap.get(map.get("发货仓库"))) {
							String dwCode = String.valueOf(dataSourceMap.get(map.get("发货仓库")));
							map.put("发货仓库_代码", dwCode);
						}
					}
					// 到库存数据源中找 代码 发货仓库 仓位 相同的数据
					if (!ListUtils.isEmpty(storageList)) {
						String productCode = null;
						String deliveryName = null;
						String positions = null;
						if (null != map.get("产品代码")) {
							productCode = String.valueOf(map.get("产品代码"));
						}
						if (null != map.get("发货仓库")) {
							deliveryName = String.valueOf(map.get("发货仓库"));
						}
						if (null != map.get("仓位")) {
							positions = String.valueOf(map.get("仓位"));
						}
						// 根据模板行中数据找到对应库存数据源中的数据
						List<Map<String, Object>> inventoryList = new ArrayList<Map<String, Object>>();
						for (Map<String, Object> storageMap : storageList) {
							String materialCode = null;
							String warehouseName = null;
							String positionName = null;
							if (null != storageMap.get("materialCode")) {
								materialCode = String.valueOf(storageMap.get("materialCode"));
							}
							if (null != storageMap.get("warehouseName")) {
								warehouseName = String.valueOf(storageMap.get("warehouseName"));
							}
							if (null != storageMap.get("positionName")) {
								positionName = String.valueOf(storageMap.get("positionName"));
							}
							if (null != storageMap.get("batchNumber")) {

							}
							// 产品代码 == 库存物料代码，仓库名称 == 库存仓库名称 ，仓位名称 == 库存仓位名称
							if (productCode.equals(materialCode) && deliveryName.equals(warehouseName)
									&& positions.equals(positionName)) {
								inventoryList.add(storageMap);
							}
						}
						// 根据批号进行排序，小的在前面
						if (!ListUtils.isEmpty(inventoryList)) {
							// 对集合中的对象进行排序，折扣越小的数字，就优先排到前面展示
							Collections.sort(inventoryList, new Comparator<Map<String, Object>>() {
								public int compare(Map<String, Object> map0, Map<String, Object> map1) {
									String map0BatchNumber = String.valueOf(map0.get("batchNumber"));
									String map1BatchNumber = String.valueOf(map1.get("batchNumber"));
									return map0BatchNumber.compareTo(map1BatchNumber);
								}
							});

							// 拿最小批号数据去模板中填充，再和数量对比，如果数据源中数据量不满足，就借下一行最小的数据源
							BigDecimal netAmount = BigDecimal.ZERO;
							int dataNum = 0;
							if (null != map.get("实发数量")) {
								netAmount = new BigDecimal(String.valueOf(map.get("实发数量")));
							}
							for (Map<String, Object> dataMap : inventoryList) { // 数据源中数据相同的有多行只是单位数据量不一样
								boolean tagBreak = true;
								String mCode = String.valueOf(dataMap.get("materialCode"));
								String wName = String.valueOf(dataMap.get("warehouseName"));
								String pName = String.valueOf(dataMap.get("positionName"));
								String bNumber = String.valueOf(dataMap.get("batchNumber"));

								map.put("批号", dataMap.get("batchNumber"));
								map.put("生产/采购日期", dataMap.get("productDate"));
								map.put("保质期(天)", dataMap.get("shelfLife"));
								map.put("有效期至", dataMap.get("maturityDate"));
								if (netAmount.compareTo(BigDecimal.ZERO) > 0) {
									if (null != dataMap.get("unitNumber") && !"".equals(dataMap.get("unitNumber"))) { // 库存中的基本单位数量
										BigDecimal unitNumber = new BigDecimal(dataMap.get("unitNumber").toString())
												.setScale(0, BigDecimal.ROUND_UP);

										for (Map<String, Object> storageMap : storageList) {
											String materialCode = null;
											String warehouseName = null;
											String positionName = null;
											String batchNumber = null;
											if (null != storageMap.get("materialCode")) {
												materialCode = String.valueOf(storageMap.get("materialCode"));
											}
											if (null != storageMap.get("warehouseName")) {
												warehouseName = String.valueOf(storageMap.get("warehouseName"));
											}
											if (null != storageMap.get("positionName")) {
												positionName = String.valueOf(storageMap.get("positionName"));
											}
											if (null != storageMap.get("batchNumber")) {
												batchNumber = String.valueOf(storageMap.get("batchNumber"));
											}
											// 产品代码 == 库存物料代码，仓库名称 == 库存仓库名称
											// ，仓位名称 == 库存仓位名称:目的是单位数据量在变化
											if (mCode.equals(materialCode) && wName.equals(warehouseName)
													&& pName.equals(positionName) && bNumber.equals(batchNumber)) {
												// 如果实发数量小于库存单位数量，库存单位数量就减去实发数量，并填充数据源中（这里是填充到storageList中）
												BigDecimal actualNumber = BigDecimal.ZERO;
												if (netAmount.compareTo(unitNumber) <= 0) {
													actualNumber = unitNumber.subtract(netAmount);
													storageMap.put("unitNumber", actualNumber);
													tagBreak = false;
													if (dataNum > 0) { // 大于零表示第二次进入
														Map<String, Object> newMap = new HashMap<String, Object>();
														newMap.putAll(map);
														newMap.put("实发数量", netAmount);
														addToList.add(newMap); // 添加一行
													}
													break;
												} else if (netAmount.compareTo(unitNumber) > 0) { // 如果实发数量大于库存单位数量
													actualNumber = netAmount.subtract(unitNumber);
													storageMap.put("unitNumber", ""); // 把数据源此行此列设置为空（因为已经全部抵扣掉了）
													netAmount = actualNumber;
													if (dataNum > 0) { // 大于零表示第二次进入
														Map<String, Object> newMap = new LinkedHashMap<String, Object>();
														newMap.putAll(map);
														newMap.put("实发数量", unitNumber);
														addToList.add(newMap); // 添加一行
														break;
													} else {
														map.put("实发数量", unitNumber); // 当前行数据的实发数量已经改变
														break;
													}
												}

											}
										}
										if (!tagBreak) { // 跳出最外层
											break;
										}
									}
								}
								dataNum++;
							}
						}
					}

				}
				// 支持多个sheet Excel
				if (!ListUtils.isEmpty(addToList) && addToList.size() > 0) {
					purchaseOrderDataList.addAll(addToList);
				}
				new ExportSalesDownloadUtil().SalesExportExcel(workbook, shettNum, purchaseOrderDataList, reportTitles,
						sheet.getSheetName());
			}
			ByteArrayOutputStream output = new ByteArrayOutputStream();
			workbook.write(output);
			byte[] bytes = output.toByteArray();
			response.setContentLength(bytes.length);
			byte[] fileNameByte = ("销售出库.xls").getBytes("utf-8");
			String fileNames = new String(fileNameByte, "ISO8859-1");
			response.setHeader("Content-Disposition", "attachment;filename=" + fileNames);
			response.getOutputStream().write(bytes);
		} catch (Exception e) {
			log.error("销售出库模板下载异常。", e);
		}

	}

	/**
	 * 解析Excel 内容格式化
	 * 
	 * @param cell
	 * @return
	 */
	private String cellTypeFormat(Cell cell) {
		String cellValue = null;
		if (null != cell) {
			int cellType = cell.getCellType();
			switch (cellType) {
			case Cell.CELL_TYPE_STRING:// 文本  
				cellValue = cell.getStringCellValue();
				break;
			case Cell.CELL_TYPE_NUMERIC: // 数字、日期  
				if (DateUtil.isCellDateFormatted(cell)) {
					cellValue = fmt.format(cell.getDateCellValue()); // 日期型  
				} else {
					cellValue = String.valueOf(new BigDecimal(cell.getNumericCellValue()));
				}
				break;
			case Cell.CELL_TYPE_BOOLEAN:// 布尔型
				cellValue = String.valueOf(cell.getBooleanCellValue());
				break;
			case Cell.CELL_TYPE_BLANK: // 空白  
				cellValue = cell.getStringCellValue();
				break;
			case Cell.CELL_TYPE_ERROR: // 错误  
				cellValue = "";
				break;
			case Cell.CELL_TYPE_FORMULA: // 公式  
				cellValue = "";
				break;
			default:
				cellValue = "";
			}
		}
		return cellValue;
	}

	public static void main(String[] args) {
		/*
		 * Map<String,Object> map = new HashMap<String,Object>(); BigDecimal
		 * unitPrice = null; map.put("test", "12.3000"); try{ unitPrice = new
		 * BigDecimal(String.valueOf(map.get("test")));
		 * System.out.println(unitPrice); }catch(Exception e){
		 * System.out.println(e); System.out.println(unitPrice); }
		 */
		// 找最小的日期
		/*List<String> strList = new ArrayList<String>();
		String date1 = "2016/05/09";
		String date2 = "2016/05/18";
		String date3 = "2016/05/19";
		String date4 = "2016/05/20";
		String date5 = "2016/05/07";
		strList.add(date1);
		strList.add(date2);
		strList.add(date3);
		strList.add(date4);
		strList.add(date5);
		String dateTest = strList.get(0);
		for (int i = 0; i < strList.size(); i++) {
			String strDate = strList.get(i);
			if (strDate.compareTo(dateTest) < 0) {
				dateTest = strDate;
			}
		}
		System.out.println(dateTest);

		if (date1.compareTo(date2) == 0) {
			System.out.println("相等");
		} else if (date1.compareTo(date2) < 0) {
			System.out.println("date1 小于 date2");
		} else {
			System.out.println("date1 大于 date2");
		} */
	}
	

}
