package cn.com.cgbchina.batch.excel;

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
import cn.com.cgbchina.batch.dto.ExchangeStatisticsDto;
import cn.com.cgbchina.batch.model.QueryParams;

import com.google.common.collect.Maps;
import com.spirit.common.model.Response;

/**
 * 兑换统计月报表
 * 
 * @author xiewl
 */
@Slf4j
@Component
public class ExchangeStatisticsExcel {
	@Value("${exchangeStatistics.tempPath}")
	private String templatePath; // 报表模版路径

	@Value("${exchangeStatistics.month.outpath}")
	private String monthOutputPath; // 月报表导出路径

	@Value("${exchangeStatistics.month.fileName}")
	private String monthReportName;// 月报表文件名
	@Autowired
	private ReportManager reportManager;

	/**
	 * 兑换统计月报表 每月一日凌晨生成（每月初至月底）
	 * 
	 */
	@Report(id = ReportConstant.JF_EXCHANGE_STAT_08, name = "兑换统计月报表", type = Report.ReportType.MONTH)
	public Response<Boolean> exportMonthReport(String batchDate) {
		Response<Boolean> rps = new Response<>();
		try {
			Date startCommDate = BatchDateUtil.parseDate(batchDate);// 一个月前
			Date endCommDate = BatchDateUtil.addMonth(startCommDate, 1);// 到前一天
			QueryParams queryParams = new QueryParams();
			queryParams.setStartDate(startCommDate);
			queryParams.setEndDate(endCommDate);
			Response<List<ExchangeStatisticsDto>> result = reportManager.findExchangeStatistics(queryParams);
			if (!result.isSuccess()) {
				// 调用失败，判断异常情况，异常处理，日志写入
				log.error("获取数据出错:" + result.getError());
				rps.setError(result.getError());
				return rps;
			}
			List<ExchangeStatisticsDto> exchangeStatisticsDtos = result.getResult();
			Map<String, String> params = Maps.newHashMap();
			String filePath = ExcelUtilAgency.encodingOutputFilePath(monthOutputPath, monthReportName, batchDate);
			filePath = ExcelUtilAgency.exportExcel(exchangeStatisticsDtos, templatePath, filePath, params);

			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.JF_EXCHANGE_STAT_08, monthReportName,
					batchDate, filePath, ReportConstant.MONTH_REPORT_TYPE);
			Response<Integer> response = reportManager.insertReportReg(reportModel);
			if (!response.isSuccess()) {
				rps.setError(response.getError());
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("兑换统计月报表 处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}
}
