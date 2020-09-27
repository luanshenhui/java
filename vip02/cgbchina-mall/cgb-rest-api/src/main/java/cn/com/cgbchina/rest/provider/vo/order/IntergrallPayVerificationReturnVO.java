package cn.com.cgbchina.rest.provider.vo.order;

import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL325 积分商城支付校验接口
 * 
 * @author lizy 2016/4/28.
 */
public class IntergrallPayVerificationReturnVO extends BaseEntityVO {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3286706569724688597L;
	private List<IntergrallPayVerificationOrderInfoVO> ordersInfo = new ArrayList<IntergrallPayVerificationOrderInfoVO>();

	public List<IntergrallPayVerificationOrderInfoVO> getOrdersInfo() {
		return ordersInfo;
	}

	public void setOrdersInfo(List<IntergrallPayVerificationOrderInfoVO> ordersInfo) {
		this.ordersInfo = ordersInfo;
	}

}
