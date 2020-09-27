package cn.com.cgbchina.rest.provider.vo.user;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL317 地址查询接口(分期商城) 地址信息
 * 
 * @author lizy 2016/4/28.
 */
public class AppStageMallAddressInfoVO extends BaseEntityVO {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3108997691443308764L;
	@XMLNodeName(value = "csg_province_code")
	private String csgProvinceCode;

	@XMLNodeName(value = "csg_province")
	private String csgProvince;
	@XMLNodeName(value = "csg_city_code")
	private String csgCityCode;
	@XMLNodeName(value = "csg_city")
	private String csgCity;
	@XMLNodeName(value = "csg_borough_code")
	private String csgBoroughCode;
	@XMLNodeName(value = "csg_borough")
	private String csgBorough;
	@XMLNodeName(value = "csg_address")
	private String csgAddress;
	@XMLNodeName(value = "csg_postcode")
	private String csgPostcode;
	@XMLNodeName(value = "csg_name")
	private String csgName;
	@XMLNodeName(value = "csg_mobile")
	private String csgMobile;
	@XMLNodeName(value = "csg_phone")
	private String csgPhone;
	@XMLNodeName(value = "csg_email")
	private String csgEmail;
	@XMLNodeName(value = "csg_seq")
	private String csgSeq;
	@XMLNodeName(value = "create_date")
	private String createDate;
	@XMLNodeName(value = "create_time")
	private String createTime;
	@XMLNodeName(value = "modify_date")
	private String modifyDate;
	@XMLNodeName(value = "modify_time")
	private String modifyTime;
	@XMLNodeName(value = "is_default")
	private String isDefault;
	@XMLNodeName(value = "address_id")
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
