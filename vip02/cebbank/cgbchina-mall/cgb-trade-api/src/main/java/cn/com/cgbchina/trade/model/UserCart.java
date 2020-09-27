package cn.com.cgbchina.trade.model;

import com.google.common.base.MoreObjects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

public class UserCart implements Serializable {

	private static final long serialVersionUID = -4566722924562515339L;
	@Getter
	@Setter
	private Long shopId;

	@Getter
	@Setter
	private Long sellerId;

	@Getter
	@Setter
	private String shopName;

	@Getter
	@Setter
	private String shopImage;

	@Getter
	@Setter
	private int countCou;

	@Getter
	@Setter
	private List<CartItem> cartItems;

	@Override
	public String toString() {
		return MoreObjects.toStringHelper(this).add("shopId", shopId).add("sellerId", sellerId)
				.add("shopName", shopName).add("cartItems", cartItems).omitNullValues().toString();
	}
}
