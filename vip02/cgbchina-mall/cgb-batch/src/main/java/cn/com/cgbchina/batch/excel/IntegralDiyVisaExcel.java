package cn.com.cgbchina.batch.excel;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.google.common.base.Throwables;
import com.spirit.common.model.Response;

import cn.com.cgbchina.batch.dto.IntegralExchangeDto;
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
 * 积分兑换报表（DIY卡免还款签账额）
 * 
 * @author huangcy on 2016年6月3日
 */
@Slf4j
@Component
public class IntegralDiyVisaExcel {
	@Autowired
	private ReportManager reportManager;
	@Value("${integralDiyVisa.day.outpath}")
	private String dayOutputPath; // 日报表导出路径
	@Value("${integralDiyVisa.day.reportName}")
	private String dayReportName;// 日报表名称
	@Value("${integralDiyVisa.tempPath}")
	private String templatePath;// 模板路径
	@Value("${excel.MaxNum}")
	private int size;

	@Report(id = ReportConstant.JF_DIY_VISA_34, name = "积分兑换日报表（DIY卡免还款签帐额）", type = ReportType.DAY)
	public Response<Boolean> exportDayReport(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			String beginDate = BatchDateUtil.addDay(reportDate, -1);
			Date startTime = BatchDateUtil.parseDate(beginDate + "180000", BatchDateUtil.FMT_DATE_TIME);
			Date endTime = BatchDateUtil.parseDate(reportDate + "180000", BatchDateUtil.FMT_DATE_TIME);
			QueryParams queryParams = ReportTaskUtil.initParams(startTime, endTime,
					ReportConstant.GoodsXids.DIY_VISA_FREE);

			String filePath = ExcelUtilAgency.encodingOutputFilePath(dayOutputPath, dayReportName, reportDate);
			String outputFile = queryDatasAndExport(queryParams, filePath, dayReportName);

			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.JF_DIY_VISA_34, dayReportName,
					reportDate, outputFile, ReportConstant.DAY_REPORT_TYPE);
			Response<Integer> response = reportManager.insertReportReg(reportModel);
			if (!response.isSuccess()) {
				rps.setError(response.getError());
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("积分兑换报表（DIY卡免还款签账额） 处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	private String queryDatasAndExport(QueryParams queryParams, String outputPath, String titleName) {
		String filePath = "";
		try {
			Response<List<IntegralExchangeDto>> response = reportManager.findJFOrderOfDayByGoodsIds(queryParams);
			if (!response.isSuccess()) {
				// 调用失败，判断异常情况，异常处理，日志写入
				log.error(response.getError());
				throw new RuntimeException(response.getError());
			}
			int index = 1;
			BigDecimal totalMoney = new BigDecimal(0);
			List<IntegralExchangeDto> integralExchangeDtos = response.getResult();
			for (IntegralExchangeDto integralExchangeDto : integralExchangeDtos) {
				integralExchangeDto.setIndex(index++);

				String createDate = BatchDateUtil.fmtDate(integralExchangeDto.getCreateTime());
				integralExchangeDto.setCreateDate(createDate);
				// 隐藏证件号后四位
				String contIdCard = integralExchangeDto.getContIdCard();
				if (contIdCard != null && contIdCard.length() > 4) {
					contIdCard = contIdCard.substring(0, contIdCard.length() - 4) + "****";
				}
				integralExchangeDto.setContIdCard(contIdCard);

				totalMoney = totalMoney.add(integralExchangeDto.getVirtualAllPrice());
			}
			// 最后一行加总金额
			IntegralExchangeDto integralExchangeDto = new IntegralExchangeDto();
			integralExchangeDto.setGoodsNm("总金额");
			integralExchangeDto.setVirtualAllPrice(totalMoney);
			integralExchangeDtos.add(integralExchangeDto);

			filePath = ExcelUtilAgency.exportExcel(titleName, integralExchangeDtos, templatePath, outputPath);
		} catch (Exception e) {
			log.error(titleName + "导出失败", e);
			throw new RuntimeException(e);
		}
		return filePath;
	}
}
