package cn.com.cgbchina.batch.model;


import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.Date;

/**
 *
 */
public class OrderBaseInfoModel implements Serializable {
	private static final long serialVersionUID = -4880546979220129300L;
	@NotNull
	private String orderId;
	@NotNull
	private Date payDate;
	@NotNull
	private String merId;

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public Date getPayDate() {
		return payDate;
	}

	public void setPayDate(Date payDate) {
		this.payDate = payDate;
	}

	public String getMerId() {
		return merId;
	}

	public void setMerId(String merId) {
		this.merId = merId;
	}
}
