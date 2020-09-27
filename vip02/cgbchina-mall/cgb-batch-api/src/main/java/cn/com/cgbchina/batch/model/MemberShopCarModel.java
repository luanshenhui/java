package cn.com.cgbchina.batch.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * (会员报表)会员购物车报表记录
 *
 * @author xiewl
 * @version 2016年6月16日 下午3:28:02
 */
@Getter
@Setter
@ToString
public class MemberShopCarModel implements Serializable {
	private static final long serialVersionUID = -8768188694986219290L;
	/**
	 * 商品编号
	 */
	private String goodsId;
	/**
	 * 商品名称
	 */
	private String goodsNm;
	/**
	 * 所属商城
	 */
	private String mallNm;
	/**
	 * 添加次数
	 */
	private String addedNum;
}
