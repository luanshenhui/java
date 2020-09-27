package cn.com.cgbchina.item.dto;

/**
 * Created by 陈乐 on 2016/5/9.
 */

import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 查看商品详情中关联商品用Dto
 */
public class RecommendGoodsDto implements Serializable {

	private static final long serialVersionUID = -5655248329032005861L;
	@Getter
	@Setter
	private String itemCode;//单品编码
	@Getter
	@Setter
	private String goodsName;// 商品名称
	@Getter
	@Setter
	private BigDecimal minPrice;// 最小售价
	@Getter
	@Setter
	private BigDecimal maxPrice;// 最大售价
	@Getter
	@Setter
	private String img;// 商品图片，默认为第一个单品的第一张图片
	@Getter
	@Setter
	private String maxInstallmentNumber;//最大分期数

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		RecommendGoodsDto that = (RecommendGoodsDto) o;

		return Objects.equal(this.goodsName, that.goodsName) && Objects.equal(this.minPrice, that.minPrice)
				&& Objects.equal(this.maxPrice, that.maxPrice) && Objects.equal(this.img, that.img);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(goodsName, minPrice, maxPrice, img);
	}

	@Override
	public String toString() {
		return Objects.toStringHelper(this).add("goodsName", goodsName).add("minPrice", minPrice)
				.add("maxPrice", maxPrice).add("img", img).toString();
	}
}
