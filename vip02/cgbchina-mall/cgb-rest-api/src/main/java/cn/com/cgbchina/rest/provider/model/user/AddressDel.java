package cn.com.cgbchina.rest.provider.model.user;

import java.io.Serializable;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL334 删除地址接口
 * 
 * @author lizy 2016/4/28.
 */
public class AddressDel extends BaseQueryEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5035442531135667096L;
	private String origin;
	private String mallType;
	private String addressId;
	private String reqType;
	private String modifyDate;
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
