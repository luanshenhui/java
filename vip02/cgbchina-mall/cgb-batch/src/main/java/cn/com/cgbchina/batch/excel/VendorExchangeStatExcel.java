package cn.com.cgbchina.batch.excel;

import java.util.Date;
import java.util.List;

import cn.com.cgbchina.batch.manager.ReportManager;
import com.google.common.base.Throwables;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.ExcelUtilAgency;
import cn.com.cgbchina.batch.util.Report;
import cn.com.cgbchina.batch.util.ReportConstant;
import cn.com.cgbchina.batch.util.ReportTaskUtil;
import cn.com.cgbchina.batch.util.Report.ReportType;
import cn.com.cgbchina.common.utils.BatchDateUtil;
import cn.com.cgbchina.batch.model.ReportModel;
import cn.com.cgbchina.batch.dto.VendorExchangeStatDto;
import cn.com.cgbchina.batch.model.QueryParams;

import com.spirit.common.model.Response;

/**
 * 商户兑换统计报表
 * 
 * @author huangcy on 2016年6月17日
 */
@Slf4j
@Component
public class VendorExchangeStatExcel {
	@Autowired
	private ReportManager reportManager;
	@Value("${vendorExchangeStat.month.outpath}")
	private String monthOutputPath; // 月报表导出路径
	@Value("${vendorExchangeStat.month.reportName}")
	private String monthReportName;// 月报表名称
	@Value("${vendorExchangeStat.tempPath}")
	private String templatePath;// 模板路径

	/**
	 * 商户兑换统计月报表 范围：每月月初至月底(月次，每月一日凌晨生成)
	 * 
	 * @param reportDate
	 */
	@Report(id = ReportConstant.JF_VENDOR_STAT_64, name = "商户兑换统计月报表", type = ReportType.MONTH)
	public Response<Boolean> exportVendorExchangeStatForMonth(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			Date startDate = BatchDateUtil.parseDate(reportDate);
			Date endDate = BatchDateUtil.addMonth(startDate, 1);
			QueryParams queryParams = new QueryParams();
			queryParams.setStartDate(startDate);
			queryParams.setEndDate(endDate);

			Response<List<VendorExchangeStatDto>> result = reportManager.findVendorExchangeStat(queryParams);
			if (!result.isSuccess()) {
				// 调用失败，判断异常情况，异常处理，日志写入
				rps.setError(result.getError());
				return rps;
			}

			List<VendorExchangeStatDto> vendorExchangeStatDtos = result.getResult();
			String filePath = ExcelUtilAgency.encodingOutputFilePath(monthOutputPath, monthReportName, reportDate);
			try {
				ExcelUtilAgency.exportExcel(monthReportName, vendorExchangeStatDtos, templatePath, filePath);
			} catch (Exception e) {
				log.error(monthReportName + "导出失败", e);
				throw new RuntimeException(e);
			}

			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.JF_VENDOR_STAT_64,
					monthReportName, reportDate, filePath, ReportConstant.MONTH_REPORT_TYPE);
			Response<Integer> response = reportManager.insertReportReg(reportModel);
			if (!response.isSuccess()) {
				rps.setError(response.getError());
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("商户兑换统计月报表处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}
}
