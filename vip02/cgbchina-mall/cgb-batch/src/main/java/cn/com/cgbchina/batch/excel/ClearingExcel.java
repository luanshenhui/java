package cn.com.cgbchina.batch.excel;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;

import cn.com.cgbchina.batch.dto.ClearingDto;
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
 * 结算报表（积分商城）
 * 
 * @author xiewl
 */
@Slf4j
@Component
public class ClearingExcel {

	@Value("${clearing.tempPath}")
	private String templatePath; // 报表模版路径

	@Value("${clearing.day.outpath}")
	private String dayOutputPath; // 日报表导出路径

	@Value("${clearing.day.fileName}")
	private String dayReportName;// 日报表文件名

	@Autowired
	private ReportManager reportManager;

	/**
	 * 结算日报表 每日凌晨生成（统计每日0点至24点）
	 */
	@Report(id = ReportConstant.JF_CLEARING_03, name = "结算日报表", type = ReportType.DAY)
	public Response<Boolean> exportDayReport(String batchDate) {
		Response<Boolean> rps = new Response<>();
		try {
			Date startCommDate = BatchDateUtil.parseDate(batchDate);
			String endDate = BatchDateUtil.addDay(batchDate, 1); 
			Date endCommDate = BatchDateUtil.parseDate(endDate);
			QueryParams queryParams = new QueryParams();
			queryParams.setStartDate(startCommDate);
			queryParams.setEndDate(endCommDate);
			String filePath = ExcelUtilAgency.encodingOutputFilePath(dayOutputPath, dayReportName, batchDate);
			filePath = queryDataToExcels(queryParams, filePath, dayReportName);
			// 插入一条报表记录
			ReportModel reportModel = ReportTaskUtil.createReportModel(ReportConstant.JF_CLEARING_03, dayReportName,
					batchDate, filePath, ReportConstant.DAY_REPORT_TYPE);
			Response<Integer> response = reportManager.insertReportReg(reportModel);

			if (!response.isSuccess()) {
				rps.setError(response.getError());
				return rps;
			}
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			log.error("结算报表（积分商城）处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
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
			int index = 1;
			Map<String, String> params = Maps.newHashMap();
			params.put("title", titleName);
			Response<List<ClearingDto>> result = reportManager.findClearingDetail(queryParam);
			if (!result.isSuccess()) {
				// 调用失败，判断异常情况，异常处理，日志写入
				log.error("获取数据出错:" + result.getError());
				throw new RuntimeException(result.getError());
			}
			List<ClearingDto> clearingDtos = result.getResult();
			for (ClearingDto clearingDto : clearingDtos) {
				clearingDto.setIndex(index++);
			}
			filePath = ExcelUtilAgency.exportExcel(clearingDtos, templatePath, outPath, params);
		} catch (IOException e) {
			log.error("导出模版错误" + e.getMessage());
			throw e;
		}
		return filePath;
	}

}
