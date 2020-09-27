package cn.com.cgbchina.trade.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 礼品兑换统计细节 用于报表:兑换统计月报表
 * @author xiewl
 * @version 2016年5月5日 上午9:15:26
 */
public class ExchangeStatisticsDto implements Serializable {
	private static final long serialVersionUID = -9149111566209413301L;
	/**
	 * 渠道
	 */
	@Getter
	@Setter
	private String sourceNm;

	/**
	 * 礼品编号
	 */
	@Getter
	@Setter
	private String goodsId;
	/**
	 * 礼品名称
	 */
	@Getter
	@Setter
	private String goodsNm;
	/**
	 * 金普卡
	 */
	@Getter
	@Setter
	private String jpNum;
	/**
	 * 臻享+钛金价格
	 */
	@Getter
	@Setter
	private String ztNum;
	/**
	 * 增值白金+顶级价格
	 */
	@Getter
	@Setter
	private String zdSum;
	/**
	 * VIP
	 */
	@Getter
	@Setter
	private String vipSum;
	/**
	 * 生日
	 */
	@Getter
	@Setter
	private String birthdayNum;
	/**
	 * 积分+现金
	 */
	@Getter
	@Setter
	private String icNum;
	/**
	 * 数量总计
	 */
	@Getter
	@Setter
	private String saleSumNum;
	/**
	 * 礼品分区
	 */
	@Getter
	@Setter
	private String goodsPart;
	/**
	 * 礼品一级类目
	 */
	@Getter
	@Setter
	private String backCategory1;
	/**
	 * 礼品二级类目
	 */
	@Getter
	@Setter
	private String backCategory2;
	/**
	 * 礼品三级类目
	 */
	@Getter
	@Setter
	private String backCategory3;
}
