package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;

/**
 * MAL115 CC广发下单返回对象
 * 
 * @author lizy 2016/4/28.
 */
public class CCAddOrderByCgbAddDetailReturn implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2213485644251921151L;
	public String orderId;
	public String errCode;
	public String orderReturnCode;
	public String curStatusId;
	public String approveResult;
	public String followDir;
	public String approveSumLimit;
	public String approveAprtLimit;
	public String aprtunPayamt;
	public String curRusefulamt;
	public String saveAmt;
	public String caseId;
	public String specialCust;
	public String sysIndicateMsg;
	public String spareMsg1;
	public String rejuctReason;
	public String decisionCode;
	public String nodeCode;
	public String releaseType;
	public String rejectCode;
	public String aprtCode;
	public String perpayAmt;
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
