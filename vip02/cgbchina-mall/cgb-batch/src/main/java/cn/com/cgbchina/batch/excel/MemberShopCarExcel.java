package cn.com.cgbchina.batch.excel;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import cn.com.cgbchina.batch.manager.ReportManager;
import cn.com.cgbchina.batch.model.QueryParams;
import cn.com.cgbchina.batch.model.ReportModel;
import cn.com.cgbchina.batch.util.Report;
import cn.com.cgbchina.batch.util.ReportConstant;
import cn.com.cgbchina.batch.util.ReportTaskUtil;
import cn.com.cgbchina.common.utils.BatchDateUtil;
import cn.com.cgbchina.common.utils.ExcelUtilAgency;
import cn.com.cgbchina.item.dto.MemberCountBatchDto;

import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;

/**
 * * (会员报表)会员购物车报表
 * 
 * @author xiewl
 * @version 2016年6月16日 下午3:34:23
 */
@Slf4j
@Component
public class MemberShopCarExcel {

	@Value("${memberShopCar.tempPath}")
	private String templatePath; // 报表模版路径

	@Value("${memberShopCar.week.outpath}")
	private String weekOutputPath; // 周报表导出路径
	@Value("${memberShopCar.month.outpath}")
	private String monthOutputPath; // 月报表导出路径

	@Value("${memberShopCar.week.fileName}")
	private String weekReportName;// 周报表文件名
	@Value("${memberShopCar.month.fileName}")
	private String monthReportName;// 月报表文件名
	@Autowired
	private ReportManager reportManager;

	private static final String MONTH = "month";//查询数据标志 
	private static final String WEEK = "week";//查询数据标志
	
	/**
	 * 会员购物车周报表 excel 每周日凌晨生成（每周上周日至本周六）
	 * 
	 */
	@Report(id = ReportConstant.HY_SHOPCAR_05, name = "会员购物车周报表", type = Report.ReportType.WEEK)
	public Response<Boolean> exportWeekReport(String batchDate) {
		Response<Boolean> rps = new Response<>();
		try {
			Date endCommDate = BatchDateUtil.addDay(BatchDateUtil.parseDate(batchDate), 6);
			QueryParams queryParams = new QueryParams();
			queryParams.setEndDate(endCommDate);
			String filePath = ExcelUtilAgency.encodingOutputFilePath(weekOutputPath, weekReportName, batchDate);
			filePath = exportDataToExcels(endCommDate ,WEEK, filePath, weekReportName);
			
			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.HY_SHOPCAR_05, weekReportName,
					batchDate, filePath, ReportConstant.WEEK_REPORT_TYPE);
			Response<Integer> response = reportManager.insertReportReg(reportModel);
			if (!response.isSuccess()) {
				rps.setError(response.getError());
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("会员购物车周报表 处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	/**
	 * 会员购物车月报表excel 每月一日凌晨生成（每月初至月底）
	 * 
	 */
	@Report(id = ReportConstant.HY_SHOPCAR_06, name = "会员购物车月报表", type = Report.ReportType.MONTH)
	public Response<Boolean> exportMonthReport(String batchDate) {
		Response<Boolean> rps = new Response<>();
		try {
			Date batchDateTime = BatchDateUtil.addMonth(BatchDateUtil.parseDate(batchDate), 1);
			Date endCommDate = BatchDateUtil.addDay(batchDateTime, -1);
			QueryParams queryParams = new QueryParams();
			queryParams.setEndDate(endCommDate);
			String filePath = ExcelUtilAgency.encodingOutputFilePath(monthOutputPath, monthReportName, batchDate);
			filePath = exportDataToExcels(endCommDate ,MONTH, filePath, monthReportName);

			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.HY_SHOPCAR_06, monthReportName,
					batchDate, filePath, ReportConstant.MONTH_REPORT_TYPE);
			Response<Integer> response = reportManager.insertReportReg(reportModel);
			if (!response.isSuccess()) {
				rps.setError(response.getError());
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("会员购物车月报表 处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	/**
	 * 获取数据到Excel
	 *
	 * @param queryDate 查询时间
	 * @param queryType 查询条件
	 * @param outPath 导出路径
	 * @param titleName
	 * @return outputFiles 已修正的导出文件路径
	 * @throws IOException
	 */
	private String exportDataToExcels(Date queryDate ,String queryType, String outPath, String titleName) throws IOException {
		String filePath = "";
		try {
			Map<String, String> params = Maps.newHashMap();
			params.put("title", titleName);
			Response<List<MemberCountBatchDto>> result = reportManager.findMemberShopCarModel(queryDate,queryType);
			if (!result.isSuccess()) {
				// 调用失败，判断异常情况，异常处理，日志写入
				log.error("获取数据出错:" + result.getError());
				throw new RuntimeException(result.getError());
			}
			List<MemberCountBatchDto> memberShopCarDtos = result.getResult();
			filePath = ExcelUtilAgency.exportExcel(memberShopCarDtos, templatePath, outPath, params);
		} catch (IOException e) {
			log.error("导出模版错误" + e.getMessage());
			throw e;
		}
		return filePath;
	}
}
