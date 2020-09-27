package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL106 CC积分商城订单的修改后返回对象
 * 
 * @author Lizy
 *
 */
public class CCIntergralOrderUpdateReturnVO extends BaseEntityVO implements Serializable {
	private static final long serialVersionUID = 4145470669118605408L;
	@NotNull
	private String channelSN;
	@NotNull
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
