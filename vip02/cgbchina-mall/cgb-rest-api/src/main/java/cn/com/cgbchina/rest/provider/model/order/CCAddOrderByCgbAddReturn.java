package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;
import cn.com.cgbchina.rest.provider.vo.order.CCAddOrderByCgbAddDetailReturnVO;

/**
 * MAL115 CC广发下单返回对象
 * 
 * @author lizy 2016/4/28.
 */
public class CCAddOrderByCgbAddReturn extends BaseEntity implements Serializable {
	private static final long serialVersionUID = 2698123817807659395L;
	private String orderMainId;
	private List<CCAddOrderByCgbAddDetailReturn> orders = new ArrayList<CCAddOrderByCgbAddDetailReturn>();

	public String getOrderMainId() {
		return orderMainId;
	}

	public void setOrderMainId(String orderMainId) {
		this.orderMainId = orderMainId;
	}

	public List<CCAddOrderByCgbAddDetailReturn> getOrders() {
		return orders;
	}

	public void setOrders(List<CCAddOrderByCgbAddDetailReturn> orders) {
		this.orders = orders;
	}

}
