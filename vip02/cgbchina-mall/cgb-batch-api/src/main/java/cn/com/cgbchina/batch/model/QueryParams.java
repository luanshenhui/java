package cn.com.cgbchina.batch.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

/**
 * Description : 报表查询参数类 <br>
 * 日期 : 2016年6月30日<br>
 * 作者 : xiewl<br>
 * 项目 : cgb-trade-api<br>
 * 功能 : <br>
 */
public class QueryParams implements Serializable{

	private static final long serialVersionUID = 3860524500776323383L;
	/**
	 * 偏移(页码)
	 */
	@Getter
	@Setter
	private int offset;
	/**
	 * size 限制条数
	 */
	@Getter
	@Setter
	private int limit;

	/**
	 * 查询时间段的起始时间
	 */
	@Getter
	@Setter
	private Date startDate;
	
	/**
	 * 查询时间段的结束时间
	 */
	@Getter
	@Setter
	private Date endDate;

	/**
	 * 指定商户ID
	 */
	@Getter
	@Setter
	private String vendorId;
	
	/**
	 * 航空类型
	 */
	@Getter
	@Setter
	private String aviationType;
	
	/**
	 * 礼品清单
	 */
	@Getter
	@Setter
	private List<String> goodsXids;
	
	/**
	 * 是否第一次取数,用作是否需要统计总数据量
	 */
	@Getter
	@Setter
	private boolean firstVisit;

}
