package cn.com.cgbchina.batch.dto;

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
	 * 兑换统计月报表:增值白金+顶级价格
	 */
	@Getter
	@Setter
	private String zdNum;
	/**
	 * VIP
	 */
	@Getter
	@Setter
	private String vipNum;
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
	private String bcnum;
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
	private String regionType;
	/**
	 * 一级后台类目
	 */
	@Getter
	@Setter
	private String backCategory1Id;
	/**
	 * 二级后台类目
	 */
	@Getter
	@Setter
	private String backCategory2Id;
	/**
	 * 三级后台类目
	 */
	@Getter
	@Setter
	private String backCategory3Id;
}
