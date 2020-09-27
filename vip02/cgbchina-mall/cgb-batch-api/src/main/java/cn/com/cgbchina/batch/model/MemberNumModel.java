package cn.com.cgbchina.batch.model;

import java.io.Serializable;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * (会员报表)会员总数记录
 *
 * @author xiewl
 * @version 2016年6月16日 下午2:54:05
 */
@Getter
@Setter
@ToString
public class MemberNumModel implements Serializable {

	private static final long serialVersionUID = -4404001184705393116L;
	/**
	 * 商城名称
	 */
	private String mallNm;
	/**
	 * 商城名称
	 */
	private BigDecimal memberNum;
}
