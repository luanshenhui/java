package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseEntity;


/**
 * MAL107
 * CC积分商城订单撤单和退货的订单
 * @author lizy
 */
public class CCIntergralOrderCancelOrRefundReturn extends BaseEntity implements Serializable {
    /**
	 * 
	 */
	private static final long serialVersionUID = -6601488207070915083L;
	private String    channelSN;
    private String    successCode;
    private String returnDes;
    
    public String getReturnDes() {
		return returnDes;
	}

	public void setReturnDes(String returnDes) {
		this.returnDes = returnDes;
	}

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
