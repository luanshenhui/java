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

import cn.com.cgbchina.batch.model.IntegralInsurance;
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
 * 保险积分兑换报表 1、积分兑换报表（中国人寿保险标准卡旅行意外） 2、积分兑换报表（中国人寿保险标准卡重大疾病） 3、积分兑换报表（中国人寿保险真情卡女性疾病） 4、积分兑换报表（中国人寿保险真情卡旅行意外）
 * 5、积分兑换报表（中国人寿保险真情卡重大疾病） 6、积分兑换报表（中国人寿保险真情卡购物保障） 7、积分兑换报表（中国人寿保险车主卡驾驶员意外） 8、积分兑换报表（中国人民财产保险车主卡旅行交通意外）
 * 9、积分兑换报表（爱·宠普卡宠物饲养责任保险）
 * 
 * @see IntegralInsurance
 * @author huangcy on 2016年5月10日
 */
@Slf4j
@Component
public class IntegralInsuranceExcel {
	@Autowired
	private ReportManager reportManager;
	// 积分兑换报表（中国人寿保险标准卡旅行意外）
	@Value("${scTravel.week.outpath}")
	private String scTravelWeekOutputPath; // 周报表导出路径
	@Value("${scTravel.month.outpath}")
	private String scTravelMonthOutputPath; // 月报表导出路径
	@Value("${scTravel.week.reportName}")
	private String scTravelWeekRptName;
	@Value("${scTravel.month.reportName}")
	private String scTravelMonthRptName;
	// 积分兑换报表（中国人寿保险标准卡重大疾病）
	@Value("${scDisease.week.outpath}")
	private String scDiseaseWeekOutputPath; // 周报表导出路径
	@Value("${scDisease.month.outpath}")
	private String scDiseaseMonthOutputPath; // 月报表导出路径
	@Value("${scDisease.week.reportName}")
	private String scDiseaseWeekRptName;
	@Value("${scDisease.month.reportName}")
	private String scDiseaseMonthRptName;
	// 积分兑换报表（中国人寿保险真情卡女性疾病）
	@Value("${lcWomen.week.outpath}")
	private String lcWomenWeekOutputPath; // 周报表导出路径
	@Value("${lcWomen.month.outpath}")
	private String lcWomenMonthOutputPath; // 月报表导出路径
	@Value("${lcWomen.week.reportName}")
	private String lcWomenWeekRptName;
	@Value("${lcWomen.month.reportName}")
	private String lcWomenMonthRptName;
	// 积分兑换报表（中国人寿保险真情卡旅行意外）
	@Value("${lcTravel.week.outpath}")
	private String lcTravelWeekOutputPath; // 周报表导出路径
	@Value("${lcTravel.month.outpath}")
	private String lcTravelMonthOutputPath; // 月报表导出路径
	@Value("${lcTravel.week.reportName}")
	private String lcTravelWeekRptName;
	@Value("${lcTravel.month.reportName}")
	private String lcTravelMonthRptName;
	// 积分兑换报表（中国人寿保险真情卡重大疾病）
	@Value("${lcDisease.week.outpath}")
	private String lcDiseaseWeekOutputPath; // 周报表导出路径
	@Value("${lcDisease.month.outpath}")
	private String lcDiseaseMonthOutputPath; // 月报表导出路径
	@Value("${lcDisease.week.reportName}")
	private String lcDiseaseWeekRptName;
	@Value("${lcDisease.month.reportName}")
	private String lcDiseaseMonthRptName;
	// 积分兑换报表（中国人寿保险真情卡购物保障）
	@Value("${lcShop.week.outpath}")
	private String lcShopWeekOutputPath; // 周报表导出路径
	@Value("${lcShop.month.outpath}")
	private String lcShopMonthOutputPath; // 月报表导出路径
	@Value("${lcShop.week.reportName}")
	private String lcShopWeekRptName;
	@Value("${lcShop.month.reportName}")
	private String lcShopMonthRptName;
	// 积分兑换报表（中国人寿保险车主卡驾驶员意外）
	@Value("${ccDriver.week.outpath}")
	private String ccDriverWeekOutputPath; // 周报表导出路径
	@Value("${ccDriver.month.outpath}")
	private String ccDriverMonthOutputPath; // 月报表导出路径
	@Value("${ccDriver.week.reportName}")
	private String ccDriverWeekRptName;
	@Value("${ccDriver.month.reportName}")
	private String ccDriverMonthRptName;
	// 积分兑换报表（中国人民财产保险车主卡旅行交通意外）
	@Value("${ccTraffic.week.outpath}")
	private String ccTrafficWeekOutputPath; // 周报表导出路径
	@Value("${ccTraffic.month.outpath}")
	private String ccTrafficMonthOutputPath; // 月报表导出路径
	@Value("${ccTraffic.week.reportName}")
	private String ccTrafficWeekRptName;
	@Value("${ccTraffic.month.reportName}")
	private String ccTrafficMonthRptName;
	// 积分兑换报表（爱·宠普卡宠物饲养责任保险）
	@Value("${pcFeedResp.week.outpath}")
	private String pcFeedRespWeekOutputPath; // 周报表导出路径
	@Value("${pcFeedResp.month.outpath}")
	private String pcFeedRespMonthOutputPath; // 月报表导出路径
	@Value("${pcFeedResp.week.reportName}")
	private String pcFeedRespWeekRptName;
	@Value("${pcFeedResp.month.reportName}")
	private String pcFeedRespMonthRptName;
	@Value("${excel.MaxNum}")
	private int size;
	// 报表模板名
	@Value("${integralInsurance.tempPath}")
	private String templatePath;

