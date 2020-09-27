package cn.com.cgbchina.batch.util;

import java.io.File;
import java.util.Date;
import java.util.List;
import java.util.Map;


import cn.com.cgbchina.common.utils.BatchDateUtil;
import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.batch.model.ReportModel;
import cn.com.cgbchina.batch.model.QueryParams;

import com.google.common.base.Splitter;
import com.google.common.collect.Maps;

/**
 * 报表任务工具
 * 
 * @author huangcy on 2016年6月15日
 */
public class ReportTaskUtil {
	private static final String DEFAULT_TIME = "000000";
	private static String DISK_PATH;// 导出文件存放的本地硬盘路径
	private static String REPORT_URL;//URL路径

	public void setDiskPath(String diskPath) {
        DISK_PATH = diskPath;
    }
	
	public void setReportUrl(String reportUrl) {
		REPORT_URL = reportUrl;
    }
	/**
	 * 
	 * Description : 生成日报表文件下载记录
	 * 
	 * @param reportCode 报表代码
	 * @param reportName 报表名称
	 * @param reportDate 报表日期
	 * @param reportPath 下载路径
	 * @param reportType 报表类型
	 * @return
	 */
	public static ReportModel createReportModel(String reportCode, String reportName, String reportDate,
			String reportPath, String reportType) {
		ReportModel reportModel = new ReportModel();
		reportModel.setReportCode(reportCode);
		reportModel.setReportNm(reportName);
		reportModel.setReportDate(reportDate);
		reportModel.setReportTime(BatchDateUtil.fmtTime(new Date()));
		String path = reportPath.replace(DISK_PATH, "");
		reportModel.setReportPath(path);
		String ordertypeId = reportCode.substring(0, 2);
		reportModel.setOrdertypeId(ordertypeId);
		reportModel.setReportRecNum(0);
		reportModel.setReportDesc(reportType);
		return reportModel;
	}

	public static String  removeDiskPath(String reportPath) {
		String path = reportPath.replace(DISK_PATH, "");
		return path;
	}

	public static String addDiskPath(String reportPath) {
		String path = DISK_PATH + File.separatorChar + reportPath;
		return path;
	}
	/**
	 * 
	 * Description : 生成有供应商id的报表文件下载记录
	 * 
	 * @param reportCode
	 * @param reportName
	 * @param reportDate
	 * @param reportPath
	 * @param vendorId 供应商id
	 * @return
	 */
	public static ReportModel createReportModel(String reportCode, String reportName, String reportDate,
			String reportPath, String vendorId, String reportType) {
		ReportModel reportModel = createReportModel(reportCode, reportName, reportDate, reportPath, reportType);
		reportModel.setVendorId(vendorId);
		return reportModel;
	}

	/**
	 * 
	 * Description : 计算总页数。当没有数据时，页数设置为1
	 * 
	 * @param total
	 * @param size
	 * @return
	 */
	public static int calTotalPages(long total, int size) {
		int totalPages = (int) (total % size == 0 ? total / size : total / size + 1);
		totalPages = totalPages == 0 ? 1 : totalPages;
		return totalPages;
	}

	/**
	 * 
	 * Description : 初始化所有航空类型
	 * 
	 * @return
	 */
	public static Map<String, String> initAviationTypes() {
		Map<String, String> aviationTypes = Maps.newHashMap();
		aviationTypes.put(ReportConstant.AviationType.AIR_CHINA_CODE, ReportConstant.AviationType.AIR_CHINA_NAME);
		aviationTypes.put(ReportConstant.AviationType.AIR_ASIA_CODE, ReportConstant.AviationType.AIR_ASIA_NAME);
		aviationTypes.put(ReportConstant.AviationType.AIR_EAST_CODE, ReportConstant.AviationType.AIR_EAST_NAME);
		aviationTypes.put(ReportConstant.AviationType.AIR_SOUTH_CODE, ReportConstant.AviationType.AIR_SOUTH_NAME);
		return aviationTypes;
	}

