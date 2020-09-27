package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * @author  lizy
 * MAL104 CC/IVR积分商城下单返回对象
 */
public class CCAndIVRIntergalOrderReturnVO implements Serializable   {
    private static final long serialVersionUID = -7326415213828121528L;
    @NotNull
	private String returnCode;
    @XMLNodeName("ReturnDes")
    private String returnDes;
	public String getReturnCode() {
		return returnCode;
	}
	public void setReturnCode(String returnCode) {
		this.returnCode = returnCode;
	}
	public String getReturnDes() {
		return returnDes;
	}
	public void setReturnDes(String returnDes) {
		this.returnDes = returnDes;
	}
    @NotNull
    private String channelSN;
    @NotNull
    private String successCode;
    private String errCode;
    @NotNull
    private String orderMainId;

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

    public String getErrCode() {
        return errCode;
    }

    public void setErrCode(String errCode) {
        this.errCode = errCode;
    }

    public String getOrderMainId() {
        return orderMainId;
    }

    public void setOrderMainId(String orderMainId) {
        this.orderMainId = orderMainId;
    }
}
