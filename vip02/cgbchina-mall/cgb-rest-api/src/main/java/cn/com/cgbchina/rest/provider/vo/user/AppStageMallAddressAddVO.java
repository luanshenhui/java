package cn.com.cgbchina.rest.provider.vo.user;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL318 添加地址接口(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class AppStageMallAddressAddVO extends BaseQueryEntityVO {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8954565775295634571L;
	@NotNull
	private String origin;
	@NotNull
	private String mallType;
	@XMLNodeName(value = "cust_id")
	private String custId;
	private String idCard;
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
	@NotNull
	@XMLNodeName(value = "csg_mobile")
	private String csgMobile;
	@NotNull
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

}
