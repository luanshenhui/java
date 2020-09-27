package cn.com.cgbchina.rest.visit.model.payment;

import java.io.Serializable;
import java.math.BigDecimal;

import cn.com.cgbchina.rest.visit.model.BaseResult;

public class StagingRequestResult extends BaseResult implements Serializable {

	private static final long serialVersionUID = -899006317391523200L;
	private String approveResult;
	private String followDir;
	private BigDecimal approveSumLimit;
	private BigDecimal approveAprtLimit;
	private BigDecimal aprtUnPayAmt;
	private String decisionCode;
	private String NodeCode;
	private String saveAmt;
	private BigDecimal currUsefulAmt;
	private BigDecimal needDepAmt;
	private String caseId;
	private String specialCust;
	private String sysIndicateMsg;
	private String spareMsg;
	private String rejuctReason;
	private BigDecimal depositamt;
	private String rejectcode;
	private String aprtcode;
	private BigDecimal perpayamt;
	private String ordernbr;
	private String forceTransfer;
	private BigDecimal rtcuCurUnRvlvLmt;
	private BigDecimal rtcuPermCashInstlLimit;
	private Integer rtcuSmcInstLimit;
	private BigDecimal pvcuBalLmtPercL3m;
	private BigDecimal rtcuCurrBal;
	private BigDecimal rtcuTempCrlimit;
	private BigDecimal rtcuPermRvlvLmt;
	private BigDecimal rtcuCurRvlvLmt;
	private BigDecimal rtcuPermTotalLmt;
	private BigDecimal rtcuPermUnRvlvLmt;
	private BigDecimal rtcuAvailRvlvScLmt;
	private BigDecimal rtcuAvailInstLmt;
	private String errorCode;
	private String releaseType;

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
		return NodeCode;
	}

	public void setNodeCode(String nodeCode) {
		NodeCode = nodeCode;
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
