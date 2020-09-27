package cn.com.cgbchina.batch.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * (会员报表)会员购物车报表记录
 * @author xiewl
 * @version 2016年6月16日 下午3:28:02
 */
public class MemberShopCarDto implements Serializable {
	private static final long serialVersionUID = 4401449317374418923L;
	/**
	 * 商品编号
	 */
	@Getter
	@Setter
	private String goodsId;
	/**
	 * 商品名称
	 */
	@Getter
	@Setter
	private String goodsNm;
	/**
	 * 所属商城
	 */
	@Getter
	@Setter
	private String mallNm;
	/**
	 * 添加次数
	 */
	@Getter
	@Setter
	private String addedNum;
}
