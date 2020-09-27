package cn.com.cgbchina.batch.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 普通礼品销售统计 用于报表: 1.礼品销售日报表2.礼品销售周报表 3.礼品销售月报表
 * 
 * @author xiewl
 * @version 2016年5月4日 下午5:10:06
 *
 */
public class CommonGiftSaleDetail implements Serializable {

	/**
	 * 序号
	 */
	@Getter
	@Setter
	private String index;
	/**
	 * 订单编号
	 */
	@Getter
	@Setter
	private String orderId;
	/**
	 * 礼品编码
	 */
	@Getter
	@Setter
	private String goodsId;
	/**
	 * 兑换渠道
	 */
	@Getter
	@Setter
	private String otSourceNm;
	/**
	 * 礼品名称
	 */
	@Getter
	@Setter
	private String goodsNm;
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
	/**
	 * 礼品四级类目
	 */
	@Getter
	@Setter
	private String backCategory4;
	/**
	 * 原始结算价
	 */
	@Getter
	@Setter
	private String totalMoney;
	/**
	 * 实际结算价
	 */
	@Getter
	@Setter
	private String calMoney;
	/**
	 * 客户姓名
	 */
	@Getter
	@Setter
	private String contNm;
	/**
	 * 省份
	 */
	@Getter
	@Setter
	private String csgProvince;
	/**
	 * 城市
	 */
	@Getter
	@Setter
	private String csgCity;
	/**
	 * 订单状态
	 */
	@Getter
	@Setter
	private String curStatusNm;

}
