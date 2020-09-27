package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL115 CC广发下单下单的对象
 * 
 * @author lizy 2016/4/28.
 */
public class CCAddOrderByCgbAddVO extends BaseQueryEntityVO implements
		Serializable {
	private static final long serialVersionUID = 6671813716559350657L;
	@NotNull
	private String origin;
	private String bizSight;
	private String sorceSenderNo;
	private String operatorId;

	@NotNull
	private String mallType;
	@NotNull
	@XMLNodeName(value = "ordertype_id")
	private String ordertypeId;
	@NotNull
	private String totvalueYG;
	@NotNull
	private String totvalueFQ;
	@NotNull
	@XMLNodeName(value = "total_num")
	private String totalNum;

	@XMLNodeName(value = "cont_id_type")
	private String contIdType;
	@NotNull
	@XMLNodeName(value = "cont_idcard")
	private String contIdcard;
	@NotNull
	@XMLNodeName(value = "cont_nm")
	private String contNm;
	@XMLNodeName(value = "cont_nm_py")
	private String contNmPy;

	@XMLNodeName(value = "cont_postcode")
	private String contPostcode;
	@XMLNodeName(value = "cont_address")
	private String contAddress;
	@XMLNodeName(value = "cont_mob_phone")
	private String contMobPhone;
	@XMLNodeName(value = "cont_hphone")
	private String contHphone;
	@NotNull
	@XMLNodeName(value = "csg_name")
	private String csgName;
	@NotNull
	@XMLNodeName(value = "csg_postcode")
	private String csgPostcode;
	@NotNull
	@XMLNodeName(value = "csg_address")
	private String csgAddress;
	@NotNull
	@XMLNodeName(value = "csg_phone1")
	private String csgPhone1;
	@XMLNodeName(value = "csg_phone2")
	private String csgPhone2;
	@NotNull
	@XMLNodeName(value = "is_invoice")
	private String isInvoice;
	private String invoice;
	@XMLNodeName(value = "invoice_type")
	private String invoiceType;
	@XMLNodeName(value = "invoice_content")
	private String invoiceContent;
	@XMLNodeName(value = "ordermain_desc")
	private String ordermainDesc;
	@XMLNodeName(value = "send_time")
	private String sendTime;
	@NotNull
	@XMLNodeName(value = "acct_add_flag")
	private String acctAddFlag;
	@NotNull
	private String sendCode;

	@XMLNodeName(value = "cust_sex")
	private String custSex;
	@XMLNodeName(value = "cust_email")
	private String custEmail;
	@XMLNodeName(value = "csg_province")
	private String csgProvince;
	@XMLNodeName(value = "csg_city")
	private String csgCity;
	@XMLNodeName(value = "csg_borough")
	private String csgBorough;
	private String cardno;
	@NotNull
	private String creator;
	private String regulator;
	@NotNull
	private String smsnotice;
	@XMLNodeName(value = "Smsphone")
	private String smsphone;
	@NotNull
	@XMLNodeName(value = "Ordermemo")
	private String ordermemo;
	@NotNull
	private String michelleId;
	@NotNull
	private String channel;
	@NotNull
	private String receiveMode;
	@NotNull
	private String releaseType;
	@NotNull
	private String urgentLvl;
	@NotNull
	private String prevCaseId;
	private String incomingTel;
	private String memo;
	private String forceTransfer;
	private String supplierName;
	private String oldBankId;
	private String supplierDesc;
	private String presentname;
	private String recommendCardnbr;
	private String recommendname;
	private String recommendid;
	@NotNull
	private String requestType;
	@NotNull
	private String validDate;
	private String privilegeId;
	private String privilegeName;
	private Double privilegeMoney;
	private String discountPrivilege;
	private String pointType;
	private String discountPrivMon;
	private List<CCAddOrderByCgbPropAddVO> props = new ArrayList<CCAddOrderByCgbPropAddVO>();
	private List<CCAddOrderByCgbGoodsAddVO> goods = new ArrayList<CCAddOrderByCgbGoodsAddVO>();

	public List<CCAddOrderByCgbPropAddVO> getProps() {
		return props;
	}

	public void setProps(List<CCAddOrderByCgbPropAddVO> props) {
		this.props = props;
	}

	public List<CCAddOrderByCgbGoodsAddVO> getGoods() {
		return goods;
	}

	public void setGoods(List<CCAddOrderByCgbGoodsAddVO> goods) {
		this.goods = goods;
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

	public String getTotvalueYG() {
		return totvalueYG;
	}

	public void setTotvalueYG(String totvalueYG) {
		this.totvalueYG = totvalueYG;
	}

	public String getTotvalueFQ() {
		return totvalueFQ;
	}

	public void setTotvalueFQ(String totvalueFQ) {
		this.totvalueFQ = totvalueFQ;
	}

	public String getTotalNum() {
		return totalNum;
	}

	public void setTotalNum(String totalNum) {
		this.totalNum = totalNum;
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

	public String getIsInvoice() {
		return isInvoice;
	}

	public void setIsInvoice(String isInvoice) {
		this.isInvoice = isInvoice;
	}

	public String getInvoice() {
		return invoice;
	}

	public void setInvoice(String invoice) {
		this.invoice = invoice;
	}

	public String getInvoiceType() {
		return invoiceType;
	}

	public void setInvoiceType(String invoiceType) {
		this.invoiceType = invoiceType;
	}

	public String getInvoiceContent() {
		return invoiceContent;
	}

	public void setInvoiceContent(String invoiceContent) {
		this.invoiceContent = invoiceContent;
	}

	public String getOrdermainDesc() {
		return ordermainDesc;
	}

	public void setOrdermainDesc(String ordermainDesc) {
		this.ordermainDesc = ordermainDesc;
	}

	public String getSendTime() {
		return sendTime;
	}

	public void setSendTime(String sendTime) {
		this.sendTime = sendTime;
	}

	public String getAcctAddFlag() {
		return acctAddFlag;
	}

	public void setAcctAddFlag(String acctAddFlag) {
		this.acctAddFlag = acctAddFlag;
	}

	public String getSendCode() {
		return sendCode;
	}

	public void setSendCode(String sendCode) {
		this.sendCode = sendCode;
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

	public String getCardno() {
		return cardno;
	}

	public void setCardno(String cardno) {
		this.cardno = cardno;
	}

	public String getCreator() {
		return creator;
	}

	public void setCreator(String creator) {
		this.creator = creator;
	}

	public String getRegulator() {
		return regulator;
	}

	public void setRegulator(String regulator) {
		this.regulator = regulator;
	}

	public String getSmsnotice() {
		return smsnotice;
	}

	public void setSmsnotice(String smsnotice) {
		this.smsnotice = smsnotice;
	}

	public String getSmsphone() {
		return smsphone;
	}

	public void setSmsphone(String smsphone) {
		this.smsphone = smsphone;
	}

	public String getOrdermemo() {
		return ordermemo;
	}

	public void setOrdermemo(String ordermemo) {
		this.ordermemo = ordermemo;
	}

	public String getMichelleId() {
		return michelleId;
	}

	public void setMichelleId(String michelleId) {
		this.michelleId = michelleId;
	}

	public String getChannel() {
		return channel;
	}

	public void setChannel(String channel) {
		this.channel = channel;
	}

	public String getReceiveMode() {
		return receiveMode;
	}

	public void setReceiveMode(String receiveMode) {
		this.receiveMode = receiveMode;
	}

	public String getReleaseType() {
		return releaseType;
	}

	public void setReleaseType(String releaseType) {
		this.releaseType = releaseType;
	}

	public String getUrgentLvl() {
		return urgentLvl;
	}

	public void setUrgentLvl(String urgentLvl) {
		this.urgentLvl = urgentLvl;
	}

	public String getPrevCaseId() {
		return prevCaseId;
	}

	public void setPrevCaseId(String prevCaseId) {
		this.prevCaseId = prevCaseId;
	}

	public String getIncomingTel() {
		return incomingTel;
	}

	public void setIncomingTel(String incomingTel) {
		this.incomingTel = incomingTel;
	}

	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}

	public String getForceTransfer() {
		return forceTransfer;
	}

	public void setForceTransfer(String forceTransfer) {
		this.forceTransfer = forceTransfer;
	}

	public String getSupplierName() {
		return supplierName;
	}

	public void setSupplierName(String supplierName) {
		this.supplierName = supplierName;
	}

	public String getOldBankId() {
		return oldBankId;
	}

	public void setOldBankId(String oldBankId) {
		this.oldBankId = oldBankId;
	}

	public String getSupplierDesc() {
		return supplierDesc;
	}

	public void setSupplierDesc(String supplierDesc) {
		this.supplierDesc = supplierDesc;
	}

	public String getPresentname() {
		return presentname;
	}

	public void setPresentname(String presentname) {
		this.presentname = presentname;
	}

	public String getRecommendCardnbr() {
		return recommendCardnbr;
	}

	public void setRecommendCardnbr(String recommendCardnbr) {
		this.recommendCardnbr = recommendCardnbr;
	}

	public String getRecommendname() {
		return recommendname;
	}

	public void setRecommendname(String recommendname) {
		this.recommendname = recommendname;
	}

	public String getRecommendid() {
		return recommendid;
	}

	public void setRecommendid(String recommendid) {
		this.recommendid = recommendid;
	}

	public String getRequestType() {
		return requestType;
	}

	public void setRequestType(String requestType) {
		this.requestType = requestType;
	}

	public String getValidDate() {
		return validDate;
	}

	public void setValidDate(String validDate) {
		this.validDate = validDate;
	}

	public String getPrivilegeId() {
		return privilegeId;
	}

	public void setPrivilegeId(String privilegeId) {
		this.privilegeId = privilegeId;
	}

	public String getPrivilegeName() {
		return privilegeName;
	}

	public void setPrivilegeName(String privilegeName) {
		this.privilegeName = privilegeName;
	}

	public Double getPrivilegeMoney() {
		return privilegeMoney;
	}

	public void setPrivilegeMoney(Double privilegeMoney) {
		this.privilegeMoney = privilegeMoney;
	}

	public String getDiscountPrivilege() {
		return discountPrivilege;
	}

	public void setDiscountPrivilege(String discountPrivilege) {
		this.discountPrivilege = discountPrivilege;
	}

	public String getPointType() {
		return pointType;
	}

	public void setPointType(String pointType) {
		this.pointType = pointType;
	}

	public String getDiscountPrivMon() {
		return discountPrivMon;
	}

	public void setDiscountPrivMon(String discountPrivMon) {
		this.discountPrivMon = discountPrivMon;
	}

}
