package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL423 微信易信O2O合作商0元秒杀下单
 * 
 * @author lizy 2016/4/28.
 */
public class WXYX020FreeOrderReturnVO extends BaseEntityVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3000655705268027299L;
	@XMLNodeName(value = "ordermain_id")
	private String ordermainId;
	private String amount;
	private String orderId;
	private String curStatusId;

	public String getOrdermainId() {
		return ordermainId;
	}

	public void setOrdermainId(String ordermainId) {
		this.ordermainId = ordermainId;
	}

	public String getAmount() {
		return amount;
	}

	public void setAmount(String amount) {
		this.amount = amount;
	}

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getCurStatusId() {
		return curStatusId;
	}

	public void setCurStatusId(String curStatusId) {
		this.curStatusId = curStatusId;
	}

}
