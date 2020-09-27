package cn.com.cgbchina.trade.dto;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

/**
 * 结算详细 用于报表: 结算报表(结算日报表)
 * 
 * @author xiewl
 * @version 2016年5月4日 下午5:26:36
 */
public class ClearingDto implements Serializable {
	private static final long serialVersionUID = -6193392355133909130L;
	/**
	 * 序号
	 */
	@Getter
	@Setter
	private int index;

	/**
	 * 合作商编码
	 */
	@Getter
	@Setter
	private String vendorId;
	/**
	 * 合作商名称
	 */
	@Getter
	@Setter
	private String vendorSnm;
	/**
	 * 请款礼品数量
	 */
	@Getter
	@Setter
	private Integer requestGoodsNum;
	/**
	 * 请款总金额
	 */
	@Getter
	@Setter
	private BigDecimal requestTotalMoney;
	/**
	 * 退货礼品数量
	 */
	@Getter
	@Setter
	private Integer backGoodsNum;
	/**
	 * 退货总金额
	 */
	@Getter
	@Setter
	private BigDecimal backTotalMoney;
	/**
	 * 结算金额
	 */
	@Getter
	@Setter
	private BigDecimal calMoney;

}
