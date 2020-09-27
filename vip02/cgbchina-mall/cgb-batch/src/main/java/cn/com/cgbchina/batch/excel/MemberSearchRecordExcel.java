package cn.com.cgbchina.batch.excel;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import cn.com.cgbchina.batch.manager.ReportManager;
import cn.com.cgbchina.batch.util.Report;
import com.google.common.base.Throwables;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;

import cn.com.cgbchina.common.utils.ExcelUtilAgency;
import cn.com.cgbchina.batch.util.ReportConstant;
import cn.com.cgbchina.batch.util.ReportTaskUtil;
import cn.com.cgbchina.common.utils.BatchDateUtil;
import cn.com.cgbchina.batch.model.ReportModel;
import cn.com.cgbchina.batch.dto.MemberSearchDto;
import cn.com.cgbchina.batch.model.QueryParams;

import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import org.springframework.stereotype.Component;

/**
 * (会员报表)会员搜索记录报表
 * 
 * @author xiewl
 * @version 2016年6月16日 下午3:18:54
 */
@Slf4j
@Component
public class MemberSearchRecordExcel {

	@Value("${memberSearchRecord.tempPath}")
	private String templatePath; // 报表模版路径

	@Value("${memberSearchRecord.week.outpath}")
	private String weekOutputPath; // 周报表导出路径
	@Value("${memberSearchRecord.month.outpath}")
	private String monthOutputPath; // 月报表导出路径

	@Value("${memberSearchRecord.week.fileName}")
	private String weekReportName;// 周报表文件名
	@Value("${memberSearchRecord.month.fileName}")
	private String monthReportName;// 月报表文件名
	@Autowired
	private ReportManager reportManager;

	/**
	 * 会员搜索记录周报表 excel 每周日凌晨生成（每周上周日至本周六）
	 * 
	 */
	@Report(id = ReportConstant.HY_SEARCH_03, name = "会员搜索记录周报表", type = Report.ReportType.WEEK)
	public Response<Boolean> exportWeekReport(String batchDate) {
		Response<Boolean> rps = new Response<>();
		try {
			Date startDate = BatchDateUtil.parseDate(batchDate);
			String endDateTemp = BatchDateUtil.addDay(batchDate, 7); 
			Date endDate = BatchDateUtil.parseDate(endDateTemp);
			QueryParams queryParams = new QueryParams();
			queryParams.setStartDate(startDate);
			queryParams.setEndDate(endDate);
			String filePath = ExcelUtilAgency.encodingOutputFilePath(weekOutputPath, weekReportName, batchDate);
			filePath = queryDataToExcels(queryParams, filePath, weekReportName);

			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.HY_SEARCH_03, weekReportName,
					batchDate, filePath, ReportConstant.WEEK_REPORT_TYPE);
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
	 * 会员搜索记录月报表 每月一日凌晨生成（每月初至月底）
	 * 
	 */
	@Report(id = ReportConstant.HY_SEARCH_04, name = "会员搜索记录月报表", type = Report.ReportType.MONTH)
	public Response<Boolean> exportMonthReport(String batchDate) {
		Response<Boolean> rps = new Response<>();
		try {

			Date startDate = BatchDateUtil.parseDate(batchDate);
			Date endDate = BatchDateUtil.addMonth(startDate, 1);
			QueryParams queryParams = new QueryParams();
			queryParams.setStartDate(startDate);
			queryParams.setEndDate(endDate);
			String filePath = ExcelUtilAgency.encodingOutputFilePath(monthOutputPath, monthReportName, batchDate);
			filePath = queryDataToExcels(queryParams, filePath, monthReportName);

			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.HY_SEARCH_04, monthReportName,
					batchDate, filePath, ReportConstant.MONTH_REPORT_TYPE);
			Response<Integer> response = reportManager.insertReportReg(reportModel);
			if (!response.isSuccess()) {
				rps.setError(response.getError());
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("商品销售明细月报表处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
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
			Response<List<MemberSearchDto>> result = reportManager.findMemberSearchRecord(queryParam);
			if (!result.isSuccess()) {
				// 调用失败，判断异常情况，异常处理，日志写入
				log.error("获取数据出错:" + result.getError());
				throw new RuntimeException(result.getError());
			}
			List<MemberSearchDto> memberSearchDtos = result.getResult();
			filePath = ExcelUtilAgency.exportExcel(memberSearchDtos, templatePath, outPath, params);
		} catch (IOException e) {
			log.error("导出模版错误" + e.getMessage());
			throw e;
		}
		return filePath;
	}
}
