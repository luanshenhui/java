package cn.com.cgbchina.batch.excel;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
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
import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.BatchDateUtil;
import cn.com.cgbchina.common.utils.ExcelUtilAgency;
import lombok.extern.slf4j.Slf4j;

/**
 * 普通礼品销售报表（积分商城）
 * 
 * @author xiewl
 */
@Slf4j
@Component
public class CommonGiftSaleReportExcel {

	@Value("${commonGiftSale.tempDayPath}")
	private String templateDayPath; // 日报表模版路径
	@Value("${commonGiftSale.tempPath}")
	private String templatePath; // 报表模版路径

	@Value("${commonGiftSale.day.outpath}")
	private String dayOutputPath; // 日报表导出路径
	@Value("${commonGiftSale.week.outpath}")
	private String weekOutputPath; // 周报表导出路径
	@Value("${commonGiftSale.month.outpath}")
	private String monthOutputPath; // 月报表导出路径

	@Value("${commonGiftSale.day.fileName}")
	private String dayReportName;// 日报表文件名
	@Value("${commonGiftSale.week.fileName}")
	private String weekReportName;// 周报表文件名
	@Value("${commonGiftSale.month.fileName}")
	private String monthReportName;// 月报表文件名

	@Value("${excel.MaxNum}")
	private int size;
	@Autowired
	private ReportManager reportManager;

