package cn.com.cgbchina.rest.visit.vo.payment;

import java.io.Serializable;
import java.math.BigDecimal;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.visit.vo.BaseResultVo;

public class StagingRequestResultVO extends BaseResultVo implements Serializable {
	@XMLNodeName("APPROVERESULT")
	private String approveResult;
	@XMLNodeName("FOLLOWDIR")
	private String followDir;
	@XMLNodeName("APPROVESUMLIMIT")
	private BigDecimal approveSumLimit;
	@XMLNodeName("APPROVEAPRTLIMIT")
	private BigDecimal approveAprtLimit;
	@XMLNodeName("APRTUNPAYAMT")
	private BigDecimal aprtUnPayAmt;
	@XMLNodeName("DECISIONCODE")
	private String decisionCode;
	@XMLNodeName("NODECODE")
	private String nodeCode;
	@XMLNodeName("SAVEAMT")
	private String saveAmt;
	@XMLNodeName("CURRUSEFULAMT")
	private BigDecimal currUsefulAmt;
	@XMLNodeName("NEEDDEPAMT")
	private BigDecimal needDepAmt;
	@XMLNodeName("CASEID")
	private String caseId;
	@XMLNodeName("SPECIALCUST")
	private String specialCust;
	@XMLNodeName("SYSINDICATEMSG")
	private String sysIndicateMsg;
	@XMLNodeName("SPAREMSG")
	private String spareMsg;
	@XMLNodeName("RELEASETYPE")
	private String releaseType;
	@XMLNodeName("REJUCTREASON")
	private String rejuctReason;
	@XMLNodeName("DEPOSITAMT")
	private BigDecimal depositamt;
	@XMLNodeName("REJECTCODE")
	private String rejectcode;
	@XMLNodeName("APRTCODE")
	private String aprtcode;
	@XMLNodeName("PERPAYAMT")
	private BigDecimal perpayamt;
	@XMLNodeName("ORDERNBR")
	private String ordernbr;
	@XMLNodeName("FORCETRANSFER")
	private String forceTransfer;
	@XMLNodeName("RTCUCURUNRVLVLMT")
	private BigDecimal rtcuCurUnRvlvLmt;
	@XMLNodeName("RTCUPERMCASHINSTLLIMIT")
	private BigDecimal rtcuPermCashInstlLimit;
	@XMLNodeName("RTCUSMCINSTLIMIT")
	private Integer rtcuSmcInstLimit;
	@XMLNodeName("PVCUBALLMTPERCL3M")
	private BigDecimal pvcuBalLmtPercL3m;
	@XMLNodeName("RTCUCURRBAL")
	private BigDecimal rtcuCurrBal;
	@XMLNodeName("RTCUTEMPCRLIMIT")
	private BigDecimal rtcuTempCrlimit;
	@XMLNodeName("RTCUPERMRVLVLMT")
	private BigDecimal rtcuPermRvlvLmt;
	@XMLNodeName("RTCUCURRVLVLMT")
	private BigDecimal rtcuCurRvlvLmt;
	@XMLNodeName("RTCUPERMTOTALLMT")
	private BigDecimal rtcuPermTotalLmt;
	@XMLNodeName("RTCUPERMUNRVLVLMT")
	private BigDecimal rtcuPermUnRvlvLmt;
	@XMLNodeName("RTCUAVAILRVLVSCLMT")
	private BigDecimal rtcuAvailRvlvScLmt;
	@XMLNodeName("RTCUAVAILINSTLMT")
	private BigDecimal rtcuAvailInstLmt;
	@XMLNodeName("ERRORCODE")
	private String errorCode;

	public String getReleaseType() {
		return releaseType;
	}

	public void setReleaseType(String releaseType) {
		this.releaseType = releaseType;
	}