	@Report(id = ReportConstant.JF_INSURANCE_SC_TRAVEL_21, name = "积分兑换周报表（中国人寿保险标准卡旅行意外）", type = Report.ReportType.WEEK)
	public Response<Boolean> exportStandardTravelForWeek(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			doWeekReport(reportDate, scTravelWeekOutputPath, scTravelWeekRptName,
					ReportConstant.GoodsXids.INSURANCE_SC_TRAVEL, ReportConstant.JF_INSURANCE_SC_TRAVEL_21);
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	@Report(id = ReportConstant.JF_INSURANCE_SC_TRAVEL_52, name = "积分兑换月报表（中国人寿保险标准卡旅行意外）", type = Report.ReportType.MONTH)
	public Response<Boolean> exportStandardTravelForMonth(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			doMonthReport(reportDate, scTravelMonthOutputPath, scTravelMonthRptName,
					ReportConstant.GoodsXids.INSURANCE_SC_TRAVEL, ReportConstant.JF_INSURANCE_SC_TRAVEL_52);
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}
	@Report(id = ReportConstant.JF_INSURANCE_SC_DISEASE_22, name = "积分兑换周报表（中国人寿保险标准卡重大疾病）", type = Report.ReportType.WEEK)
	public Response<Boolean> exportStandardDiseaseForWeek(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			doWeekReport(reportDate, scDiseaseWeekOutputPath, scDiseaseWeekRptName,
					ReportConstant.GoodsXids.INSURANCE_SC_DISEASE, ReportConstant.JF_INSURANCE_SC_DISEASE_22);
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	@Report(id = ReportConstant.JF_INSURANCE_SC_DISEASE_53, name = "积分兑换月报表（中国人寿保险标准卡重大疾病）", type = Report.ReportType.MONTH)
	public Response<Boolean> exportStandardDiseaseForMonth(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			doMonthReport(reportDate, scDiseaseMonthOutputPath, scDiseaseMonthRptName,
					ReportConstant.GoodsXids.INSURANCE_SC_DISEASE, ReportConstant.JF_INSURANCE_SC_DISEASE_53);
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}
	@Report(id = ReportConstant.JF_INSURANCE_TC_WOMEN_23, name = "积分兑换周报表（中国人寿保险真情卡女性疾病）", type = Report.ReportType.WEEK)
	public Response<Boolean> exportLoveCardWomenForWeek(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			doWeekReport(reportDate, lcWomenWeekOutputPath, lcWomenWeekRptName,
					ReportConstant.GoodsXids.INSURANCE_TC_WOMEN, ReportConstant.JF_INSURANCE_TC_WOMEN_23);
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}
	@Report(id = ReportConstant.JF_INSURANCE_TC_WOMEN_54, name = "积分兑换月报表（中国人寿保险真情卡女性疾病）", type = Report.ReportType.MONTH)
	public Response<Boolean> exportLoveCardWomenForMonth(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			doMonthReport(reportDate, lcWomenMonthOutputPath, lcWomenMonthRptName,
					ReportConstant.GoodsXids.INSURANCE_TC_WOMEN, ReportConstant.JF_INSURANCE_TC_WOMEN_54);
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}
	@Report(id = ReportConstant.JF_INSURANCE_TC_TRAVEL_24, name = "积分兑换周报表（中国人寿保险真情卡旅行意外）", type = Report.ReportType.WEEK)
	public Response<Boolean> exportLoveCardTravelForWeek(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			doWeekReport(reportDate, lcTravelWeekOutputPath, lcTravelWeekRptName,
					ReportConstant.GoodsXids.INSURANCE_TC_TRAVEL, ReportConstant.JF_INSURANCE_TC_TRAVEL_24);
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	@Report(id = ReportConstant.JF_INSURANCE_TC_TRAVEL_55, name = "积分兑换月报表（中国人寿保险真情卡旅行意外）", type = Report.ReportType.MONTH)
	public Response<Boolean> exportLoveCardTravelForMonth(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			doMonthReport(reportDate, lcTravelMonthOutputPath, lcTravelMonthRptName,
					ReportConstant.GoodsXids.INSURANCE_TC_TRAVEL, ReportConstant.JF_INSURANCE_TC_TRAVEL_55);
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}
	@Report(id = ReportConstant.JF_INSURANCE_TC_DISEASE_25, name = "积分兑换周报表（中国人寿保险真情卡重大疾病）", type = Report.ReportType.WEEK)
	public Response<Boolean> exportLoveCardDiseaseForWeek(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			doWeekReport(reportDate, lcDiseaseWeekOutputPath, lcDiseaseWeekRptName,
					ReportConstant.GoodsXids.INSURANCE_TC_DISEASE, ReportConstant.JF_INSURANCE_TC_DISEASE_25);
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	@Report(id = ReportConstant.JF_INSURANCE_TC_DISEASE_56, name = "积分兑换月报表（中国人寿保险真情卡重大疾病）", type = Report.ReportType.MONTH)
	public Response<Boolean> exportLoveCardDiseaseForMonth(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			doMonthReport(reportDate, lcDiseaseMonthOutputPath, lcDiseaseMonthRptName,
					ReportConstant.GoodsXids.INSURANCE_TC_DISEASE, ReportConstant.JF_INSURANCE_TC_DISEASE_56);
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}
	@Report(id = ReportConstant.JF_INSURANCE_TC_SHOP_26, name = "积分兑换周报表（中国人寿保险真情卡购物保障）", type = Report.ReportType.WEEK)
	public Response<Boolean> exportLoveCardShopForWeek(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			doWeekReport(reportDate, lcShopWeekOutputPath, lcShopWeekRptName, ReportConstant.GoodsXids.INSURANCE_TC_SHOP,
					ReportConstant.JF_INSURANCE_TC_SHOP_26);
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	@Report(id = ReportConstant.JF_INSURANCE_TC_SHOP_57, name = "积分兑换月报表（中国人寿保险真情卡购物保障）", type = Report.ReportType.MONTH)
	public Response<Boolean> exportLoveCardShopForMonth(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			doMonthReport(reportDate, lcShopMonthOutputPath, lcShopMonthRptName,
					ReportConstant.GoodsXids.INSURANCE_TC_SHOP, ReportConstant.JF_INSURANCE_TC_SHOP_57);
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}
	@Report(id = ReportConstant.JF_INSURANCE_CC_DRIVER_27, name = "积分兑换周报表（中国人寿保险车主卡驾驶员意外）", type = Report.ReportType.WEEK)
	public Response<Boolean> exportCrecorderDriverForWeek(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			doWeekReport(reportDate, ccDriverWeekOutputPath, ccDriverWeekRptName,
					ReportConstant.GoodsXids.INSURANCE_CC_DRIVER, ReportConstant.JF_INSURANCE_CC_DRIVER_27);
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	@Report(id = ReportConstant.JF_INSURANCE_CC_DRIVER_58, name = "积分兑换月报表（中国人寿保险车主卡驾驶员意外）", type = Report.ReportType.MONTH)
	public Response<Boolean> exportCrecorderDriverForMonth(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			doMonthReport(reportDate, ccDriverMonthOutputPath, ccDriverMonthRptName,
					ReportConstant.GoodsXids.INSURANCE_CC_DRIVER, ReportConstant.JF_INSURANCE_CC_DRIVER_58);
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}
	@Report(id = ReportConstant.JF_INSURANCE_CC_TRAFFIC_28, name = "积分兑换周报表（中国人民财产保险车主卡旅行交通意外）", type = Report.ReportType.WEEK)
	public Response<Boolean> exportCrecorderTrafficForWeek(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			doWeekReport(reportDate, ccTrafficWeekOutputPath, ccTrafficWeekRptName,
					ReportConstant.GoodsXids.INSURANCE_CC_TRAFFIC, ReportConstant.JF_INSURANCE_CC_TRAFFIC_28);
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	@Report(id = ReportConstant.JF_INSURANCE_CC_TRAFFIC_59, name = "积分兑换月报表（中国人民财产保险车主卡旅行交通意外）", type = Report.ReportType.MONTH)
	public Response<Boolean> exportCrecorderTrafficForMonth(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			doMonthReport(reportDate, ccTrafficMonthOutputPath, ccTrafficMonthRptName,
					ReportConstant.GoodsXids.INSURANCE_CC_TRAFFIC, ReportConstant.JF_INSURANCE_CC_TRAFFIC_59);
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}
	@Report(id = ReportConstant.JF_INSURANCE_PC_FEED_60, name = "积分兑换周报表（爱·宠普卡宠物饲养责任保险）", type = Report.ReportType.WEEK)
	public Response<Boolean> exportPetFeedRespForWeek(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			doWeekReport(reportDate, pcFeedRespWeekOutputPath, pcFeedRespWeekRptName,
					ReportConstant.GoodsXids.INSURANCE_PC_FEED, ReportConstant.JF_INSURANCE_PC_FEED_60);
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	@Report(id = ReportConstant.JF_INSURANCE_PC_FEED_61, name = "积分兑换月报表（爱·宠普卡宠物饲养责任保险）", type = Report.ReportType.MONTH)
	public Response<Boolean> exportPetFeedRespForMonth(String reportDate) {
		Response<Boolean> rps = new Response<>();
		try {
			doMonthReport(reportDate, pcFeedRespMonthOutputPath, pcFeedRespMonthRptName,
					ReportConstant.GoodsXids.INSURANCE_PC_FEED, ReportConstant.JF_INSURANCE_PC_FEED_61);
			rps.setResult(Boolean.TRUE);
			return rps;
		} catch (Exception e) {
			rps.setError(Throwables.getStackTraceAsString(e));
			return rps;
		}
	}

	/**
	 * 生成周报表
	 * 
	 * @param reportDate 报表日期
	 * @param weekOutputPath
	 * @param weekReportName 周报表名称
	 * @param goodsXid 礼品编号
	 * @param reportCode
	 */
	private void doWeekReport(String reportDate, String weekOutputPath, String weekReportName, String goodsXid,
			String reportCode) {
		Date startDate = BatchDateUtil.parseDate(reportDate);
		String endDateTemp = BatchDateUtil.addDay(reportDate, 7); 
		Date endDate = BatchDateUtil.parseDate(endDateTemp);
		QueryParams queryParams = ReportTaskUtil.initParams(startDate, endDate, goodsXid);

		String filePath = ExcelUtilAgency.encodingOutputFilePath(weekOutputPath, weekReportName, reportDate);
		String outputFile = queryDatasAndExport(queryParams, filePath, weekReportName);
		// 插入一条报表记录
		ReportModel reportModel = ReportTaskUtil.createReportModel(reportCode, weekReportName, reportDate, outputFile,
				ReportConstant.WEEK_REPORT_TYPE);
		Response<Integer> response = reportManager.insertReportReg(reportModel);
		if (!response.isSuccess()) {
			throw new RuntimeException(response.getError());
		}
	}

	/**
	 * 生成月报表
	 * 
	 * @param reportDate 报表日期
	 * @param monthOutputPath
	 * @param monthReportName 周报表名称
	 * @param goodsXid 礼品编号
	 * @param reportCode
	 */
	private void doMonthReport(String reportDate, String monthOutputPath, String monthReportName, String goodsXid,
			String reportCode) {
		Date startDate = BatchDateUtil.parseDate(reportDate);
		Date endDate = BatchDateUtil.addMonth(startDate, 1);
		QueryParams queryParams = ReportTaskUtil.initParams(startDate, endDate, goodsXid);

		String filePath = ExcelUtilAgency.encodingOutputFilePath(monthOutputPath, monthReportName, reportDate);
		String outputFile = queryDatasAndExport(queryParams, filePath, monthReportName);
		// 插入一条报表记录
		ReportModel reportModel = ReportTaskUtil.createReportModel(reportCode, monthReportName, reportDate, outputFile,
				ReportConstant.MONTH_REPORT_TYPE);
		Response<Integer> response = reportManager.insertReportReg(reportModel);
		if (!response.isSuccess()) {
			throw new RuntimeException(response.getError());
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
					String createDate = BatchDateUtil.fmtDate(integralExchangeDto.getCreateTime());
					integralExchangeDto.setCreateDate(createDate);
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
