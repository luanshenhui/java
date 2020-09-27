package cn.com.cgbchina.rest.provider.vo.user;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL334 删除地址接口
 * 
 * @author lizy 2016/4/28.
 */
public class AddressDelVO extends BaseQueryEntityVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5035442531135667096L;
	@NotNull
	private String origin;
	@NotNull
	private String mallType;
	@NotNull
	@XMLNodeName(value = "address_id")
	private String addressId;
	@NotNull
	private String reqType;
	@XMLNodeName(value = "modify_date")
	private String modifyDate;
	@XMLNodeName(value = "modify_time")
	private String modifyTime;

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

	public String getAddressId() {
		return addressId;
	}

	public void setAddressId(String addressId) {
		this.addressId = addressId;
	}

	public String getReqType() {
		return reqType;
	}

	public void setReqType(String reqType) {
		this.reqType = reqType;
	}

	public String getModifyDate() {
		return modifyDate;
	}

	public void setModifyDate(String modifyDate) {
		this.modifyDate = modifyDate;
	}

	public String getModifyTime() {
		return modifyTime;
	}

	public void setModifyTime(String modifyTime) {
		this.modifyTime = modifyTime;
	}

}
