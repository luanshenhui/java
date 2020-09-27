package cn.com.cgbchina.batch.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 退货细节 用于报表: 1.礼品退货周报表 2.礼品退货月报表
 * 
 * @author xiewl
 * @version 2016年5月4日 下午5:16:57
 * 
 */
public class GoodsBackDetail implements Serializable {

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
	 * 销售数量
	 */
	@Getter
	@Setter
	private String goodsNum;
	/**
	 * 结算单价
	 */
	@Getter
	@Setter
	private String singlePrice;
	/**
	 * 结算总价
	 */
	@Getter
	@Setter
	private String calMoney;
	/**
	 * 是否生日
	 */
	@Getter
	@Setter
	private String isBirthday;
	/**
	 * 订单状态
	 */
	@Getter
	@Setter
	private String curStatusNm;
	/**
	 * 渠道
	 */
	@Getter
	@Setter
	private String sourceNm;

}
