package cn.com.cgbchina.trade.dto;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

/**
 * (会员报表)会员总数记录
 * @author xiewl
 * @version 2016年6月16日 下午2:54:05
 */
public class MemberNumDto implements Serializable {

	private static final long serialVersionUID = 7904346247554023411L;
	/**
	 * 商城名称
	 */
	@Getter
	@Setter
	private String mallNm;
	/**
	 * 商城名称
	 */
	@Getter
	@Setter
	private BigDecimal memberNum;
}
