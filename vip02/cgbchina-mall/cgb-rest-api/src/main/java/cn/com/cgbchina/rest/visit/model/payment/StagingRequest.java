package cn.com.cgbchina.rest.visit.model.payment;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.visit.model.BaseQuery;

public class StagingRequest extends BaseQuery implements Serializable {
	private static final long serialVersionUID = 5131878652252599999L;
	@NotNull
	private String srcCaseId;
	@NotNull
	private String interfaceType;
	@NotNull
	private String caseType;
	@NotNull
	private String subCaseType;
	@NotNull
	private String channel;
	private String project;
	@NotNull
	private String requestType;
	@NotNull
	private String creator;
	private String michelleId;
	private String bookDesc;
	@NotNull
	private String receiveMode;
	private String addr;
	private String postcode;
	private String drawer;
	@NotNull
	private String sendCode;
	@NotNull
	private String regulator;
	private String smsnotice;
	private String smsPhone;
	private String contactNbr1;
	private String contactNbr2;
	private String sbookid;
	private String suborderid;
	private String bbookid;
	private String reservation;
	private String reserveTime;
	private String cardnbr;
	@NotNull
	private String idNbr;
	private String certtype;
	@NotNull
	private String urgentLvl;
	private String oldBankId;
	@NotNull
	private String productCode;
	@NotNull
	private String productName;
	@NotNull
	private BigDecimal price;
	private String color;
	@NotNull
	private String amount;
	@NotNull
	private BigDecimal sumAmt;
	@NotNull
	private BigDecimal firstPayment;
	@NotNull
	private String bills;
	@NotNull
	private BigDecimal perPeriodAmt;
	@NotNull
	private String supplierCode;
	private String supplierDesc;
	private String recommendCardnbr;
	private String recommendname;
	private String recommendCerttype;
	private String recommendid;
	private String prevCaseId;
	private String custName;
	private String incomingTel;
	private String presentName;
	private String ordermemo;
	private String forceTransfer;
	private String supplierName;
	private String memo;
	private String receiveName;
	private String merchantCode;
	private BigDecimal acceptAmt;
	private String favorableType;
	private BigDecimal deductAmt;
	@NotNull
	private String fixedFeeHTFlag;
	@NotNull
	private BigDecimal fixedAmtFee;
	@NotNull
	private BigDecimal feeRatio1;
	private BigDecimal ratio1Precent;
	@NotNull
	private BigDecimal feeRatio2;
	private BigDecimal ratio2Precent;
	private Integer feeRatio2Bill;
	private BigDecimal feeRatio3;
	private BigDecimal ratio3Precent;
	private Integer feeRatio3Bill;
	@NotNull
	private Integer reducerateFrom;
	@NotNull
	private Integer reducerateTo;
	@NotNull
	private Integer reduceHandingFee;
	@NotNull
	private String htFlag;
	@NotNull
	private BigDecimal htCapital;
	@NotNull
	private String virtualStore;
	private List<FinancialInfo> financialInfos;

	public String getSrcCaseId() {
		return srcCaseId;
	}

	public void setSrcCaseId(String srcCaseId) {
		this.srcCaseId = srcCaseId;
	}

	public String getInterfaceType() {
		return interfaceType;
	}

	public void setInterfaceType(String interfaceType) {
		this.interfaceType = interfaceType;
	}

	public String getCaseType() {
		return caseType;
	}

	public void setCaseType(String caseType) {
		this.caseType = caseType;
	}

	public String getSubCaseType() {
		return subCaseType;
	}

	public void setSubCaseType(String subCaseType) {
		this.subCaseType = subCaseType;
	}

	public String getChannel() {
		return channel;
	}

	public void setChannel(String channel) {
		this.channel = channel;
	}

	public String getProject() {
		return project;
	}

	public void setProject(String project) {
		this.project = project;
	}

	public String getRequestType() {
		return requestType;
	}

	public void setRequestType(String requestType) {
		this.requestType = requestType;
	}

	public String getCreator() {
		return creator;
	}

	public void setCreator(String creator) {
		this.creator = creator;
	}

	public String getMichelleId() {
		return michelleId;
	}

	public void setMichelleId(String michelleId) {
		this.michelleId = michelleId;
	}

	public String getBookDesc() {
		return bookDesc;
	}

	public void setBookDesc(String bookDesc) {
		this.bookDesc = bookDesc;
	}

	public String getReceiveMode() {
		return receiveMode;
	}

	public void setReceiveMode(String receiveMode) {
		this.receiveMode = receiveMode;
	}

	public String getAddr() {
		return addr;
	}

