package cn.com.cgbchina.batch.util;

import java.util.List;
import java.util.Map;

import lombok.Getter;
import lombok.Setter;

/**
 * ExcelUtilAgency导出模型
 * 
 * @author xiewl
 * @version 2016年6月15日 下午4:04:20
 * @param <T>
 */
public class ExportModel<T, E> {
	/**
	 * 导出的数据
	 */
	@Getter
	@Setter
	private List<T> date;
	/**
	 * 导出的模版 类型为String 或 inputStream
	 */
	@Getter
	@Setter
	private E template;
	/**
	 * 导出路径
	 */
	@Getter
	@Setter
	private String path;
	/**
	 * 需要导出的额外参数
	 */
	@Getter
	@Setter
	private Map<String, String> params;
}
