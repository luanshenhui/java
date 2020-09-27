package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL107
 * CC积分商城订单撤单和退货的订单
 * @author lizy
 */
public class CCIntergralOrderCancelOrRefund extends  BaseQueryEntity implements Serializable {
    private static final long serialVersionUID = -439631540423447317L;
    private String orderMainId;
    private String orderId;
    private String intType;
    private String doDesc;
    private String custMessage;
    private String origin;
    
    public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getOrderMainId() {
        return orderMainId;
    }

    public void setOrderMainId(String orderMainId) {
        this.orderMainId = orderMainId;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getIntType() {
        return intType;
    }

    public void setIntType(String intType) {
        this.intType = intType;
    }

    public String getDoDesc() {
        return doDesc;
    }

    public void setDoDesc(String doDesc) {
        this.doDesc = doDesc;
    }

    public String getCustMessage() {
        return custMessage;
    }

    public void setCustMessage(String custMessage) {
        this.custMessage = custMessage;
    }
}
