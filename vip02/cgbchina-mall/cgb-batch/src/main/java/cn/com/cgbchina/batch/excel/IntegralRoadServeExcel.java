package cn.com.cgbchina.batch.excel;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import cn.com.cgbchina.batch.manager.ReportManager;
import cn.com.cgbchina.batch.util.Report;
import com.google.common.base.Throwables;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import cn.com.cgbchina.batch.model.IntegralRoadRescue;
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
 * 积分兑换周报表（易车公司车主卡道路救援）
 * 
 * @see IntegralRoadRescue
 * @author huangcy on 2016年5月10日
 */
@Slf4j
@Component
public class IntegralRoadServeExcel {
	@Autowired
	private ReportManager reportManager;
	@Value("${integralRoadRescue.week.outpath}")
	private String weekOutputPath; // 周报表导出路径
	@Value("${integralRoadRescue.week.reportName}")
	private String weekReportName;
	@Value("${integralRoadRescue.tempPath}")
	private String templatePath;
	@Value("${excel.MaxNum}")
	private int size;

	@Report(id = ReportConstant.JF_ROAD_RESUCE_15, name = "积分兑换周报表（车主卡道路救援）", type = Report.ReportType.WEEK)
	public Response<Boolean> exportWeekReport(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			Date startDate = BatchDateUtil.parseDate(reportDate);
			String endDateTemp = BatchDateUtil.addDay(reportDate, 7); 
			Date endDate = BatchDateUtil.parseDate(endDateTemp);
			QueryParams queryParams = ReportTaskUtil.initParams(startDate, endDate,
					ReportConstant.GoodsXids.CRECORDER_ROAD_RESECUE);

			String filePath = ExcelUtilAgency.encodingOutputFilePath(weekOutputPath, weekReportName, reportDate);
			String outputFile = queryDatasAndExport(queryParams, filePath, weekReportName);
			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.JF_ROAD_RESUCE_15, weekReportName,
					reportDate, outputFile, ReportConstant.WEEK_REPORT_TYPE);
			Response<Integer> response = reportManager.insertReportReg(reportModel);
			if (!response.isSuccess()) {
				rps.setError(response.getError());
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("积分兑换周报表（易车公司车主卡道路救援）(周) 处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
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
			Pager<IntegralExchangeDto> pager = getPager(pageNo, queryParams);
			int totalPages = ReportTaskUtil.calTotalPages(pager.getTotal(), size);
			while (pageNo <= totalPages) {
				// 处理路径是否加文件序号
				String newOutput = totalPages > 1 ? ExcelUtilAgency.addExcelNo(outputPath, pageNo) : outputPath;
				List<IntegralExchangeDto> integralExchangeDtos = pager.getData();
				for (IntegralExchangeDto integralExchangeDto : integralExchangeDtos) {
					integralExchangeDto.setIndex(index++);
					// 隐藏证件号后四位
					String contIdCard = integralExchangeDto.getContIdCard();
					if (contIdCard != null && contIdCard.length() > 4) {
						contIdCard = contIdCard.substring(0, contIdCard.length() - 4) + "****";
					}
					integralExchangeDto.setContIdCard(contIdCard);
					// 取末四位卡号
					String cardNo = integralExchangeDto.getEntryCard();
					if (cardNo != null && cardNo.length() > 4) {
						cardNo = cardNo.substring(cardNo.length() - 4);
					}
					integralExchangeDto.setEntryCard(cardNo);

					String createDate = BatchDateUtil.fmtDate(integralExchangeDto.getCreateTime());
					String startDate = BatchDateUtil.addDay(createDate, 1);// 生效日
					integralExchangeDto.setCreateDate(startDate);

					Date endDate = BatchDateUtil.addYear(integralExchangeDto.getCreateTime(), 1, 0, 0);
					String expDate = BatchDateUtil.fmtDate(endDate);
					integralExchangeDto.setExpDate(expDate);
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
		} catch (IOException e) {
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
