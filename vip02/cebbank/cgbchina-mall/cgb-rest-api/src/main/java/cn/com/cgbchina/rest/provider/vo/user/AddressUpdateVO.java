package cn.com.cgbchina.rest.provider.vo.user;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL333 修改地址接口
 * 
 * @author lizy 2016/4/28.
 */
public class AddressUpdateVO extends BaseQueryEntityVO implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6859690957882115422L;
	@NotNull
	private String origin;
	@NotNull
	private String mallType;
	@NotNull
	@XMLNodeName(value = "address_id")
	private String addressId;
	@NotNull
	@XMLNodeName(value = "cust_id")
	private String custId;
	@NotNull
	@XMLNodeName(value = "csg_province_code")
	private String csgProvinceCode;

	@NotNull
	@XMLNodeName(value = "csg_province")
	private String csgProvince;
	@NotNull
	@XMLNodeName(value = "csg_city_code")
	private String csgCityCode;
	@NotNull
	@XMLNodeName(value = "csg_city")
	private String csgCity;
	@NotNull
	@XMLNodeName(value = "csg_borough_code")
	private String csgBoroughCode;
	@NotNull
	@XMLNodeName(value = "csg_borough")
	private String csgBorough;
	@NotNull
	@XMLNodeName(value = "csg_address")
	private String csgAddress;
	@NotNull
	@XMLNodeName(value = "csg_postcode")
	private String csgPostcode;
	@NotNull
	@XMLNodeName(value = "csg_name")
	private String csgName;
	@XMLNodeName(value = "csg_mobile")
	private String csgMobile;
	@XMLNodeName(value = "csg_phone")
	private String csgPhone;
	@XMLNodeName(value = "csg_email")
	private String csgEmail;
	@NotNull
	@XMLNodeName(value = "csg_seq")
	private String csgSeq;
	@NotNull
	@XMLNodeName(value = "modify_date")
	private String modifyDate;
	@NotNull
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

	public String getCustId() {
		return custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
	}

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
