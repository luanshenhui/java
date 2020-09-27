package cn.com.cgbchina.trade.model;

import java.io.Serializable;

/**
 * Created by 11150721040343 on 16-4-15.
 */
public class OrderRequest extends OrderInfo implements Serializable {
	private static final long serialVersionUID = -1639236228869952094L;
	private String state;// 请款状态

	private String name;// 商品名称

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
}
