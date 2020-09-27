package cn.com.cgbchina.trade.model;

import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by yuxinxin on 16-4-14.
 */
public class PointCollocation implements Serializable {

	private static final long serialVersionUID = -3700526532844593967L;
	@Getter
	@Setter
	private String id;
	@Getter
	@Setter
	private String goodsName;
	@Getter
	@Setter
	private String goodsPrice;
	@Getter
	@Setter
	private String goodsNum;
	@Getter
	@Setter
	private String goodsCustomer;
	@Getter
	@Setter
	private String goodsPay;
	@Getter
	@Setter
	private String status;

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		PointCollocation that = (PointCollocation) o;

		return Objects.equal(this.id, that.id) && Objects.equal(this.goodsName, that.goodsName)
				&& Objects.equal(this.goodsPrice, that.goodsPrice) && Objects.equal(this.goodsNum, that.goodsNum)
				&& Objects.equal(this.goodsCustomer, that.goodsCustomer) && Objects.equal(this.goodsPay, that.goodsPay)
				&& Objects.equal(this.status, that.status);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(id, goodsName, goodsPrice, goodsNum, goodsCustomer, goodsPay, status);
	}

	@Override
	public String toString() {
		return MoreObjects.toStringHelper(this).add("id", id).add("goodsName", goodsName).add("goodsPrice", goodsPrice)
				.add("goodsNum", goodsNum).add("goodsCustomer", goodsCustomer).add("goodsPay", goodsPay)
				.add("status", status).toString();
	}
}
