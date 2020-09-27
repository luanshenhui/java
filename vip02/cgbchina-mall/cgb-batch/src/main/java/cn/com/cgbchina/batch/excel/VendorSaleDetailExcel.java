package cn.com.cgbchina.batch.excel;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import cn.com.cgbchina.batch.dto.OrderBatchDto;
import cn.com.cgbchina.batch.manager.ReportManager;
import cn.com.cgbchina.batch.model.QueryParams;
import cn.com.cgbchina.batch.model.ReportModel;
import cn.com.cgbchina.batch.util.Report;
import cn.com.cgbchina.batch.util.Report.ReportType;
import cn.com.cgbchina.batch.util.ReportConstant;
import cn.com.cgbchina.batch.util.ReportTaskUtil;
import cn.com.cgbchina.common.utils.BatchDateUtil;
import cn.com.cgbchina.common.utils.ExcelUtilAgency;
import lombok.extern.slf4j.Slf4j;

/**
 * (广发商城管理平台) 商户销售明细报表
 * 
 * @author Huangcy
 */
@Slf4j
@Component
public class VendorSaleDetailExcel {
	@Autowired
	private ReportManager reportManager;

	@Value("${vendorSaleDetail.day.outpath}")
	private String dayOutputPath; // 日报表导出路径
	@Value("${vendorSaleDetail.week.outpath}")
	private String weekOutputPath; // 周报表导出路径
	@Value("${vendorSaleDetail.month.outpath}")
	private String monthOutputPath; // 月报表导出路径

	@Value("${vendorSaleDetail.day.reportName}")
	private String dayReportName;// 日报表名称
	@Value("${vendorSaleDetail.week.reportName}")
	private String weekReportName;// 周报表名称
	@Value("${vendorSaleDetail.month.reportName}")
	private String monthReportName;// 月报表名称

	@Value("${vendorSaleDetail.tempPath}")
	private String templatePath;

	@Value("${excel.MaxNum}")
	private int size;

