package cn.com.cgbchina.rest.provider.vo.order;

import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseQueryEntityVO;

/**
 * MAL314 下单接口(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class AppIntergralAddOrderVO extends BaseQueryEntityVO {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6146630996511464339L;

	@NotNull
	private String origin;
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
	@NotNull
	@XMLNodeName(value = "create_oper")
	private String createOper;
	@NotNull
	@XMLNodeName(value = "cont_id_type")
	private String contIdType;
	@NotNull
	@XMLNodeName(value = "cont_idcard")
	private String contIdcard;
	@NotNull
	@XMLNodeName(value = "cont_nm")
	private String contNm;
	@NotNull
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
	@XMLNodeName(value = "csg_phone1")
	private String csgPhone1;
	@XMLNodeName(value = "csg_phone2")
	private String csgPhone2;
	@XMLNodeName(value = "send_time")
	private String sendTime;
	@NotNull
	@XMLNodeName(value = "is_invoice")
	private String isInvoice;
	private String invoice;
	@XMLNodeName(value = "invoice_type")
	private String invoiceType;
	@XMLNodeName(value = "invoice_content")
	private String invoiceContent;
	@NotNull
	@XMLNodeName(value = "ordermain_desc")
	private String ordermainDesc;
	@NotNull
	@XMLNodeName(value = "acct_add_flag")
	private String acctAddFlag;
	@NotNull
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
	private String cardNo;
	private List<AppIntergralAddOrderPrivilegeVO> appIntergralAddOrderPrivileges = new ArrayList<AppIntergralAddOrderPrivilegeVO>();

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

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

	public List<AppIntergralAddOrderPrivilegeVO> getAppIntergralAddOrderPrivileges() {
		return appIntergralAddOrderPrivileges;
	}

	public void setAppIntergralAddOrderPrivileges(
			List<AppIntergralAddOrderPrivilegeVO> appIntergralAddOrderPrivileges) {
		this.appIntergralAddOrderPrivileges = appIntergralAddOrderPrivileges;
	}
}
