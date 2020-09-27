package cn.com.cgbchina.user.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 
 * 日期 : 2016年7月5日<br>
 * 作者 : Huangcy<br>
 * 项目 : cgb-user-api<br>
 * 功能 : 会员报表统计<br>
 */
public class MemberBatchDto implements Serializable {
	private static final long serialVersionUID = 1L;
	/**
	 * 商品编码
	 */
	@Setter
	@Getter
	private String goodsCode;
	/**
	 * 单品编码
	 */
	@Setter
	@Getter
	private String itemCode;
	/**
	 * 次数
	 */
	@Setter
	@Getter
	private String count;
}
