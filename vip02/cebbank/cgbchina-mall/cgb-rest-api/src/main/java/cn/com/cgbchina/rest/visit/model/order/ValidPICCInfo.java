package cn.com.cgbchina.rest.visit.model.order;

import cn.com.cgbchina.rest.visit.model.BaseQuery;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.validation.constraints.NotNull;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class ValidPICCInfo extends BaseQuery implements Serializable {
	private static final long serialVersionUID = 6928777708782586786L;
	@NotNull
	private String senderSN;
	@NotNull
	private String method;
	private Date timestamp;
	private List<SecureOrder> secureOrders = new ArrayList<SecureOrder>();

	public String getSenderSN() {
		return senderSN;
	}

	public void setSenderSN(String senderSN) {
		this.senderSN = senderSN;
	}

	public String getMethod() {
		return method;
	}

	public void setMethod(String method) {
		this.method = method;
	}

	public Date getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(Date timestamp) {
		this.timestamp = timestamp;
	}

	public List<SecureOrder> getSecureOrders() {
		return secureOrders;
	}

	public void setSecureOrders(List<SecureOrder> secureOrders) {
		this.secureOrders = secureOrders;
	}
}
