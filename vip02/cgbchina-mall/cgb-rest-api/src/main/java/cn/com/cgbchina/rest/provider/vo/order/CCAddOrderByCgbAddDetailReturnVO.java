package cn.com.cgbchina.rest.provider.vo.order;

import java.io.Serializable;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;

/**
 * MAL115 CC广发下单返回对象
 * 
 * @author lizy 2016/4/28.
 */
public class CCAddOrderByCgbAddDetailReturnVO implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -7163832415207490480L;
	public String orderId;
	@XMLNodeName("ERRCODE")
	public String errCode;
	public String orderReturnCode;
	@XMLNodeName("CUR_STATUS_ID")
	public String curStatusId;
	@XMLNodeName("APPROVERESULT")
	public String approveResult;
	@XMLNodeName("followDir")
	public String followDir;
	@XMLNodeName("APPROVESUMLIMIT")
	public String approveSumLimit;
	@XMLNodeName("APPROVEAPRTLIMIT")
	public String approveAprtLimit;
	@XMLNodeName("APRTUNPAYAMT")
	public String aprtunPayamt;
	@XMLNodeName("CURRUSEFULAMT")
	public String curRusefulamt;
	@XMLNodeName("SAVEAMT")
	public String saveAmt;
	@XMLNodeName("CASEID")
	public String caseId;
	@XMLNodeName("SPECIALCUST")
	public String specialCust;
	@XMLNodeName("SYSINDICATEMSG")
	public String sysIndicateMsg;
	@XMLNodeName("SPAREMSG1")
	public String spareMsg1;
	@XMLNodeName("REJUCTREASON")
	public String rejuctReason;
	@XMLNodeName("DECISIONCODE")
	public String decisionCode;
	@XMLNodeName("NODECODE")
	public String nodeCode;
	@XMLNodeName("RELEASETYPE")
	public String releaseType;
	@XMLNodeName("REJECTCODE")
	public String rejectCode;
	@XMLNodeName("APRTCODE")
	public String aprtCode;
	@XMLNodeName("PERPAYAMT")
	public String perpayAmt;
	@XMLNodeName("orderNbr")
	public String orderNbr;

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getErrCode() {
		return errCode;
	}

	public void setErrCode(String errCode) {
		this.errCode = errCode;
	}

	public String getOrderReturnCode() {
		return orderReturnCode;
	}

	public void setOrderReturnCode(String orderReturnCode) {
		this.orderReturnCode = orderReturnCode;
	}

	public String getCurStatusId() {
		return curStatusId;
	}

	public void setCurStatusId(String curStatusId) {
		this.curStatusId = curStatusId;
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

	public String getApproveSumLimit() {
		return approveSumLimit;
	}

	public void setApproveSumLimit(String approveSumLimit) {
		this.approveSumLimit = approveSumLimit;
	}

	public String getApproveAprtLimit() {
		return approveAprtLimit;
	}

	public void setApproveAprtLimit(String approveAprtLimit) {
		this.approveAprtLimit = approveAprtLimit;
	}

	public String getAprtunPayamt() {
		return aprtunPayamt;
	}

	public void setAprtunPayamt(String aprtunPayamt) {
		this.aprtunPayamt = aprtunPayamt;
	}

	public String getCurRusefulamt() {
		return curRusefulamt;
	}

	public void setCurRusefulamt(String curRusefulamt) {
		this.curRusefulamt = curRusefulamt;
	}

	public String getSaveAmt() {
		return saveAmt;
	}

	public void setSaveAmt(String saveAmt) {
		this.saveAmt = saveAmt;
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

	public String getSpareMsg1() {
		return spareMsg1;
	}

	public void setSpareMsg1(String spareMsg1) {
		this.spareMsg1 = spareMsg1;
	}

	public String getRejuctReason() {
		return rejuctReason;
	}

	public void setRejuctReason(String rejuctReason) {
		this.rejuctReason = rejuctReason;
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

	public String getReleaseType() {
		return releaseType;
	}

	public void setReleaseType(String releaseType) {
		this.releaseType = releaseType;
	}

	public String getRejectCode() {
		return rejectCode;
	}

	public void setRejectCode(String rejectCode) {
		this.rejectCode = rejectCode;
	}

	public String getAprtCode() {
		return aprtCode;
	}

	public void setAprtCode(String aprtCode) {
		this.aprtCode = aprtCode;
	}

	public String getPerpayAmt() {
		return perpayAmt;
	}

	public void setPerpayAmt(String perpayAmt) {
		this.perpayAmt = perpayAmt;
	}

	public String getOrderNbr() {
		return orderNbr;
	}

	public void setOrderNbr(String orderNbr) {
		this.orderNbr = orderNbr;
	}

}