	public String getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}

	public String getApproveResult() {
		return approveResult;
	}

	public void setApproveResult(String approveResult) {
		this.approveResult = approveResult;
	}

	public String getFollowDir() {
		return followDir;
	}

	public void setFollowDir(String followDir) {
		this.followDir = followDir;
	}

	public BigDecimal getApproveSumLimit() {
		return approveSumLimit;
	}

	public void setApproveSumLimit(BigDecimal approveSumLimit) {
		this.approveSumLimit = approveSumLimit;
	}

	public BigDecimal getApproveAprtLimit() {
		return approveAprtLimit;
	}

	public void setApproveAprtLimit(BigDecimal approveAprtLimit) {
		this.approveAprtLimit = approveAprtLimit;
	}

	public BigDecimal getAprtUnPayAmt() {
		return aprtUnPayAmt;
	}

	public void setAprtUnPayAmt(BigDecimal aprtUnPayAmt) {
		this.aprtUnPayAmt = aprtUnPayAmt;
	}

	public String getDecisionCode() {
		return decisionCode;
	}

	public void setDecisionCode(String decisionCode) {
		this.decisionCode = decisionCode;
	}

	public String getNodeCode() {
		return nodeCode;
	}

	public void setNodeCode(String nodeCode) {
		this.nodeCode = nodeCode;
	}

	public String getSaveAmt() {
		return saveAmt;
	}

	public void setSaveAmt(String saveAmt) {
		this.saveAmt = saveAmt;
	}

	public BigDecimal getCurrUsefulAmt() {
		return currUsefulAmt;
	}

	public void setCurrUsefulAmt(BigDecimal currUsefulAmt) {
		this.currUsefulAmt = currUsefulAmt;
	}

	public BigDecimal getNeedDepAmt() {
		return needDepAmt;
	}

	public void setNeedDepAmt(BigDecimal needDepAmt) {
		this.needDepAmt = needDepAmt;
	}

	public String getCaseId() {
		return caseId;
	}

	public void setCaseId(String caseId) {
		this.caseId = caseId;
	}

	public String getSpecialCust() {
		return specialCust;
	}

	public void setSpecialCust(String specialCust) {
		this.specialCust = specialCust;
	}

	public String getSysIndicateMsg() {
		return sysIndicateMsg;
	}

	public void setSysIndicateMsg(String sysIndicateMsg) {
		this.sysIndicateMsg = sysIndicateMsg;
	}

	public String getSpareMsg() {
		return spareMsg;
	}

	public void setSpareMsg(String spareMsg) {
		this.spareMsg = spareMsg;
	}

	public String getRejuctReason() {
		return rejuctReason;
	}

	public void setRejuctReason(String rejuctReason) {
		this.rejuctReason = rejuctReason;
	}

	public BigDecimal getDepositamt() {
		return depositamt;
	}

	public void setDepositamt(BigDecimal depositamt) {
		this.depositamt = depositamt;
	}

	public String getRejectcode() {
		return rejectcode;
	}

	public void setRejectcode(String rejectcode) {
		this.rejectcode = rejectcode;
	}

	public String getAprtcode() {
		return aprtcode;
	}

	public void setAprtcode(String aprtcode) {
		this.aprtcode = aprtcode;
	}

	public BigDecimal getPerpayamt() {
		return perpayamt;
	}

	public void setPerpayamt(BigDecimal perpayamt) {
		this.perpayamt = perpayamt;
	}

	public String getOrdernbr() {
		return ordernbr;
	}

	public void setOrdernbr(String ordernbr) {
		this.ordernbr = ordernbr;
	}

	public String getForceTransfer() {
		return forceTransfer;
	}

	public void setForceTransfer(String forceTransfer) {
		this.forceTransfer = forceTransfer;
	}

	public BigDecimal getRtcuCurUnRvlvLmt() {
		return rtcuCurUnRvlvLmt;
	}

	public void setRtcuCurUnRvlvLmt(BigDecimal rtcuCurUnRvlvLmt) {
		this.rtcuCurUnRvlvLmt = rtcuCurUnRvlvLmt;
	}

	public BigDecimal getRtcuPermCashInstlLimit() {
		return rtcuPermCashInstlLimit;
	}

	public void setRtcuPermCashInstlLimit(BigDecimal rtcuPermCashInstlLimit) {
		this.rtcuPermCashInstlLimit = rtcuPermCashInstlLimit;
	}

	public Integer getRtcuSmcInstLimit() {
		return rtcuSmcInstLimit;
	}

	public void setRtcuSmcInstLimit(Integer rtcuSmcInstLimit) {
		this.rtcuSmcInstLimit = rtcuSmcInstLimit;
	}

	public BigDecimal getPvcuBalLmtPercL3m() {
		return pvcuBalLmtPercL3m;
	}

	public void setPvcuBalLmtPercL3m(BigDecimal pvcuBalLmtPercL3m) {
		this.pvcuBalLmtPercL3m = pvcuBalLmtPercL3m;
	}

	public BigDecimal getRtcuCurrBal() {
		return rtcuCurrBal;
	}

	public void setRtcuCurrBal(BigDecimal rtcuCurrBal) {
		this.rtcuCurrBal = rtcuCurrBal;
	}

	public BigDecimal getRtcuTempCrlimit() {
		return rtcuTempCrlimit;
	}

	public void setRtcuTempCrlimit(BigDecimal rtcuTempCrlimit) {
		this.rtcuTempCrlimit = rtcuTempCrlimit;
	}

	public BigDecimal getRtcuPermRvlvLmt() {
		return rtcuPermRvlvLmt;
	}

	public void setRtcuPermRvlvLmt(BigDecimal rtcuPermRvlvLmt) {
		this.rtcuPermRvlvLmt = rtcuPermRvlvLmt;
	}

	public BigDecimal getRtcuCurRvlvLmt() {
		return rtcuCurRvlvLmt;
	}

	public void setRtcuCurRvlvLmt(BigDecimal rtcuCurRvlvLmt) {
		this.rtcuCurRvlvLmt = rtcuCurRvlvLmt;
	}

	public BigDecimal getRtcuPermTotalLmt() {
		return rtcuPermTotalLmt;
	}

	public void setRtcuPermTotalLmt(BigDecimal rtcuPermTotalLmt) {
		this.rtcuPermTotalLmt = rtcuPermTotalLmt;
	}

	public BigDecimal getRtcuPermUnRvlvLmt() {
		return rtcuPermUnRvlvLmt;
	}

	public void setRtcuPermUnRvlvLmt(BigDecimal rtcuPermUnRvlvLmt) {
		this.rtcuPermUnRvlvLmt = rtcuPermUnRvlvLmt;
	}

	public BigDecimal getRtcuAvailRvlvScLmt() {
		return rtcuAvailRvlvScLmt;
	}

	public void setRtcuAvailRvlvScLmt(BigDecimal rtcuAvailRvlvScLmt) {
		this.rtcuAvailRvlvScLmt = rtcuAvailRvlvScLmt;
	}

	public BigDecimal getRtcuAvailInstLmt() {
		return rtcuAvailInstLmt;
	}

	public void setRtcuAvailInstLmt(BigDecimal rtcuAvailInstLmt) {
		this.rtcuAvailInstLmt = rtcuAvailInstLmt;
	}

}
