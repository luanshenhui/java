package cn.com.cgbchina.trade.dto;

import java.io.Serializable;
import java.util.Date;

import com.google.common.base.Objects;

import lombok.Getter;
import lombok.Setter;

/**
 * 购物车添加商品统计: 用于统计商品关注度/热度 日期 : 2016-8-24<br>
 * 作者 : xiewl<br>
 * 项目 : cgb-trade-api<br>
 * 功能 : <br>
 */

public class CartAddCountDto implements Serializable {

	private static final long serialVersionUID = -7367898359910298705L;

	/**
	 * 添加日期
	 */
	@Getter
	@Setter
	private Date addDate;
	/**
	 * 所属周数
	 */
	@Getter
	@Setter
	private Integer week;
	/**
	 * 所属商城 对应Contans中的MallType  01广发 02积分
	 */
	@Getter
	@Setter
	private String mallType;
	/**
	 * 商品id 对应商城中的itemId
	 */
	@Getter
	@Setter
	private String goodsId;
	/**
	 * 统计次数
	 */
	@Getter
	@Setter
	private Long countNum;
	

	@Override
	public boolean equals(Object o) {
		if (this == null) {
			return false;
		}
		if (o == null || getClass() != o.getClass())
			return false;
		CartAddCountDto that = (CartAddCountDto) o;
		return Objects.equal(this.addDate, that.addDate) && Objects.equal(this.week, that.week)
				&& Objects.equal(this.goodsId, that.goodsId);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(addDate, week, goodsId, countNum);
	}

}