	public void setAddr(String addr) {
		this.addr = addr;
	}

	public String getPostcode() {
		return postcode;
	}

	public void setPostcode(String postcode) {
		this.postcode = postcode;
	}

	public String getDrawer() {
		return drawer;
	}

	public void setDrawer(String drawer) {
		this.drawer = drawer;
	}

	public String getSendCode() {
		return sendCode;
	}

	public void setSendCode(String sendCode) {
		this.sendCode = sendCode;
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

	public String getSmsPhone() {
		return smsPhone;
	}

	public void setSmsPhone(String smsPhone) {
		this.smsPhone = smsPhone;
	}

	public String getContactNbr1() {
		return contactNbr1;
	}

	public void setContactNbr1(String contactNbr1) {
		this.contactNbr1 = contactNbr1;
	}

	public String getContactNbr2() {
		return contactNbr2;
	}

	public void setContactNbr2(String contactNbr2) {
		this.contactNbr2 = contactNbr2;
	}

	public String getSbookid() {
		return sbookid;
	}

	public void setSbookid(String sbookid) {
		this.sbookid = sbookid;
	}

	public String getSuborderid() {
		return suborderid;
	}

	public void setSuborderid(String suborderid) {
		this.suborderid = suborderid;
	}

	public String getBbookid() {
		return bbookid;
	}

	public void setBbookid(String bbookid) {
		this.bbookid = bbookid;
	}

	public String getReservation() {
		return reservation;
	}

	public void setReservation(String reservation) {
		this.reservation = reservation;
	}

	public String getReserveTime() {
		return reserveTime;
	}

	public void setReserveTime(String reserveTime) {
		this.reserveTime = reserveTime;
	}

	public String getCardnbr() {
		return cardnbr;
	}

	public void setCardnbr(String cardnbr) {
		this.cardnbr = cardnbr;
	}

	public String getIdNbr() {
		return idNbr;
	}

	public void setIdNbr(String idNbr) {
		this.idNbr = idNbr;
	}

	public String getCerttype() {
		return certtype;
	}

	public void setCerttype(String certtype) {
		this.certtype = certtype;
	}

	public String getUrgentLvl() {
		return urgentLvl;
	}

	public void setUrgentLvl(String urgentLvl) {
		this.urgentLvl = urgentLvl;
	}

	public String getOldBankId() {
		return oldBankId;
	}

	public void setOldBankId(String oldBankId) {
		this.oldBankId = oldBankId;
	}

	public String getProductCode() {
		return productCode;
	}

	public void setProductCode(String productCode) {
		this.productCode = productCode;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public BigDecimal getPrice() {
		return price;
	}

	public void setPrice(BigDecimal price) {
		this.price = price;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public String getAmount() {
		return amount;
	}

	public void setAmount(String amount) {
		this.amount = amount;
	}

	public BigDecimal getSumAmt() {
		return sumAmt;
	}

	public void setSumAmt(BigDecimal sumAmt) {
		this.sumAmt = sumAmt;
	}

	public BigDecimal getFirstPayment() {
		return firstPayment;
	}

	public void setFirstPayment(BigDecimal firstPayment) {
		this.firstPayment = firstPayment;
	}

	public String getBills() {
		return bills;
	}

	public void setBills(String bills) {
		this.bills = bills;
	}

	public BigDecimal getPerPeriodAmt() {
		return perPeriodAmt;
	}

	public void setPerPeriodAmt(BigDecimal perPeriodAmt) {
		this.perPeriodAmt = perPeriodAmt;
	}

	public String getSupplierCode() {
		return supplierCode;
	}

	public void setSupplierCode(String supplierCode) {
		this.supplierCode = supplierCode;
	}

	public String getSupplierDesc() {
		return supplierDesc;
	}

	public void setSupplierDesc(String supplierDesc) {
		this.supplierDesc = supplierDesc;
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

	public String getRecommendCerttype() {
		return recommendCerttype;
	}

	public void setRecommendCerttype(String recommendCerttype) {
		this.recommendCerttype = recommendCerttype;
	}

	public String getRecommendid() {
		return recommendid;
	}

	public void setRecommendid(String recommendid) {
		this.recommendid = recommendid;
	}

	public String getPrevCaseId() {
		return prevCaseId;
	}

	public void setPrevCaseId(String prevCaseId) {
		this.prevCaseId = prevCaseId;
	}

	public String getCustName() {
		return custName;
	}

	public void setCustName(String custName) {
		this.custName = custName;
	}

	public String getIncomingTel() {
		return incomingTel;
	}

	public void setIncomingTel(String incomingTel) {
		this.incomingTel = incomingTel;
	}

	public String getPresentName() {
		return presentName;
	}

	public void setPresentName(String presentName) {
		this.presentName = presentName;
	}

	public String getOrdermemo() {
		return ordermemo;
	}

	public void setOrdermemo(String ordermemo) {
		this.ordermemo = ordermemo;
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

	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}

	public String getReceiveName() {
		return receiveName;
	}

	public void setReceiveName(String receiveName) {
		this.receiveName = receiveName;
	}

	public String getMerchantCode() {
		return merchantCode;
	}

	public void setMerchantCode(String merchantCode) {
		this.merchantCode = merchantCode;
	}

	public BigDecimal getAcceptAmt() {
		return acceptAmt;
	}

	public void setAcceptAmt(BigDecimal acceptAmt) {
		this.acceptAmt = acceptAmt;
	}

	public String getFavorableType() {
		return favorableType;
	}

	public void setFavorableType(String favorableType) {
		this.favorableType = favorableType;
	}

	public BigDecimal getDeductAmt() {
		return deductAmt;
	}

	public void setDeductAmt(BigDecimal deductAmt) {
		this.deductAmt = deductAmt;
	}

	public String getFixedFeeHTFlag() {
		return fixedFeeHTFlag;
	}

	public void setFixedFeeHTFlag(String fixedFeeHTFlag) {
		this.fixedFeeHTFlag = fixedFeeHTFlag;
	}

	public BigDecimal getFixedAmtFee() {
		return fixedAmtFee;
	}

	public void setFixedAmtFee(BigDecimal fixedAmtFee) {
		this.fixedAmtFee = fixedAmtFee;
	}

	public BigDecimal getFeeRatio1() {
		return feeRatio1;
	}

	public void setFeeRatio1(BigDecimal feeRatio1) {
		this.feeRatio1 = feeRatio1;
	}

	public BigDecimal getRatio1Precent() {
		return ratio1Precent;
	}

	public void setRatio1Precent(BigDecimal ratio1Precent) {
		this.ratio1Precent = ratio1Precent;
	}

	public BigDecimal getFeeRatio2() {
		return feeRatio2;
	}

	public void setFeeRatio2(BigDecimal feeRatio2) {
		this.feeRatio2 = feeRatio2;
	}

	public BigDecimal getRatio2Precent() {
		return ratio2Precent;
	}

	public void setRatio2Precent(BigDecimal ratio2Precent) {
		this.ratio2Precent = ratio2Precent;
	}

	public Integer getFeeRatio2Bill() {
		return feeRatio2Bill;
	}

	public void setFeeRatio2Bill(Integer feeRatio2Bill) {
		this.feeRatio2Bill = feeRatio2Bill;
	}

	public BigDecimal getFeeRatio3() {
		return feeRatio3;
	}

	public void setFeeRatio3(BigDecimal feeRatio3) {
		this.feeRatio3 = feeRatio3;
	}

	public BigDecimal getRatio3Precent() {
		return ratio3Precent;
	}

	public void setRatio3Precent(BigDecimal ratio3Precent) {
		this.ratio3Precent = ratio3Precent;
	}

	public Integer getFeeRatio3Bill() {
		return feeRatio3Bill;
	}

	public void setFeeRatio3Bill(Integer feeRatio3Bill) {
		this.feeRatio3Bill = feeRatio3Bill;
	}

	public Integer getReducerateFrom() {
		return reducerateFrom;
	}

	public void setReducerateFrom(Integer reducerateFrom) {
		this.reducerateFrom = reducerateFrom;
	}

	public Integer getReducerateTo() {
		return reducerateTo;
	}

	public void setReducerateTo(Integer reducerateTo) {
		this.reducerateTo = reducerateTo;
	}

	public Integer getReduceHandingFee() {
		return reduceHandingFee;
	}

	public void setReduceHandingFee(Integer reduceHandingFee) {
		this.reduceHandingFee = reduceHandingFee;
	}

	public String getHtFlag() {
		return htFlag;
	}

	public void setHtFlag(String htFlag) {
		this.htFlag = htFlag;
	}

	public BigDecimal getHtCapital() {
		return htCapital;
	}

	public void setHtCapital(BigDecimal htCapital) {
		this.htCapital = htCapital;
	}

	public String getVirtualStore() {
		return virtualStore;
	}

	public void setVirtualStore(String virtualStore) {
		this.virtualStore = virtualStore;
	}

	public List<FinancialInfo> getFinancialInfos() {
		return financialInfos;
	}

	public void setFinancialInfos(List<FinancialInfo> financialInfos) {
		this.financialInfos = financialInfos;
	}

}
