package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;
import java.util.List;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL315 订单支付结果校验接口(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class AppStageMallPayVerificationReturnVO extends BaseEntityVO implements
		Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3385774749610312891L;
	private List<OrderInfoVo> orderInfo;

	public List<OrderInfoVo> getOrderInfo() {
		return orderInfo;
	}

	public void setOrderInfo(List<OrderInfoVo> orderInfo) {
		this.orderInfo = orderInfo;
	}
}
