package cn.com.cgbchina.rest.provider.vo.user;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL114 订单历史地址信息的查询对象
 * 
 * @author lizy 2016/4/28.
 */
public class OrderHistoryAddressQueryVO extends BaseQueryEntityVO implements Serializable {
	private static final long serialVersionUID = -2378450995171336144L;
	@NotNull
	private String origin;
	@NotNull
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