	/**
	 * 
	 * Description : 积分兑换 初始化查询条件参数
	 * 
	 * @param startDate
	 * @param endDate
	 * @param goodsXid
	 * @return
	 */
	public static QueryParams initParams(Date startDate, Date endDate, String goodsXid) {
		List<String> goodsXids = Splitter.on('|').omitEmptyStrings().trimResults().splitToList(goodsXid);// 礼品清单
		QueryParams queryParams = new QueryParams();
		queryParams.setStartDate(startDate);
		queryParams.setEndDate(endDate);
		queryParams.setGoodsXids(goodsXids);
		queryParams.setFirstVisit(true);// 首次取数
		return queryParams;
	}

	/**
	 * 
	 * Description : 获取日报表的日期查询参数
	 * 
	 * @param reportDate 生成报表日期
	 * @return
	 */
	public static Map<String, Object> getDayParam(String reportDate) {
		Date startDate = BatchDateUtil.getLastDay(reportDate);// 前一天
		Date endDate = startDate;
		Map<String, Object> queryParams = Maps.newHashMap();
		queryParams.put("startDate", startDate);
		queryParams.put("endDate", endDate);
		return queryParams;
	}

	/**
	 * 
	 * Description : 获取周报表的日期查询参数
	 * 
	 * @param reportDate 生成报表日期
	 * @return
	 */
	public static Map<String, Object> getWeekParam(String reportDate) {
		Date startDate = BatchDateUtil.getLastWeek(reportDate);
		Date endDate = BatchDateUtil.getLastDay(reportDate);// 前一天
		Map<String, Object> queryParams = Maps.newHashMap();
		queryParams.put("startDate", startDate);
		queryParams.put("endDate", endDate);
		return queryParams;
	}

	/**
	 * 
	 * Description : 获取月报表的日期查询参数
	 * 
	 * @param reportDate 生成报表日期
	 * @return
	 */
	public static Map<String, Object> getMonthParam(String reportDate) {
		Date startDate = BatchDateUtil.getFirstDayOfLastMonth(reportDate);
		Date endDate = BatchDateUtil.getLastDay(reportDate);// 前一天
		Map<String, Object> queryParams = Maps.newHashMap();
		queryParams.put("startDate", startDate);
		queryParams.put("endDate", endDate);
		return queryParams;
	}

	/**
	 * 输入的日期为null或者空字符串，返回当前日期，否则返回输入日期
	 * 
	 * @param inputDate 输入日期, 格式yyyyMMdd
	 * @param addDay 加减天数
	 * @return
	 */
	public static Date getTxDate(String inputDate, int addDay) {
		return getDateTime(inputDate, null, addDay);
	}

	/**
	 * 输入的日期为null或者空字符串，返回当前日期，否则返回输入日期
	 * 
	 * @param inputDate 输入日期, 格式yyyyMMdd
	 * @return
	 */
	public static Date getTxDate(String inputDate) {
		return getTxDate(inputDate, 0);
	}

	/**
	 * 获取当前日期
	 * 
	 * @return
	 */
	public static Date getTxDate() {
		return getTxDate(null);
	}

	/**
	 * 获取指定日期和时间</br> 输入的日期为null或者空字符串，返回当前日期，否则返回输入日期；输入时间时分秒为空时默认000000
	 * 
	 * @param inputDate 输入日期，格式yyyyMMdd
	 * @param addDay 加减日期
	 * @param inputTime 输入时间，格式HHmmss，当输入为空时默认000000
	 * @return
	 */
	public static Date getDateTime(String inputDate, String inputTime, int addDay) {
		String txDate, txTime;
		if (!StringUtils.hasText(inputDate)) {
			txDate = BatchDateUtil.addDay(BatchDateUtil.fmtDate(new Date()), addDay);
		} else {
			if (!BatchDateUtil.isDate(inputDate)) {
				throw new IllegalArgumentException("输入的日期不存在或者格式不对，格式应为yyyyMMdd");
			}
			txDate = BatchDateUtil.addDay(inputDate, addDay);
		}

		if (!StringUtils.hasText(inputTime)) {
			txTime = DEFAULT_TIME;
		} else {
			if (!BatchDateUtil.isDate(inputTime, BatchDateUtil.FMT_TIME)) {
				throw new IllegalArgumentException("输入时间为不存在或者格式错误，请输入格式为HHmmss的时间");
			}
			txTime = inputTime;
		}

		return BatchDateUtil.parseDate(txDate + txTime, BatchDateUtil.FMT_DATE_TIME);
	}

}
