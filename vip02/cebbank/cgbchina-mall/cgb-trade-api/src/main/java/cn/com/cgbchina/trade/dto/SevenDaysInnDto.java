package cn.com.cgbchina.trade.dto;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;

/**
 * 7天联名卡住宿券报表
 * 
 * @author xiewl
 * @version 2016年6月16日 上午9:55:31
 */
public class SevenDaysInnDto implements Serializable {
	private static final long serialVersionUID = 2334789203450711623L;
	/**
	 * 序号
	 */
	@Getter
	@Setter
	private int index;
	/**
	 * 姓名
	 */
	@Getter
	@Setter
	private String contNm;
	/**
	 * 会员号
	 */
	@Getter
	@Setter
	private String memberNo;
	/**
	 * 手机号
	 */
	@Getter
	@Setter
	private String csgPhone1;
	/**
	 * 礼品编码
	 */
	@Getter
	@Setter
	private String goodsId;
	/**
	 * 数量
	 */
	@Getter
	@Setter
	private BigDecimal goodsNum;
	/**
	 * 七天积分总数
	 */
	@Getter
	@Setter
	private BigDecimal integralNum;
}
