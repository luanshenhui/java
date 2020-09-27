package cn.com.cgbchina.rest.provider.model.user;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL114 订单历史地址信息的查询对象
 * 
 * @author lizy 2016/4/28.
 */
public class OrderHistoryAddressQuery extends BaseQueryEntity implements Serializable {
	private static final long serialVersionUID = -2378450995171336144L;
	private String origin;
	private String mallType;
	private String ordermainId;

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getMallType() {
		return mallType;
	}

	public void setMallType(String mallType) {
		this.mallType = mallType;
	}

	public String getOrdermainId() {
		return ordermainId;
	}

	public void setOrdermainId(String ordermainId) {
		this.ordermainId = ordermainId;
	}
}
