package cn.com.cgbchina.batch.excel;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
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
 * 商户销售统计报表（广发商城管理平台）
 * 
 * @author xiewl
 *
 */

@Slf4j
@Component
public class VendorSaleStatReportExcel {

	@Value("${vendorSaleStat.tempPath}")
	private String templatePath; // 报表模版路径

	@Value("${vendorSaleStat.day.outpath}")
	private String dayOutputPath; // 日报表导出路径
	@Value("${vendorSaleStat.week.outpath}")
	private String weekOutputPath; // 周报表导出路径
	@Value("${vendorSaleStat.month.outpath}")
	private String monthOutputPath; // 月报表导出路径

	@Value("${vendorSaleStat.day.reportName}")
	private String dayReportName;// 日报表文件名
	@Value("${vendorSaleStat.week.reportName}")
	private String weekReportName;// 周报表文件名
	@Value("${vendorSaleStat.month.reportName}")
	private String monthReportName;// 月报表文件名
	@Autowired
	private ReportManager reportManager;

	/**
	 * 商户销售统计报表(日) 每日凌晨生成（统计每日0点至24点）
	 * 
	 */
	@Report(id = ReportConstant.YG_VENDOR_STAT_06,
			name = "商户销售统计日报表", type = ReportType.DAY)
	public Response<Boolean> exportVenderSaleStatForDay(String batchDate) {
		Response<Boolean> rps = new Response<>();
		try {
			Date startCommDate = BatchDateUtil.parseDate(batchDate);
			String endDate = BatchDateUtil.addDay(batchDate, 1); 
			Date endCommDate = BatchDateUtil.parseDate(endDate);
			QueryParams queryParams = new QueryParams();
			queryParams.setStartDate(startCommDate);
			queryParams.setEndDate(endCommDate);
			// bug 供应商应该合并，不应分商户
//			if (StringUtils.notEmpty(vendorId)) {
//				queryParams.setVendorId(vendorId);
//			}
//			String reportName = dayReportName;
//			if (Strings.isNullOrEmpty(vendorNm)) {
//				vendorNm = "all";
//			} else {
//				reportName = dayReportName + "_" + vendorNm;
//			}
			String filePath = ExcelUtilAgency.encodingOutputFilePath(dayOutputPath, dayReportName, batchDate);
			filePath = queryDataToExcels(queryParams, filePath, dayReportName);

			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.YG_VENDOR_STAT_06, dayReportName,
					batchDate, filePath, ReportConstant.DAY_REPORT_TYPE);
			Response<Integer> response = reportManager.insertReportReg(reportModel);
			if (!response.isSuccess()) {
				rps.setError(response.getError());
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("商户销售统计报表(日) 处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	/**
	 * 商户销售统计报表（周） 每周日凌晨生成（每周上周日至本周六）
	 * 
	 */
	@Report(id = ReportConstant.YG_VENDOR_STAT_10,
			name = "商户销售统计周报表", type = ReportType.WEEK)
	public Response<Boolean> exportVenderSaleStatForWeek(String batchDate) {
		Response<Boolean> rps = new Response<>();
		try {
			Date startCommDate = BatchDateUtil.parseDate(batchDate);
			String endDate = BatchDateUtil.addDay(batchDate, 7);
			Date endCommDate = BatchDateUtil.parseDate(endDate);
			QueryParams queryParams = new QueryParams();
			queryParams.setStartDate(startCommDate);
			queryParams.setEndDate(endCommDate);
			// bug 供应商应该合并，不应分商户
//			if (StringUtils.notEmpty(vendorId)) {
//				queryParams.setVendorId(vendorId);
//			}
//			String reportName = weekReportName;
//			if (Strings.isNullOrEmpty(vendorNm)) {
//				vendorNm = "all";
//			} else {
//				reportName = weekReportName + "_" + vendorNm;
//			}
			String filePath = ExcelUtilAgency.encodingOutputFilePath(weekOutputPath, weekReportName, batchDate);
			filePath = queryDataToExcels(queryParams, filePath, weekReportName);

			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.YG_VENDOR_STAT_10, weekReportName,
					batchDate, filePath, ReportConstant.WEEK_REPORT_TYPE);
			Response<Integer> response = reportManager.insertReportReg(reportModel);
			if (!response.isSuccess()) {
				rps.setError(response.getError());
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("商户销售统计报表（周） 处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	/**
	 * 商户销售统计报表（月） 每月一日凌晨生成（每月初至月底）
	 * 
	 */
	@Report(id = ReportConstant.YG_VENDOR_STAT_14,
			name = "商户销售统计月报表", type = ReportType.MONTH)
	public Response<Boolean> exportVenderSaleStatForMonth(String batchDate) {
		Response<Boolean> rps = new Response<>();
		try {

			Date startCommDate = BatchDateUtil.parseDate(batchDate);
			Date endCommDate = BatchDateUtil.addMonth(startCommDate, 1);
			QueryParams queryParams = new QueryParams();
			queryParams.setStartDate(startCommDate);
			queryParams.setEndDate(endCommDate);
			// bug 供应商应该合并，不应分商户
//			if (StringUtils.notEmpty(vendorId)) {
//				queryParams.setVendorId(vendorId);
//			}
//			String reportName = monthReportName;
//			if (Strings.isNullOrEmpty(vendorNm)) {
//				vendorNm = "all";
//			} else {
//				reportName = monthReportName + "_" + vendorNm;
//			}
			String filePath = ExcelUtilAgency.encodingOutputFilePath(monthOutputPath, monthReportName, batchDate);
			filePath = queryDataToExcels(queryParams, filePath, monthReportName);

			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.YG_VENDOR_STAT_14,
					monthReportName, batchDate, filePath, ReportConstant.MONTH_REPORT_TYPE);
			Response<Integer> response = reportManager.insertReportReg(reportModel);
			if (!response.isSuccess()) {
				rps.setError(response.getError());
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("商户销售统计报表（月）处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	/**
	 * 获取数据到Excel
	 * 
	 * @param queryParam 查询条件
	 * @param outPath 导出路径
	 * @param titleName
	 * @return outputFiles 已修正的导出文件路径
	 * @throws IOException
	 */
	private String queryDataToExcels(QueryParams queryParam, String outPath, String titleName) throws IOException {
		String filePath = "";
		try {
			Map<String, String> params = Maps.newHashMap();
			params.put("title", titleName);
			Response<List<OrderBatchDto>> result = reportManager.findVendorSaleStatistics(queryParam);
			if (!result.isSuccess()) {
				// 调用失败，判断异常情况，异常处理，日志写入
				// log.error()
				throw new RuntimeException(result.getError());
			}
			List<OrderBatchDto> vendorSaleStats = result.getResult();
			filePath = ExcelUtilAgency.exportExcel(vendorSaleStats, templatePath, outPath, params);
		} catch (IOException e) {
			log.error("导出模版错误" + e.getMessage());
			throw e;
		}
		return filePath;
	}

}
