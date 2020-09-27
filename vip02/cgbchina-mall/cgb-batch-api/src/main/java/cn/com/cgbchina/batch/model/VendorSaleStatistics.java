package cn.com.cgbchina.batch.model;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

/**
 * (广发商城管理平台) 商户销售统计 用于报表:1.商户销售统计报表(日) 2.商户销售统计报表(周) 3.商户销售统计报表(月)
 * 
 * @author xiewl
 * @version 2016年5月4日 下午4:16:40
 */
public class VendorSaleStatistics implements Serializable {

	/**
	 * 商户代码
	 */
	@Getter
	@Setter
	private String vendorId;
	/**
	 * 商户名称
	 */
	@Getter
	@Setter
	private String vendorSnm;
	/**
	 * 销售金额
	 */
	@Getter
	@Setter
	private BigDecimal totalMoney;
	/**
	 * 销售数量
	 */
	@Getter
	@Setter
	private Integer totalGoodsNum;

}
