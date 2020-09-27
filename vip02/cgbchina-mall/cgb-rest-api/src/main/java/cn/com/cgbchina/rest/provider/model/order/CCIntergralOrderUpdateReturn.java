package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL106 CC积分商城订单的修改后返回对象
 * 
 * @author Lizy
 *
 */
public class CCIntergralOrderUpdateReturn extends BaseEntity implements Serializable {
	private static final long serialVersionUID = 4145470669118605408L;
	private String channelSN;
	private String successCode;

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
}
