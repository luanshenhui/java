package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL105 CC积分商城订单列表的返回对象
 * 
 * @author Lizy
 */
public class CCIntergralOrdersReturn extends BaseEntity implements Serializable {
	private static final long serialVersionUID = -7076804877154767400L;
	private String channelSN;
	private String successCode;
	private String loopTag;
	private String loopCount;
	private List<CCIntergralOrder> ccIntergralOrders = new ArrayList<CCIntergralOrder>();

	public String getChannelSN() {
		return channelSN;
	}

	public void setChannelSN(String channelSN) {
		this.channelSN = channelSN;
	}

	public String getSuccessCode() {
		return successCode;
	}

	public void setSuccessCode(String successCode) {
		this.successCode = successCode;
	}

	public String getLoopTag() {
		return loopTag;
	}

	public void setLoopTag(String loopTag) {
		this.loopTag = loopTag;
	}

	public String getLoopCount() {
		return loopCount;
	}

	public void setLoopCount(String loopCount) {
		this.loopCount = loopCount;
	}

	public List<CCIntergralOrder> getCcIntergralOrders() {
		return ccIntergralOrders;
	}

	public void setCcIntergralOrders(List<CCIntergralOrder> ccIntergralOrders) {
		this.ccIntergralOrders = ccIntergralOrders;
	}
}
