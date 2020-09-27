package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL501 微信生成订单接口（积分）
 * 
 * @author lizy 2016/4/28.
 */
public class WXOrderAddByIntergralReturnVO extends BaseEntityVO implements
		Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5273826832929390547L;
	private String orderMainId;
	private String payTime;

	public String getPayTime() {
		return payTime;
	}

	public void setPayTime(String payTime) {
		this.payTime = payTime;
	}

	public String getOrderMainId() {
		return orderMainId;
	}

	public void setOrderMainId(String orderMainId) {
		this.orderMainId = orderMainId;
	}

	@XMLNodeName("cur_status_id")
	private String curStatusId;

	public String getCurStatusId() {
		return curStatusId;
	}

	public void setCurStatusId(String curStatusId) {
		this.curStatusId = curStatusId;
	}

}
