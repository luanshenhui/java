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
import org.springframework.stereotype.Component;

import cn.com.cgbchina.common.utils.ExcelUtilAgency;
import cn.com.cgbchina.batch.util.ReportConstant;
import cn.com.cgbchina.batch.util.ReportTaskUtil;
import cn.com.cgbchina.common.utils.BatchDateUtil;
import cn.com.cgbchina.batch.model.ReportModel;
import cn.com.cgbchina.batch.dto.MemberNumDto;
import cn.com.cgbchina.batch.model.QueryParams;

import com.google.common.collect.Maps;
import com.spirit.common.model.Response;

/**
 * (会员报表)会员总数报表
 * 
 * @author xiewl
 * @version 2016年6月16日 下午2:58:48
 */
@Slf4j
@Component
public class MemberNumExcel {

	@Value("${memberNum.tempPath}")
	private String templatePath; // 报表模版路径

	@Value("${memberNum.week.outpath}")
	private String weekOutputPath; // 周报表导出路径
	@Value("${memberNum.month.outpath}")
	private String monthOutputPath; // 月报表导出路径

	@Value("${memberNum.week.fileName}")
	private String weekReportName;// 周报表文件名
	@Value("${memberNum.month.fileName}")
	private String monthReportName;// 月报表文件名
	@Autowired
	private ReportManager reportManager;
	/**
	 * 商品销售明细周报表 excel 每周日凌晨生成（每周上周日至本周六）
	 * 
	 * @throws IOException
	 */
	@Report(id = ReportConstant.HY_TOTAL_01, name = "会员总数周报表", type = Report.ReportType.WEEK)
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
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.HY_TOTAL_01, weekReportName,
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
	 * 会员总数月报表 每月一日凌晨生成（每月初至月底）
	 * 
	 * @throws IOException
	 */
	@Report(id = ReportConstant.HY_TOTAL_02, name = "会员总数月报表", type = Report.ReportType.MONTH)
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
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.HY_TOTAL_02, monthReportName,
					batchDate, filePath, ReportConstant.MONTH_REPORT_TYPE);
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
		String filePath = "";
		try {
			Map<String, String> params = Maps.newHashMap();
			params.put("title", titleName);
			Response<List<MemberNumDto>> result = reportManager.findMemberNumDto(queryParam);
			if (!result.isSuccess()) {
				// 调用失败，判断异常情况，异常处理，日志写入
				log.error("获取数据出错:" + result.getError());
				throw new RuntimeException(result.getError());
			}
			List<MemberNumDto> memberNumDtos = result.getResult();
			filePath = ExcelUtilAgency.exportExcel(memberNumDtos, templatePath, outPath, params);
		} catch (IOException e) {
			log.error("导出模版错误" + e.getMessage());
			throw e;
		}
		return filePath;
	}
}
