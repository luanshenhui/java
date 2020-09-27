package cn.com.cgbchina.batch.excel;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

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
import cn.com.cgbchina.common.utils.BatchDateUtil;
import cn.com.cgbchina.common.utils.ExcelUtilAgency;
import lombok.extern.slf4j.Slf4j;

/**
 * 商品销售明细报表（广发商城管理平台）
 * 
 * @author xiewl
 *
 */
@Slf4j
@Component
public class GoodsSaleDetailExcel {

	@Value("${goodsSaleDatail.tempPath}")
	private String templatePath; // 报表模版路径

	@Value("${goodsSaleDatail.day.outpath}")
	private String dayOutputPath; // 日报表导出路径
	@Value("${goodsSaleDatail.week.outpath}")
	private String weekOutputPath; // 周报表导出路径
	@Value("${goodsSaleDatail.month.outpath}")
	private String monthOutputPath; // 月报表导出路径

	@Value("${goodsSaleDatail.day.fileName}")
	private String dayReportName;// 日报表文件名
	@Value("${goodsSaleDatail.week.fileName}")
	private String weekReportName;// 周报表文件名
	@Value("${goodsSaleDatail.month.fileName}")
	private String monthReportName;// 月报表文件名

	@Value("${excel.MaxNum}")
	private int size;
	@Autowired
	private ReportManager reportManager;

	/**
	 * 商品销售明细日报表 excel 每日凌晨生成（统计每日0点至24点）
	 * 
	 * @param batchDate 跑批时间 一般是当天
	 */
	@Report(id = ReportConstant.YG_GOODS_SALE_09, name = "商品销售明细日报表", type = ReportType.DAY)
	public Response<Boolean> exportDayReport(String batchDate) {
		Response<Boolean> rps = new Response<>();
		try {
			Date startCommDate = BatchDateUtil.parseDate(batchDate);
			String endDate = BatchDateUtil.addDay(batchDate, 1); 
			Date endCommDate = BatchDateUtil.parseDate(endDate);
			QueryParams queryParams = new QueryParams();
			queryParams.setStartDate(startCommDate);
			queryParams.setEndDate(endCommDate);
			String filePath = ExcelUtilAgency.encodingOutputFilePath(dayOutputPath, dayReportName, batchDate);
			String outputFile = queryDataToExcels(queryParams, filePath, dayReportName);
			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.YG_GOODS_SALE_09, dayReportName,
					batchDate, outputFile, ReportConstant.DAY_REPORT_TYPE);
			Response<Integer> response = reportManager.insertReportReg(reportModel);
			if (!response.isSuccess()) {
				rps.setError(response.getError());
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("商品销售明细日报表 处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	/**
	 * 商品销售明细周报表 excel 每周日凌晨生成（每周上周日至本周六）
	 * 
	 * @param batchDate 跑批时间 一般是本周日
	 */
	@Report(id = ReportConstant.YG_GOODS_SALE_13, name = "商品销售明细周报表", type = ReportType.WEEK)
	public Response<Boolean> exportWeekReport(String batchDate) {
		Response<Boolean> rps = new Response<>();
		try {
			Date startCommDate = BatchDateUtil.parseDate(batchDate);
			String endDate = BatchDateUtil.addDay(batchDate, 7);
			Date endCommDate = BatchDateUtil.parseDate(endDate);
			QueryParams queryParams = new QueryParams();
			queryParams.setStartDate(startCommDate);
			queryParams.setEndDate(endCommDate);
			String filePath = ExcelUtilAgency.encodingOutputFilePath(weekOutputPath, weekReportName, batchDate);
			String outputFile = queryDataToExcels(queryParams, filePath, weekReportName);
			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.YG_GOODS_SALE_13, weekReportName,
					batchDate, outputFile, ReportConstant.WEEK_REPORT_TYPE);
			Response<Integer> response = reportManager.insertReportReg(reportModel);
			if (!response.isSuccess()) {
				rps.setError(response.getError());
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("商品销售明细周报表 处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	/**
	 * 商品销售明细月报表excel 每月一日凌晨生成（上个月初至月底）
	 * 
	 * @param batchDate 跑批时间 一般是当月1号
	 */
	@Report(id = ReportConstant.YG_GOODS_SALE_17, name = "商品销售明细月报表", type = ReportType.MONTH)
	public Response<Boolean> exportMonthReport(String batchDate) {
		Response<Boolean> rps = new Response<>();
		try {
			Date startCommDate = BatchDateUtil.parseDate(batchDate);
			Date endCommDate = BatchDateUtil.addMonth(startCommDate, 1);
			QueryParams queryParams = new QueryParams();
			queryParams.setStartDate(startCommDate);
			queryParams.setEndDate(endCommDate);
			String filePath = ExcelUtilAgency.encodingOutputFilePath(monthOutputPath, monthReportName, batchDate);
			String outputFile = queryDataToExcels(queryParams, filePath, monthReportName);
			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.YG_GOODS_SALE_17, monthReportName,
					batchDate, outputFile, ReportConstant.MONTH_REPORT_TYPE);
			Response<Integer> response = reportManager.insertReportReg(reportModel);
			if (!response.isSuccess()) {
				rps.setError(response.getError());
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("商品销售明细月报表 处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
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
					String ordertype_id = orderSubBatchDto.getPaywayNm();
					String paywayNm = "YG".equals(ordertype_id) ? "一期" : "分期";
					orderSubBatchDto.setPaywayNm(paywayNm);
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
		Response<Pager<OrderBatchDto>> result = reportManager.findGoodsSaleDetail(queryParam);
		if (!result.isSuccess()) {
			// 调用失败，判断异常情况，异常处理，日志写入
			// log.error()
			throw new RuntimeException(result.getError());
		}
		Pager<OrderBatchDto> pager = result.getResult();
		return pager;
	}
}
