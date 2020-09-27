package cn.com.cgbchina.batch.util;

import java.util.Date;
import java.util.Map;

import com.google.common.collect.Maps;

/** 
 * 报表任务工具
 * @author huangcy
 * on 2016年6月15日 
 */
public class ReportTaskUtil {
	private static final String DEFAULT_TIME = "000000";
	private ReportTaskUtil(){}
	
	/**
	 * 将报表标题转换成map形式
	 * @param title 标题内容
	 * @return
	 */
	public static Map<String, String> getTitleMap(String title){
		Map<String, String> params = Maps.newHashMap();
		params.put("title", title);
		return params;
	}
	
	/**
	 * 获取昨天日期 
	 * @param inputDate 格式yyyyMMdd
	 * @return
	 */
	public static Date getLastDay(String inputDate){
		return getTxDate(inputDate, -1);
	}
	
	/**
	 * 获取一周前的日期
	 * @param inputDate 格式yyyyMMdd
	 * @return
	 */
	public static Date getLastWeek(String inputDate){
		return getTxDate(inputDate, -7);
	}
	
	/**
	 * 获取一个月前的日期
	 * @param inputDate 格式yyyyMMdd
	 * @return
	 */
	public static Date getLastMonth(String inputDate){
		return BatchDateUtil.addMonth(getTxDate(inputDate), -1);
	}
	
	/**
	 * 输入的日期为null或者空字符串，返回当前日期，否则返回输入日期
	 * @param inputDate 输入日期, 格式yyyyMMdd
	 * @param addDay 加减天数
	 * @return
	 */
	public static Date getTxDate(String inputDate, int addDay){
		return getDateTime(inputDate, null, addDay);
	}
	
	/**
	 * 输入的日期为null或者空字符串，返回当前日期，否则返回输入日期
	 * @param inputDate 输入日期, 格式yyyyMMdd
	 * @return
	 */
	public static Date getTxDate(String inputDate){
		return getTxDate(inputDate, 0);
	}
	
	/**
	 * 获取当前日期
	 * @return 
	 */
	public static Date getTxDate() {
		return getTxDate(null);
	}
	
	/**
	 * 获取指定日期和时间</br>
	 * 输入的日期为null或者空字符串，返回当前日期，否则返回输入日期；输入时间时分秒为空时默认000000
	 * @param inputDate 输入日期，格式yyyyMMdd
	 * @param addDay 加减日期
	 * @param inputTime 输入时间，格式HHmmss，当输入为空时默认000000
	 * @return 
	 */
	public static Date getDateTime(String inputDate, String inputTime, int addDay){
		String txDate,txTime;
		if(!StringUtils.hasText(inputDate)){
			txDate = BatchDateUtil.addDay(BatchDateUtil.fmtDate(new Date()), addDay);
		}else{
			if(!BatchDateUtil.isDate(inputDate)){
				throw new IllegalArgumentException("输入的日期不存在或者格式不对，格式应为yyyyMMdd");
			}
			txDate = BatchDateUtil.addDay(inputDate, addDay);
		}
		
		if(!StringUtils.hasText(inputTime)){
			txTime = DEFAULT_TIME;
		}else {
			if(!BatchDateUtil.isDate(inputTime, BatchDateUtil.FMT_TIME)){
				throw new IllegalArgumentException("输入时间为不存在或者格式错误，请输入格式为HHmmss的时间");
			}
			txTime = inputTime;
		}
		
		return BatchDateUtil.parseDate(txDate + txTime, BatchDateUtil.FMT_DATE_TIME);
	}
	
	public static void main(String[] args) {
//		System.out.println(getTitleMap("sa"));
//		System.out.println(BatchDateUtil.fmtDateTime(getTxDate(" ")));
//		System.out.println(getTxDate("d"));
		System.out.println(getLastMonth(null));
		System.out.println(getLastWeek("20160620"));
		System.out.println(getDateTime(null, null, -1));
		System.out.println(getDateTime("20160620", "235959", 0));
	}
}
