package cn.com.cgbchina.rest.provider.vo.user;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL317 地址查询接口(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class AppStageMallAddressQueryVO extends BaseQueryEntityVO {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8015989484309811694L;
	@NotNull
	private String origin;
	@NotNull
	private String mallType;
	@XMLNodeName(value = "cust_id")
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
