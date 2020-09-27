package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL115 CC广发下单返回对象
 * 
 * @author lizy 2016/4/28.
 */
public class CCAddOrderByCgbAddReturnVO extends BaseEntityVO implements Serializable {
	private static final long serialVersionUID = 2698123817807659395L;
	private String orderMainId;
	private List<CCAddOrderByCgbAddDetailReturnVO> orders = new ArrayList<CCAddOrderByCgbAddDetailReturnVO>();

	public String getOrderMainId() {
		return orderMainId;
	}

	public void setOrderMainId(String orderMainId) {
		this.orderMainId = orderMainId;
	}

	public List<CCAddOrderByCgbAddDetailReturnVO> getOrders() {
		return orders;
	}

	public void setOrders(List<CCAddOrderByCgbAddDetailReturnVO> orders) {
		this.orders = orders;
	}

}
