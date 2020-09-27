package cn.com.cgbchina.batch.excel;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.google.common.base.Strings;
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
import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.BatchDateUtil;
import cn.com.cgbchina.common.utils.ExcelUtilAgency;
import cn.com.cgbchina.common.utils.StringUtils;
import lombok.extern.slf4j.Slf4j;

/**
 * 分期请款报表（广发商城管理平台）
 * 
 * @author xiewl
 */
@Slf4j
@Component
public class StageReqCashReportExcel {

	@Value("${stageReqCash.tempPath}")
	private String templatePath; // 报表模版路径
	@Value("${stageReqCash.outpath}")
	private String dayOutputPath; // 报表导出路径
	@Value("${stageReqCash.fileName}")
	private String dayReportName;// 报表文件名
	@Value("${excel.MaxNum}")
	private int size;
	@Autowired
	private ReportManager reportManager;

	/**
	 * 分期请款报表 每日凌晨生成(生成当日从前天18点至昨天18点)
	 * 
	 */
	@Report(id = ReportConstant.YG_STAGE_REQCASH_02, name = "分期请款报表",
			type = ReportType.DAY)
	public Response<Boolean> exportStageCashoutForDay(String batchDate) {
		Response<Boolean> rps = new Response<>();
		try {

			String beginDate = BatchDateUtil.addDay(batchDate, -1);
			Date startTime = BatchDateUtil.parseDate(beginDate + "180000", BatchDateUtil.FMT_DATE_TIME);
			Date endTime = BatchDateUtil.parseDate(batchDate + "180000", BatchDateUtil.FMT_DATE_TIME);
			QueryParams queryParams = new QueryParams();
			queryParams.setStartDate(startTime);
			queryParams.setEndDate(endTime);
			// bug 供应商应该合并，不应分商户
//			if (StringUtils.notEmpty(vendorId)) {
//				queryParams.setVendorId(vendorId);
//			}
//			String reportName = dayReportName;
//			if (Strings.isNullOrEmpty(vendorNm)) {
//				vendorNm = "all";
//			} else {
//				reportName = dayReportName + "_" + vendorNm;
//			}
			String filePath = ExcelUtilAgency.encodingOutputFilePath(dayOutputPath, dayReportName, batchDate);
			String outputFile = queryDataToExcels(queryParams, filePath, dayReportName);
			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.YG_STAGE_REQCASH_02,
					dayReportName, batchDate, outputFile, ReportConstant.DAY_REPORT_TYPE);
			Response<Integer> response = reportManager.insertReportReg(reportModel);
			if (!response.isSuccess()) {
				rps.setError(response.getError());
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("分期请款报表处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
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
			List<OrderBatchDto> reqCashDetails = null;
			while (pageNo <= totalPages) {
				if (totalPages > 1) {// 判断是否导出多份Excel导出
					newOutput = outPath + "_" + pageNo;
				} else {
					newOutput = outPath;
				}
				reqCashDetails = pager.getData();
				for (OrderBatchDto orderSubBatchDto : reqCashDetails) {
					orderSubBatchDto.setIndex(index++);
					String ordertype_id = orderSubBatchDto.getPaywayNm();
					String paywayNm = "YG".equals(ordertype_id) ? "一期" : "分期";
					orderSubBatchDto.setPaywayNm(paywayNm);
				}
				filePath = ExcelUtilAgency.exportExcel(reqCashDetails, templatePath, newOutput, params);
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
		Response<Pager<OrderBatchDto>> result = reportManager.findStageReqCash(queryParam);
		if (!result.isSuccess()) {
			// 调用失败，判断异常情况，异常处理，日志写入
			// log.error()
			throw new RuntimeException(result.getError());
		}
		Pager<OrderBatchDto> pager = result.getResult();
		return pager;
	}
}
