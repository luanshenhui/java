package cn.com.cgbchina.batch.dto;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

/** 
 * 商户兑换统计
 * @author huangcy
 * on 2016年6月17日 
 */
public class VendorExchangeStatDto implements Serializable{
	private static final long serialVersionUID = 5463075143227013217L;
	/**
	 * 供应商
	 */
	@Setter
	@Getter
	private String vendorNm;
	/**
	 * 兑换量合计
	 */
	@Setter
	@Getter
	private Integer sumNum;
	/**
	 * 兑换金额合计
	 */
	@Setter
	@Getter
	private BigDecimal sumPrice;
}
