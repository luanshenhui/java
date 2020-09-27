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

import cn.com.cgbchina.batch.model.IntegralMbrConsume;
import cn.com.cgbchina.common.utils.ExcelUtilAgency;
import cn.com.cgbchina.batch.util.ReportConstant;
import cn.com.cgbchina.batch.util.ReportTaskUtil;
import cn.com.cgbchina.common.utils.BatchDateUtil;
import cn.com.cgbchina.batch.model.ReportModel;
import cn.com.cgbchina.batch.dto.IntegralExchangeDto;
import cn.com.cgbchina.batch.model.QueryParams;

import com.google.common.collect.Lists;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

/**
 * 积分兑换周报表（ALL常旅客会员消费）
 * 
 * @see IntegralMbrConsume
 * @author huangcy
 */
@Slf4j
@Component
public class IntegralMbrConsumeExcel {
	@Autowired
	private ReportManager reportManager;
	@Value("${integralMbrConsume.week.outpath}")
	private String weekOutputPath; // 周报表导出路径
	@Value("${integralMbrConsume.month.outpath}")
	private String monthOutputPath; // 月报表导出路径
	@Value("${integralMbrConsume.week.reportName}")
	private String weekReportName;// 周报表名称
	@Value("${integralMbrConsume.month.reportName}")
	private String monthReportName;// 月报表名称
	@Value("${integralMbrConsume.tempPath}")
	private String templatePath;// 模板路径
	@Value("${excel.MaxNum}")
	private int size;
	private Map<String, String> airlineTypes;

	@Report(id = ReportConstant.JF_ALL_CONSUME_14, name = "积分兑换周报表（ALL常旅客会员消费）", type = Report.ReportType.WEEK)
	public Response<Boolean> exportWeekReport(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			Date startDate = BatchDateUtil.parseDate(reportDate);
			String endDateTemp = BatchDateUtil.addDay(reportDate, 7); 
			Date endDate = BatchDateUtil.parseDate(endDateTemp);
			QueryParams queryParams = ReportTaskUtil.initParams(startDate, endDate,
					ReportConstant.GoodsXids.ALL_MEMBER_CONSUME);
			airlineTypes = ReportTaskUtil.initAviationTypes();

			for (String aviationType : airlineTypes.keySet()) {
				queryParams.setAviationType(aviationType);
				String aviationTypeName = airlineTypes.get(aviationType);
				String reportName = weekReportName.replace("ALL", aviationTypeName);

				String filePath = ExcelUtilAgency.encodingOutputFilePath(weekOutputPath, reportName, reportDate);
				String outputFile = queryDatasAndExport(queryParams, filePath, reportName);
				// 插入一条报表记录
				ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.JF_ALL_CONSUME_14,
						weekReportName, reportDate, outputFile, ReportConstant.WEEK_REPORT_TYPE);
				reportModel.setAirlineType(aviationType);
				Response<Integer> response = reportManager.insertReportReg(reportModel);
				if (!response.isSuccess()) {
					rps.setError(response.getError());
					return rps;
				}
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("积分兑换周报表（ALL常旅客会员消费）(周) 处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	@Report(id = ReportConstant.JF_ALL_CONSUME_50, name = "积分兑换月报表（ALL常旅客会员消费）", type = Report.ReportType.MONTH)
	public Response<Boolean> exportMonthReport(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			Date startDate = BatchDateUtil.parseDate(reportDate);
			Date endDate = BatchDateUtil.addMonth(startDate, 1);
			QueryParams queryParams = ReportTaskUtil.initParams(startDate, endDate,
					ReportConstant.GoodsXids.ALL_MEMBER_CONSUME);
			airlineTypes = ReportTaskUtil.initAviationTypes();

			for (String aviationType : airlineTypes.keySet()) {
				queryParams.setAviationType(aviationType);
				String aviationTypeName = airlineTypes.get(aviationType);
				String reportName = monthReportName.replace("ALL", aviationTypeName);

				String filePath = ExcelUtilAgency.encodingOutputFilePath(monthOutputPath, reportName, reportDate);
				String outputFile = queryDatasAndExport(queryParams, filePath, reportName);
				// 插入一条报表记录
				ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.JF_ALL_CONSUME_50,
						monthReportName, reportDate, outputFile, ReportConstant.MONTH_REPORT_TYPE);
				reportModel.setAirlineType(aviationType);
				Response<Integer> response = reportManager.insertReportReg(reportModel);
				if (!response.isSuccess()) {
					rps.setError(response.getError());
					return rps;
				}
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("积分兑换周报表（ALL常旅客会员消费）(月) 处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	private String queryDatasAndExport(QueryParams queryParams, String outputPath, String titleName) {
		List<String> outputFiles = Lists.newArrayList();
		String filePath = "";
		try {
			int index = 1;
			int pageNo = 1;// 页码
			queryParams.setFirstVisit(true);// 第一次取数
			Pager<IntegralExchangeDto> pager = getPager(pageNo, queryParams);
			int totalPages = ReportTaskUtil.calTotalPages(pager.getTotal(), size);
			while (pageNo <= totalPages) {
				// 处理路径是否加文件序号
				String newOutput = totalPages > 1 ? ExcelUtilAgency.addExcelNo(outputPath, pageNo) : outputPath;
				List<IntegralExchangeDto> integralExchangeDtos = pager.getData();
				for (IntegralExchangeDto integralExchangeDto : integralExchangeDtos) {
					integralExchangeDto.setIndex(index++);
					String createDate = BatchDateUtil.fmtDateTime(integralExchangeDto.getCreateTime());
					integralExchangeDto.setCreateDate(createDate);

					String aviationTypeNm = airlineTypes.get(integralExchangeDto.getVirtualAviationType());
					integralExchangeDto.setVirtualAviationType(aviationTypeNm);
				}
				filePath = ExcelUtilAgency.exportExcel(titleName, integralExchangeDtos, templatePath, newOutput);
				outputFiles.add(filePath);
				pageNo++;
				if (pageNo <= totalPages) {// 获取下一份数据
					queryParams.setFirstVisit(false);// 不是第一次取数
					pager = getPager(pageNo, queryParams);
				}
			}
			if (outputFiles.size() > 1) {
				filePath = ExcelUtilAgency.replacePostfix(outputPath);
				filePath = ExcelUtilAgency.zipFiles(filePath, outputFiles);
			}
		} catch (Exception e) {
			log.error("导出模版错误" + e.getMessage());
			throw new RuntimeException(e);
		}
		return filePath;
	}

	private Pager<IntegralExchangeDto> getPager(int pageNo, QueryParams queryParams) {
		PageInfo pageInfo = new PageInfo(pageNo, size);
		queryParams.setOffset(pageInfo.getOffset());
		queryParams.setLimit(pageInfo.getLimit());
		Response<Pager<IntegralExchangeDto>> result = reportManager.findJFOrderByGoodsIds(queryParams);
		if (!result.isSuccess()) {
			// 调用失败，判断异常情况，异常处理，日志写入
			log.error(result.getError());
			throw new RuntimeException(result.getError());
		}
		Pager<IntegralExchangeDto> pager = result.getResult();
		return pager;
	}

}
