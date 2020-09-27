package cn.com.cgbchina.trade.model;

import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;

import java.io.Serializable;

/**
 * Created by 张成 on 16-4-11.
 */
public class CollocationSell implements Serializable {

	private static final long serialVersionUID = 8211720424715895629L;
	private String id;
	private String itemName;
	private String itemPrice;
	private String orderTime;
	private String orderCode;
	private String count;
	private String status;
	private String auditType;
	private String afterSale;

	public String getAfterSale() {
		return afterSale;
	}

	public void setAfterSale(String afterSale) {
		this.afterSale = afterSale;
	}

	public String getOrderTime() {
		return orderTime;
	}

	public void setOrderTime(String orderTime) {
		this.orderTime = orderTime;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public String getItemPrice() {
		return itemPrice;
	}

	public void setItemPrice(String itemPrice) {
		this.itemPrice = itemPrice;
	}

	public String getOrderCode() {
		return orderCode;
	}

	public void setOrderCode(String orderCode) {
		this.orderCode = orderCode;
	}

	public String getCount() {
		return count;
	}

	public void setCount(String count) {
		this.count = count;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getAuditType() {
		return auditType;
	}

	public void setAuditType(String auditType) {
		this.auditType = auditType;
	}

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		CollocationSell that = (CollocationSell) o;

		return Objects.equal(this.id, that.id) && Objects.equal(this.orderCode, that.orderCode);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(id, orderCode, itemName, itemPrice, count, status, auditType);
	}

	@Override
	public String toString() {
		return MoreObjects.toStringHelper(this).add("id", id).add("orderCode", orderCode).add("itemName", itemName)
				.add("itemPrice", itemPrice).add("count", count).add("status", status).add("auditType", auditType)
				.toString();
	}

}
