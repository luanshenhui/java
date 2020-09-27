package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL107
 * CC积分商城订单撤单和退货的订单
 * @author lizy
 */
public class CCIntergralOrderCancelOrRefundVO extends  BaseQueryEntityVO implements Serializable {
    private static final long serialVersionUID = -439631540423447317L;
    @NotNull
    private String orderMainId;
    @NotNull
    private String orderId;
    @NotNull
    private String intType;
    @NotNull
    private String doDesc;
	@XMLNodeName(value="cust_message")
    private String custMessage;
	private String origin;
	
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

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}
    
}
