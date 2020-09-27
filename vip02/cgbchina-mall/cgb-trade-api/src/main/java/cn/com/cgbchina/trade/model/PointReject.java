package cn.com.cgbchina.trade.model;

import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by yuxinxin on 16-4-15.
 */
public class PointReject implements Serializable {

	private static final long serialVersionUID = -7814238504800283072L;
	@Getter
	@Setter
	private String id;
	@Getter
	@Setter
	private String goodsName;
	@Getter
	@Setter
	private String rejectStatus;

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		PointReject that = (PointReject) o;

		return Objects.equal(this.id, that.id) && Objects.equal(this.goodsName, that.goodsName)
				&& Objects.equal(this.rejectStatus, that.rejectStatus);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(id, goodsName, rejectStatus);
	}

	@Override
	public String toString() {
		return MoreObjects.toStringHelper(this).add("id", id).add("goodsName", goodsName)
				.add("rejectStatus", rejectStatus).toString();
	}
}