	/**
	 * (广发商城) 商户销售明细报表(日) 每日凌晨生成（统计每日0点至24点）
	 */
	@Report(id = ReportConstant.YG_VENDOR_SALE_07, name = "商户销售明细日报表", type = ReportType.DAY)
	public Response<Boolean> exportDayReport(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			Date startCommDate = BatchDateUtil.parseDate(reportDate);
			String endDate = BatchDateUtil.addDay(reportDate, 1); 
			Date endCommDate = BatchDateUtil.parseDate(endDate);
			QueryParams queryParams = new QueryParams();
			queryParams.setStartDate(startCommDate);
			queryParams.setEndDate(endCommDate);
			String filePath = ExcelUtilAgency.encodingOutputFilePath(dayOutputPath, dayReportName, reportDate);
			String outputFile = queryDatasAndExport(queryParams, filePath, dayReportName);
			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.YG_VENDOR_SALE_07, dayReportName,
					reportDate, outputFile, ReportConstant.DAY_REPORT_TYPE);
			Response<Integer> response = reportManager.insertReportReg(reportModel);
			if (!response.isSuccess()) {
				rps.setError(response.getError());
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("商户销售明细报表(日) 处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	/**
	 * 商户销售明细报表（周） 每周日凌晨生成（每周上周日至本周六）
	 */
	@Report(id = ReportConstant.YG_VENDOR_SALE_11, name = "商户销售明细周报表", type = ReportType.WEEK)
	public Response<Boolean> exportWeekReport(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			Date startDate = BatchDateUtil.parseDate(reportDate);
			String endDateTemp = BatchDateUtil.addDay(reportDate, 7); 
			Date endDate = BatchDateUtil.parseDate(endDateTemp);
			QueryParams queryParams = new QueryParams();
			queryParams.setStartDate(startDate);
			queryParams.setEndDate(endDate);

			String filePath = ExcelUtilAgency.encodingOutputFilePath(weekOutputPath, weekReportName, reportDate);
			String outputFile = queryDatasAndExport(queryParams, filePath, weekReportName);
			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.YG_VENDOR_SALE_11, weekReportName,
					reportDate, outputFile, ReportConstant.WEEK_REPORT_TYPE);
			Response<Integer> response = reportManager.insertReportReg(reportModel);
			if (!response.isSuccess()) {
				rps.setError(response.getError());
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("商户销售明细报表(周) 处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	/**
	 * 商户销售明细报表（月） 每月一日凌晨生成（每月初至月底）
	 */
	@Report(id = ReportConstant.YG_VENDOR_SALE_15, name = "商户销售明细月报表", type = ReportType.MONTH)
	public Response<Boolean> exportVenderSaleDetailForMonth(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			Date startDate = BatchDateUtil.parseDate(reportDate);
			Date endDate = BatchDateUtil.addMonth(startDate, 1);
			QueryParams queryParams = new QueryParams();
			queryParams.setStartDate(startDate);
			queryParams.setEndDate(endDate);

			String filePath = ExcelUtilAgency.encodingOutputFilePath(monthOutputPath, monthReportName, reportDate);
			String outputFile = queryDatasAndExport(queryParams, filePath, monthReportName);
			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.YG_VENDOR_SALE_15,
					monthReportName, reportDate, outputFile, ReportConstant.MONTH_REPORT_TYPE);
			Response<Integer> response = reportManager.insertReportReg(reportModel);
			if (!response.isSuccess()) {
				rps.setError(response.getError());
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("商户销售明细报表（月） 处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	/**
	 * 获取数据到Excel
	 * 
	 * @param queryParams 查询条件
	 * @param outputPath 导出路径
	 * @param titleName 报表名称
	 * @return outputFiles 已修正的导出文件路径
	 */
	private String queryDatasAndExport(QueryParams queryParams, String outputPath, String titleName) {
		String filePath = "";
		try {
			int index = 1;
			int pageNo = 1;// 页码
			queryParams.setFirstVisit(true);// 第一次取数
			Pager<OrderBatchDto> pager = getPager(pageNo, queryParams);
			int totalPages = ReportTaskUtil.calTotalPages(pager.getTotal(), size);
			List<String> outputFiles = Lists.newArrayList();
			while (pageNo <= totalPages) {
				// 处理路径是否加文件序号
				String newOutput = totalPages > 1 ? ExcelUtilAgency.addExcelNo(outputPath, pageNo) : outputPath;
				List<OrderBatchDto> goodsSaleDetails = pager.getData();
				for (OrderBatchDto orderBatchDto : goodsSaleDetails) {
					orderBatchDto.setIndex(index++);

					String cardNo = orderBatchDto.getCardNo();
					if (cardNo != null && cardNo.length() > 4) {
						cardNo = cardNo.substring(cardNo.length() - 4);
					}
					orderBatchDto.setCardNo(cardNo);

					String cardType = orderBatchDto.getCardType();
					cardType = "C".equals(cardType) ? "信用卡" : "借记卡";
					orderBatchDto.setCardType(cardType);
				}
				// 导出数据
				filePath = ExcelUtilAgency.exportExcel(titleName, goodsSaleDetails, templatePath, newOutput);
				outputFiles.add(filePath);
				pageNo++;
				if (pageNo <= totalPages) {// 获取下一份数据
					queryParams.setFirstVisit(false);// 不是第一次访问，不用重复统计总数量
					pager = getPager(pageNo, queryParams);
				}
			}
			if (outputFiles.size() > 1) {
				filePath = ExcelUtilAgency.replacePostfix(outputPath);
				filePath = ExcelUtilAgency.zipFiles(filePath, outputFiles);
			}
		} catch (IOException e) {
			log.error(titleName + "导出数据出错：" + e.getMessage());
			throw new RuntimeException(e);
		}
		return filePath;
	}

	/**
	 * 获取数据
	 * 
	 * @param pageNo
	 * @param queryParams
	 * @return
	 */
	private Pager<OrderBatchDto> getPager(int pageNo, QueryParams queryParams) {
		PageInfo pageInfo = new PageInfo(pageNo, size);
		queryParams.setOffset(pageInfo.getOffset());
		queryParams.setLimit(pageInfo.getLimit());
		Response<Pager<OrderBatchDto>> result = reportManager.findVendorSaleDetail(queryParams);
		if (!result.isSuccess()) {
			// 调用失败，判断异常情况，异常处理，日志写入
			log.error(result.getError());
			throw new RuntimeException(result.getError());
		}
		Pager<OrderBatchDto> pager = result.getResult();
		return pager;
	}

}
