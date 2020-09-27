package cn.com.cgbchina.batch.model;

import lombok.Setter;

import lombok.Getter;

/**
 * 商城会员统计
 * 
 * @author xiewl
 * @version 2016年5月31日 下午2:59:26
 */
public class MemberAmount {
	/**
	 * 商城名字
	 */
	@Getter
	@Setter
	private String mallName;
	/**
	 * 会员数量
	 */
	@Getter
	@Setter
	private Integer memberAmount;

}
