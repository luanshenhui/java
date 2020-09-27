package cn.com.cgbchina.rest.provider.model.user;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL317 地址查询接口(分期商城) 地址信息
 * 
 * @author lizy 2016/4/28.
 */
public class AppStageMallAddressInfo extends BaseEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3108997691443308764L;
	private String csgProvinceCode;
	private String csgProvince;
	private String csgCityCode;
	private String csgCity;
	private String csgBoroughCode;
	private String csgBorough;
	private String csgAddress;
	private String csgPostcode;
	private String csgName;
	private String csgMobile;
	private String csgPhone;
	private String csgEmail;
	private String csgSeq;
	private String createDate;
	private String createTime;
	private String modifyDate;
	private String modifyTime;
	private String isDefault;
	private String addressId;

	public String getCsgProvinceCode() {
		return csgProvinceCode;
	}

	public void setCsgProvinceCode(String csgProvinceCode) {
		this.csgProvinceCode = csgProvinceCode;
	}

	public String getCsgProvince() {
		return csgProvince;
	}

	public void setCsgProvince(String csgProvince) {
		this.csgProvince = csgProvince;
	}

	public String getCsgCityCode() {
		return csgCityCode;
	}

	public void setCsgCityCode(String csgCityCode) {
		this.csgCityCode = csgCityCode;
	}

	public String getCsgCity() {
		return csgCity;
	}

	public void setCsgCity(String csgCity) {
		this.csgCity = csgCity;
	}

	public String getCsgBoroughCode() {
		return csgBoroughCode;
	}

	public void setCsgBoroughCode(String csgBoroughCode) {
		this.csgBoroughCode = csgBoroughCode;
	}

	public String getCsgBorough() {
		return csgBorough;
	}

	public void setCsgBorough(String csgBorough) {
		this.csgBorough = csgBorough;
	}

	public String getCsgAddress() {
		return csgAddress;
	}

	public void setCsgAddress(String csgAddress) {
		this.csgAddress = csgAddress;
	}

	public String getCsgPostcode() {
		return csgPostcode;
	}

	public void setCsgPostcode(String csgPostcode) {
		this.csgPostcode = csgPostcode;
	}

	public String getCsgName() {
		return csgName;
	}

	public void setCsgName(String csgName) {
		this.csgName = csgName;
	}

	public String getCsgMobile() {
		return csgMobile;
	}

	public void setCsgMobile(String csgMobile) {
		this.csgMobile = csgMobile;
	}

	public String getCsgPhone() {
		return csgPhone;
	}

	public void setCsgPhone(String csgPhone) {
		this.csgPhone = csgPhone;
	}

	public String getCsgEmail() {
		return csgEmail;
	}

	public void setCsgEmail(String csgEmail) {
		this.csgEmail = csgEmail;
	}

	public String getCsgSeq() {
		return csgSeq;
	}

	public void setCsgSeq(String csgSeq) {
		this.csgSeq = csgSeq;
	}

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	public String getCreateTime() {
		return createTime;
	}

	public void setCreateTime(String createTime) {
		this.createTime = createTime;
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

	public String getIsDefault() {
		return isDefault;
	}

	public void setIsDefault(String isDefault) {
		this.isDefault = isDefault;
	}

	public String getAddressId() {
		return addressId;
	}

	public void setAddressId(String addressId) {
		this.addressId = addressId;
	}

}
