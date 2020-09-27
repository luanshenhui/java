package cn.com.cgbchina.rest.visit.vo.order;

import cn.com.cgbchina.rest.visit.vo.BaseQueryVo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class ValidPICCInfoVO extends BaseQueryVo implements Serializable {
	private String senderSN;
	private String method;
	private Date timestamp;
	private List<SecureOrderVO> secureOrders = new ArrayList<SecureOrderVO>();

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

	public List<SecureOrderVO> getSecureOrders() {
		return secureOrders;
	}

	public void setSecureOrders(List<SecureOrderVO> secureOrders) {
		this.secureOrders = secureOrders;
	}
}
