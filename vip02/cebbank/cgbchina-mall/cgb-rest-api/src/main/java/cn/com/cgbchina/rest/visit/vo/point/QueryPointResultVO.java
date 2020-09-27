package cn.com.cgbchina.rest.visit.vo.point;

import java.io.Serializable;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.visit.vo.BaseResultVo;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class QueryPointResultVO extends BaseResultVo implements Serializable {
	private String channelID;
	private String returnCode;
	private String successCode;
	@NotNull
	private String totalPages;
	@NotNull
	private String currentPage;
	private String midId;
	private String midTime;
	private String midSn;
	private String midTag;
	private String cardNo;
	private String jgId;
	private String projectCode;
	private String loopTag;
	private String loopCount;
	private String loopColumns;
	private String jgType;
	private String amount;
	private String validDate;
	private String produceDate;
	private String transDate;
	private String transAmount;
	private String transCard;
	private String remark;

	public String getLoopTag() {
		return loopTag;
	}

	public void setLoopTag(String loopTag) {
		this.loopTag = loopTag;
	}

	public String getLoopCount() {
		return loopCount;
	}

	public void setLoopCount(String loopCount) {
		this.loopCount = loopCount;
	}

	public String getLoopColumns() {
		return loopColumns;
	}

	public void setLoopColumns(String loopColumns) {
		this.loopColumns = loopColumns;
	}

	public String getJgType() {
		return jgType;
	}

	public void setJgType(String jgType) {
		this.jgType = jgType;
	}

	public String getAmount() {
		return amount;
	}

	public void setAmount(String amount) {
		this.amount = amount;
	}

	public String getValidDate() {
		return validDate;
	}

	public void setValidDate(String validDate) {
		this.validDate = validDate;
	}

	public String getProduceDate() {
		return produceDate;
	}

	public void setProduceDate(String produceDate) {
		this.produceDate = produceDate;
	}

	public String getTransDate() {
		return transDate;
	}

	public void setTransDate(String transDate) {
		this.transDate = transDate;
	}

	public String getTransAmount() {
		return transAmount;
	}

	public void setTransAmount(String transAmount) {
		this.transAmount = transAmount;
	}

	public String getTransCard() {
		return transCard;
	}

	public void setTransCard(String transCard) {
		this.transCard = transCard;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getMidTime() {
		return midTime;
	}

	public void setMidTime(String midTime) {
		this.midTime = midTime;
	}

	public String getMidSn() {
		return midSn;
	}

	public void setMidSn(String midSn) {
		this.midSn = midSn;
	}

	public String getMidId() {
		return midId;
	}

	public void setMidId(String midId) {
		this.midId = midId;
	}

	public String getMidTag() {
		return midTag;
	}

	public void setMidTag(String midTag) {
		this.midTag = midTag;
	}

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

	public String getJgId() {
		return jgId;
	}

	public void setJgId(String jgId) {
		this.jgId = jgId;
	}

	public String getProjectCode() {
		return projectCode;
	}

	public void setProjectCode(String projectCode) {
		this.projectCode = projectCode;
	}

	private List<QueryPointsInfoResultVO> queryPointsInfoResults;

	public String getChannelID() {
		return channelID;
	}

	public String getReturnCode() {
		return returnCode;
	}

	public void setReturnCode(String returnCode) {
		this.returnCode = returnCode;
	}

	public List<QueryPointsInfoResultVO> getQueryPointsInfoResults() {
		return queryPointsInfoResults;
	}

	public void setQueryPointsInfoResults(List<QueryPointsInfoResultVO> queryPointsInfoResults) {
		this.queryPointsInfoResults = queryPointsInfoResults;
	}

	public void setChannelID(String channelID) {
		this.channelID = channelID;
	}

	public String getSuccessCode() {
		return successCode;
	}

	public void setSuccessCode(String successCode) {
		this.successCode = successCode;
	}

	public String getTotalPages() {
		return totalPages;
	}

	public void setTotalPages(String totalPages) {
		this.totalPages = totalPages;
	}

	public String getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(String currentPage) {
		this.currentPage = currentPage;
	}
}
