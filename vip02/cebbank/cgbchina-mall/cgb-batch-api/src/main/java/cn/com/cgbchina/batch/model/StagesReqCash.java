package cn.com.cgbchina.batch.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 分期请款 用于报表:分期请款报表
 * 
 * @author xiewl
 * @version 2016年5月4日 下午4:24:36
 */
public class StagesReqCash implements Serializable {

	/**
	 * 序号
	 */
	@Getter
	@Setter
	private String index;
	/**
	 * 银行订单号
	 */
	@Getter
	@Setter
	private String orderNBR;
	/**
	 * 大订单号
	 */
	@Getter
	@Setter
	private String orderMainId;
	/**
	 * 小订单号
	 */
	@Getter
	@Setter
	private String orderId;
	/**
	 * 合作商
	 */
	@Getter
	@Setter
	private String vendorSnm;
	/**
	 * 姓名
	 */
	@Getter
	@Setter
	private String contNm;
	/**
	 * 商品编码
	 */
	@Getter
	@Setter
	private String goodsId;
	/**
	 * 订货数量
	 */
	@Getter
	@Setter
	private Integer goodsNum;
	/**
	 * 订货总金额
	 */
	@Getter
	@Setter
	private Double totalMoney;
	/**
	 * 快递公司名称
	 */
	@Getter
	@Setter
	private String transcorpNm;
	/**
	 * 快递单号
	 */
	@Getter
	@Setter
	private String mailingNum;
	/**
	 * 支付方式
	 */
	@Getter
	@Setter
	private String paywayNm;
	/**
	 * 发货状态
	 */
	@Getter
	@Setter
	private String goodsSendFlag;
	/**
	 * 请款状态
	 */
	@Getter
	@Setter
	private String sinStatusNm;
	/**
	 * 渠道
	 */
	@Getter
	@Setter
	private String sourceNm;
	/**
	 * 分期类别码
	 */
	@Getter
	@Setter
	private String ext2;
	/**
	 * 备注
	 */
	@Getter
	@Setter
	private String orderDesc;

}
