package cn.com.cgbchina.batch.model;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

/**
 * （广发商城管理平台） 分期退货明细 用于报表: 1.分期退货报表(日) 2.分期退货报表(周) 3.分期退货报表(月)
 * 
 * @author xiewl
 * @version 2016年5月4日 下午4:31:42
 */
public class StageReturnGoods implements Serializable {

	/**
	 * 银行订单号
	 */
	@Getter
	@Setter
	private String orderNBR;
	/**
	 * 商城订单号
	 */
	@Getter
	@Setter
	private String orderId;
	/**
	 * 商品编号
	 */
	@Getter
	@Setter
	private String goodsId;
	/**
	 * 价格
	 */
	@Getter
	@Setter
	private BigDecimal installmentPrice;
	/**
	 * 产品名称
	 */
	@Getter
	@Setter
	private String goodsNm;
	/**
	 * 卡号
	 */
	@Getter
	@Setter
	private String cardNo;
	/**
	 * 客户姓名
	 */
	@Getter
	@Setter
	private String customerNm;
	/**
	 * 备注
	 */
	@Getter
	@Setter
	private String desc;
	/**
	 * 供应商名称
	 */
	@Getter
	@Setter
	private String vendorSnm;
	/**
	 * 证件号码
	 */
	@Getter
	@Setter
	private String certNo;
	/**
	 * 数量
	 */
	@Getter
	@Setter
	private Integer goodsNum;
	/**
	 * 渠道
	 */
	@Getter
	@Setter
	private String sourceNm;
	/**
	 * 分期费率码
	 */
	@Getter
	@Setter
	private String specShopNo;

}
