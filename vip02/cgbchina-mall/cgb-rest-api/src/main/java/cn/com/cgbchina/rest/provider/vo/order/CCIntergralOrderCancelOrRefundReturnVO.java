package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;


/**
 * MAL107
 * CC积分商城订单撤单和退货的订单
 * @author lizy
 */
public class CCIntergralOrderCancelOrRefundReturnVO extends BaseEntityVO implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 7212550441239413716L;
	@NotNull
    private String    channelSN;
	@NotNull
    private String    successCode;

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
