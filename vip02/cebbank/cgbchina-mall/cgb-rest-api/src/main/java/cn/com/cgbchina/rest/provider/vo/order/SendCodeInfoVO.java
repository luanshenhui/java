package cn.com.cgbchina.rest.provider.vo.order;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;

import javax.validation.constraints.NotNull;
import java.util.ArrayList;
import java.util.List;

/**
 * 短彩信回执接口
 * 
 * @author Lizy
 *
 */
public class SendCodeInfoVO {
	@NotNull
	@XMLNodeName(value = "orderno")
	private String orderNo;

	@NotNull
	@XMLNodeName(value = "sum")
	private Integer sum;

	@NotNull
	@XMLNodeName(value = "items")
	private List<SendCodeOrderInfoVO> items = new ArrayList<SendCodeOrderInfoVO>();

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

	public List<SendCodeOrderInfoVO> getItems() {
		return items;
	}

	public void setItems(List<SendCodeOrderInfoVO> items) {
		this.items = items;
	}

}
