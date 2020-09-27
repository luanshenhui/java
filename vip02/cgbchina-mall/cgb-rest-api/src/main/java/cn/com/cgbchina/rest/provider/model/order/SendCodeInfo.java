package cn.com.cgbchina.rest.provider.model.order;

import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * 发码（购票）成功通知接口
 * 
 * @author lizy
 *
 */
public class SendCodeInfo extends BaseQueryEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4110449880181654229L;
	private String orderNo;
	private Integer sum;
	private List<SendCodeOrderInfo> items = new ArrayList<SendCodeOrderInfo>();

	public List<SendCodeOrderInfo> getItems() {
		return items;
	}

	public void setItems(List<SendCodeOrderInfo> items) {
		this.items = items;
	}

	public String getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}

	public Integer getSum() {
		return sum;
	}

	public void setSum(Integer sum) {
		this.sum = sum;
	}


}
