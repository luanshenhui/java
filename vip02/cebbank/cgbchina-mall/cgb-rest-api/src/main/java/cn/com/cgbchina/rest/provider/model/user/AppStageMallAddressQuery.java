package cn.com.cgbchina.rest.provider.model.user;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL317 地址查询接口(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class AppStageMallAddressQuery extends BaseQueryEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8015989484309811694L;
	private String origin;
	private String mallType;
	private String custId;
	private String idCard;

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

	public String getCustId() {
		return custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
	}

	public String getIdCard() {
		return idCard;
	}

	public void setIdCard(String idCard) {
		this.idCard = idCard;
	}

}