	/**
	 * 普通礼品销售报表(日) 每日凌晨生成（统计每日0点至24点）
	 * 
	 * @param vendorId 供应商ID 为空则导出全部数据
	 * @param vendorNm 供应商名称 为空则导出全部数据
	 */
	@Report(id = ReportConstant.JF_COMMONGIFT_SALE_01, name = "普通礼品销售日报表",
			type = ReportType.DAY, ordertypeId = Contants.BUSINESS_TYPE_JF)
	public Response<Boolean> exportGiftSaleXlsForDay(String batchDate, String vendorId, String vendorNm) {
		Response<Boolean> rps = new Response<>();
		try {
			Date startCommDate = BatchDateUtil.parseDate(batchDate);
			String endDate = BatchDateUtil.addDay(batchDate, 1); 
			Date endCommDate = BatchDateUtil.parseDate(endDate);
			QueryParams queryParams = new QueryParams();
			queryParams.setStartDate(startCommDate);
			queryParams.setEndDate(endCommDate);
			queryParams.setVendorId(vendorId);
			String reportName = dayReportName;
			if (Strings.isNullOrEmpty(vendorNm)) {
				vendorNm = "all";
			} else {
				reportName = dayReportName + "_" + vendorNm;
			}
			String filePath = ExcelUtilAgency.encodingOutputFilePath(dayOutputPath, reportName, batchDate);
			String outputFile = queryDataToExcels(queryParams, templateDayPath, filePath, reportName);
			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.JF_COMMONGIFT_SALE_01,
					dayReportName, batchDate, outputFile, vendorId, ReportConstant.DAY_REPORT_TYPE);
			Response<Integer> response = reportManager.insertReportReg(reportModel);
			if (!response.isSuccess()) {
				rps.setError(response.getError());
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("普通礼品销售报表(日) 处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	/**
	 * 普通礼品销售报表(周) 每周日凌晨生成（统计每周上周日至本周六）
	 * 
	 * @param vendorId 供应商ID 为空则导出全部数据
	 * @param vendorNm 供应商名称 为空则导出全部数据
	 */
	@Report(id = ReportConstant.JF_COMMONGIFT_SALE_04, name = "普通礼品销售周报表",
			type = ReportType.WEEK, ordertypeId = Contants.BUSINESS_TYPE_JF)
	public Response<Boolean> exportGiftSaleXlsForWeek(String batchDate, String vendorId, String vendorNm) {
		Response<Boolean> rps = new Response<>();
		try {
			Date startCommDate = BatchDateUtil.parseDate(batchDate);
			String endDate = BatchDateUtil.addDay(batchDate, 7);
			Date endCommDate = BatchDateUtil.parseDate(endDate);
			QueryParams queryParams = new QueryParams();
			queryParams.setStartDate(startCommDate);
			queryParams.setEndDate(endCommDate);
			queryParams.setVendorId(vendorId);
			String reportName = weekReportName;
			if (Strings.isNullOrEmpty(vendorNm)) {
				vendorNm = "all";
			} else {
				reportName = weekReportName + "_" + vendorNm;
			}
			String filePath = ExcelUtilAgency.encodingOutputFilePath(weekOutputPath, reportName, batchDate);
			String outputFile = queryDataToExcels(queryParams, templatePath, filePath, reportName);
			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.JF_COMMONGIFT_SALE_04,
					weekReportName, batchDate, outputFile, vendorId, ReportConstant.WEEK_REPORT_TYPE);
			Response<Integer> response = reportManager.insertReportReg(reportModel);
			if (!response.isSuccess()) {
				rps.setError(response.getError());
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("普通礼品销售报表(周)处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	/**
	 * 普通礼品销售报表(月) 每月一日凌晨生成（统计每月初至月底）
	 * 
	 * @param vendorId 供应商ID 为空则导出全部数据
	 * @param vendorNm 供应商名称 为空则导出全部数据
	 */
	@Report(id = ReportConstant.JF_COMMONGIFT_SALE_06, name = "普通礼品销售月报表",
			type = ReportType.MONTH, ordertypeId = Contants.BUSINESS_TYPE_JF)
	public Response<Boolean> exportGiftSaleXlsForMonth(String batchDate, String vendorId, String vendorNm) {
		Response<Boolean> rps = new Response<>();
		try {
			
			Date startCommDate = BatchDateUtil.parseDate(batchDate);
			Date endCommDate = BatchDateUtil.addMonth(startCommDate, 1);
			QueryParams queryParams = new QueryParams();
			queryParams.setStartDate(startCommDate);
			queryParams.setEndDate(endCommDate);
			queryParams.setVendorId(vendorId);
			String reportName = monthReportName;
			if (Strings.isNullOrEmpty(vendorNm)) {
				vendorNm = "all";
			} else {
				reportName = monthReportName + "_" + vendorNm;
			}
			String filePath = ExcelUtilAgency.encodingOutputFilePath(monthOutputPath, reportName, batchDate);
			String outputFile = queryDataToExcels(queryParams, templatePath, filePath, reportName);
			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.JF_COMMONGIFT_SALE_06,
					monthReportName, batchDate, outputFile, vendorId, ReportConstant.MONTH_REPORT_TYPE);
			Response<Integer> response = reportManager.insertReportReg(reportModel);
			if (!response.isSuccess()) {
				rps.setError(response.getError());
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("普通礼品销售报表(月) 处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
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
	private String queryDataToExcels(QueryParams queryParam, String templatePath, String outPath, String titleName) throws IOException {
		queryParam.setLimit(size);
		List<String> outputFiles = Lists.newArrayList();
		String filePath = "";
		String newOutput = "";
		try {
			int index = 1;
			int pageNo = 1;// sheet页码
			Map<String, String> params = Maps.newHashMap();
			params.put("title", titleName);
			Pager<OrderBatchDto> pager = getPager(pageNo, queryParam);
			int totalPages = ReportTaskUtil.calTotalPages(pager.getTotal(), size);
			List<OrderBatchDto> goodsSaleDetails = null;
			while (pageNo <= totalPages) {
				if (totalPages > 1) {// 判断是否导出多份Excel导出
					newOutput = ExcelUtilAgency.addExcelNo(outPath, pageNo);
				} else {
					newOutput = outPath;
				}
				goodsSaleDetails = pager.getData();
				for (OrderBatchDto orderSubBatchDto : goodsSaleDetails) {
					orderSubBatchDto.setIndex(index++);
				}
				filePath = ExcelUtilAgency.exportExcel(goodsSaleDetails, templatePath, newOutput, params);
				outputFiles.add(filePath);
				pageNo++;// 下一页
				if (totalPages > 1 && pageNo <= totalPages) {// 获取下一份数据
					pager = getPager(pageNo, queryParam);
				}
			}
			if (outputFiles.size() > 1) {
				filePath = ExcelUtilAgency.replacePostfix(outPath);
				filePath = ExcelUtilAgency.zipFiles(filePath, outputFiles);
			}
		} catch (IOException e) {
			log.error("导出模版错误" + e.getMessage());
			throw e;
		}
		return filePath;
	}

	/**
	 * 获取数据
	 * 
	 * @param pageNo
	 * @param queryParam
	 * @return
	 */
	private Pager<OrderBatchDto> getPager(int pageNo, QueryParams queryParam) {
		queryParam.setOffset((pageNo - 1) * size);
		queryParam.setLimit(size);
		Response<Pager<OrderBatchDto>> result = reportManager.findCommonGiftSale(queryParam);
		if (!result.isSuccess()) {
			// 调用失败，判断异常情况，异常处理，日志写入
			log.error("获取数据出错:" + result.getError());
			throw new RuntimeException(result.getError());
		}
		Pager<OrderBatchDto> pager = result.getResult();
		return pager;
	}
}
