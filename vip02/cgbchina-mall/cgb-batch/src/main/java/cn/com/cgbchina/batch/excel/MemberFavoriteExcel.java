package cn.com.cgbchina.batch.excel;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import cn.com.cgbchina.item.dto.MemberCountBatchDto;
import cn.com.cgbchina.item.service.FavoriteService;
import cn.com.cgbchina.batch.model.ReportModel;

import com.google.common.collect.Maps;
import com.spirit.common.model.Response;

/**
 * 会员收藏夹报表 实现
 * 
 * @author huangcy on 2016年5月31日
 */
@Slf4j
@Component
public class MemberFavoriteExcel {
	@Resource
	private FavoriteService favoriteService;
	@Autowired
	private ReportManager reportManager;
	@Value("${memberGoodsFavorite.week.outpath}")
	private String weekOutputPath; // 周报表导出路径
	@Value("${memberGoodsFavorite.month.outpath}")
	private String monthOutputPath; // 月报表导出路径
	@Value("${memberGoodsFavorite.week.reportName}")
	private String weekReportName;// 周报表名称
	@Value("${memberGoodsFavorite.month.reportName}")
	private String monthReportName;// 月报表名称
	@Value("${memberGoodsFavorite.tempPath}")
	private String templatePath;// 模板路径

	@Report(id = ReportConstant.HY_FAVORITE_07, name = "会员收藏夹周报表", type = Report.ReportType.WEEK)
	public Response<Boolean> exportWeekReport(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {

			Date startDate = BatchDateUtil.parseDate(reportDate);
			String endDateTemp = BatchDateUtil.addDay(reportDate, 7); 
			Date endDate = BatchDateUtil.parseDate(endDateTemp);
			Map<String, Object> queryParams = Maps.newHashMap();
			queryParams.put("startDate", startDate);
			queryParams.put("endDate", endDate);
			String filePath = ExcelUtilAgency.encodingOutputFilePath(weekOutputPath, weekReportName, reportDate);
			String outputFile = queryDatasAndExport(queryParams, filePath, weekReportName);
			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.HY_FAVORITE_07, weekReportName,
					reportDate, outputFile, ReportConstant.WEEK_REPORT_TYPE);
			Response<Integer> response = reportManager.insertReportReg(reportModel);
			if (!response.isSuccess()) {
				rps.setError(response.getError());
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("会员收藏夹报表(周) 处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	/**
	 * 会员收藏夹月报表 每月一日凌晨生成（每月初至月底）
	 *
	 */
	@Report(id = ReportConstant.HY_FAVORITE_08, name = "会员收藏夹月报表", type = Report.ReportType.MONTH)
	public Response<Boolean> exportMonthReport(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			Date startDate = BatchDateUtil.parseDate(reportDate);
			Date endDate = BatchDateUtil.addMonth(startDate, 1);
			Map<String, Object> queryParams = Maps.newHashMap();
			queryParams.put("startDate", startDate);
			queryParams.put("endDate", endDate);
			String filePath = ExcelUtilAgency.encodingOutputFilePath(monthOutputPath, monthReportName, reportDate);
			String outputFile = queryDatasAndExport(queryParams, filePath, monthReportName);
			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.HY_FAVORITE_08, monthReportName,
					reportDate, outputFile, ReportConstant.MONTH_REPORT_TYPE);
			Response<Integer> response = reportManager.insertReportReg(reportModel);
			if (!response.isSuccess()) {
				rps.setError(response.getError());
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("会员收藏夹报表(月) 处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	private String queryDatasAndExport(Map<String, Object> queryParams, String outputPath, String titleName) {
		String filePath = "";
		// 导出数据
		try {
			Response<List<MemberCountBatchDto>> response = favoriteService.findTopGoodsFavorite(queryParams);
			if (!response.isSuccess()) {
				// 调用失败，判断异常情况，异常处理，日志写入
				log.error(response.getError());
				throw new RuntimeException(response.getError());
			}
			List<MemberCountBatchDto> memberCountBatchDtos = response.getResult();
			filePath = ExcelUtilAgency.exportExcel(titleName, memberCountBatchDtos, templatePath, outputPath);
		} catch (Exception e) {
			log.error(titleName + "导出失败", e);
			throw new RuntimeException(e);
		}
		return filePath;
	}

}
