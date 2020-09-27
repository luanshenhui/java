package cn.com.cgbchina.rest.provider.model.order;

import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseQueryEntity;

/**
 * MAL324 积分商城下单
 * 
 * @author lizy 2016/4/28.
 */
public class IntergralAddOrder extends BaseQueryEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7146074707681971877L;
	private String origin;
	private String mallType;
	private String ordertypeId;
	private String totalBonus;
	private String totalPrice;
	private String totalNum;
	private String createOper;
	private String contIdType;
	private String contIdcard;
	private String contNm;
	private String contNmPy;
	private String contPostcode;
	private String contAddress;
	private String contMobPhone;
	private String contHphone;
	private String csgName;
	private String csgPostcode;
	private String csgAddress;
	private String csgPhone1;
	private String csgPhone2;
	private String sendTime;
	private String ordermainDesc;
	private String acctAddFlag;
	private String custSex;
	private String custEmail;
	private String csgProvince;
	private String csgCity;
	private String csgBorough;
	private String isMerge;
	private List<GoodsInfo> goodsInfo;

	public List<GoodsInfo> getGoodsInfo() {
		return goodsInfo;
	}

	public void setGoodsInfo(List<GoodsInfo> goodsInfo) {
		this.goodsInfo = goodsInfo;
	}

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

	public String getOrdertypeId() {
		return ordertypeId;
	}

	public void setOrdertypeId(String ordertypeId) {
		this.ordertypeId = ordertypeId;
	}

	public String getTotalBonus() {
		return totalBonus;
	}

	public void setTotalBonus(String totalBonus) {
		this.totalBonus = totalBonus;
	}

	public String getTotalPrice() {
		return totalPrice;
	}

	public void setTotalPrice(String totalPrice) {
		this.totalPrice = totalPrice;
	}

	public String getTotalNum() {
		return totalNum;
	}

	public void setTotalNum(String totalNum) {
		this.totalNum = totalNum;
	}

	public String getCreateOper() {
		return createOper;
	}

	public void setCreateOper(String createOper) {
		this.createOper = createOper;
	}

	public String getContIdType() {
		return contIdType;
	}

	public void setContIdType(String contIdType) {
		this.contIdType = contIdType;
	}

	public String getContIdcard() {
		return contIdcard;
	}

	public void setContIdcard(String contIdcard) {
		this.contIdcard = contIdcard;
	}

	public String getContNm() {
		return contNm;
	}

	public void setContNm(String contNm) {
		this.contNm = contNm;
	}

	public String getContNmPy() {
		return contNmPy;
	}

	public void setContNmPy(String contNmPy) {
		this.contNmPy = contNmPy;
	}

	public String getContPostcode() {
		return contPostcode;
	}

	public void setContPostcode(String contPostcode) {
		this.contPostcode = contPostcode;
	}

	public String getContAddress() {
		return contAddress;
	}

	public void setContAddress(String contAddress) {
		this.contAddress = contAddress;
	}

	public String getContMobPhone() {
		return contMobPhone;
	}

	public void setContMobPhone(String contMobPhone) {
		this.contMobPhone = contMobPhone;
	}

	public String getContHphone() {
		return contHphone;
	}

	public void setContHphone(String contHphone) {
		this.contHphone = contHphone;
	}

	public String getCsgName() {
		return csgName;
	}

	public void setCsgName(String csgName) {
		this.csgName = csgName;
	}

	public String getCsgPostcode() {
		return csgPostcode;
	}

	public void setCsgPostcode(String csgPostcode) {
		this.csgPostcode = csgPostcode;
	}

	public String getCsgAddress() {
		return csgAddress;
	}

	public void setCsgAddress(String csgAddress) {
		this.csgAddress = csgAddress;
	}

	public String getCsgPhone1() {
		return csgPhone1;
	}

	public void setCsgPhone1(String csgPhone1) {
		this.csgPhone1 = csgPhone1;
	}

	public String getCsgPhone2() {
		return csgPhone2;
	}

	public void setCsgPhone2(String csgPhone2) {
		this.csgPhone2 = csgPhone2;
	}

	public String getSendTime() {
		return sendTime;
	}

	public void setSendTime(String sendTime) {
		this.sendTime = sendTime;
	}

	public String getOrdermainDesc() {
		return ordermainDesc;
	}

	public void setOrdermainDesc(String ordermainDesc) {
		this.ordermainDesc = ordermainDesc;
	}

	public String getAcctAddFlag() {
		return acctAddFlag;
	}

	public void setAcctAddFlag(String acctAddFlag) {
		this.acctAddFlag = acctAddFlag;
	}

	public String getCustSex() {
		return custSex;
	}

	public void setCustSex(String custSex) {
		this.custSex = custSex;
	}

	public String getCustEmail() {
		return custEmail;
	}

	public void setCustEmail(String custEmail) {
		this.custEmail = custEmail;
	}

	public String getCsgProvince() {
		return csgProvince;
	}

	public void setCsgProvince(String csgProvince) {
		this.csgProvince = csgProvince;
	}

	public String getCsgCity() {
		return csgCity;
	}

	public void setCsgCity(String csgCity) {
		this.csgCity = csgCity;
	}

	public String getCsgBorough() {
		return csgBorough;
	}

	public void setCsgBorough(String csgBorough) {
		this.csgBorough = csgBorough;
	}

	public String getIsMerge() {
		return isMerge;
	}

	public void setIsMerge(String isMerge) {
		this.isMerge = isMerge;
	}

}
