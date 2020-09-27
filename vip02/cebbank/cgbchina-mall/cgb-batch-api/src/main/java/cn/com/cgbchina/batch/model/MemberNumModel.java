package cn.com.cgbchina.batch.model;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

/**
 * (会员报表)会员总数记录
 * 
 * @author xiewl
 * @version 2016年6月16日 下午2:54:05
 */
public class MemberNumModel implements Serializable {

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
