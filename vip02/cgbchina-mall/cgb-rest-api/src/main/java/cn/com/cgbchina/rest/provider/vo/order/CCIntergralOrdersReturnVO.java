package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;

/**
 *MAL105  CC积分商城订单列表的返回对象
 * @author  Lizy
 */
public class CCIntergralOrdersReturnVO implements Serializable {
    private static final long serialVersionUID = -7076804877154767400L;
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
    @NotNull
    private String loopTag;
    @NotNull
    private String loopCount;
    private List<CCIntergralOrderVO> ccIntergralOrders = new ArrayList<CCIntergralOrderVO>();

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

    public List<CCIntergralOrderVO> getCcIntergralOrders() {
        return ccIntergralOrders;
    }

    public void setCcIntergralOrders(List<CCIntergralOrderVO> ccIntergralOrders) {
        this.ccIntergralOrders = ccIntergralOrders;
    }
}
