package cn.com.cgbchina.rest.provider.model.order;

import java.io.Serializable;

/**
 * @author lizy 2016/4/27.
 *
 *         MAL113 订单信息查询(分期商城)返回对象
 * 
 */
public class StageMallOrderQueryByCCDetail implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3235000092734598753L;
	public String ordermainId;
	public String orderId;
	public String stagesNum;
	public String singlePrice;
	public String perStage;
	public String prePrice;
	public String privilegeId;
	public String privilegeName;
	public String privilegeMoney;
	public String discountPrivilege;
	public String discountPrivMon;
	public String vendorId;
	public String vendorFnm;
	public String createDate;
	public String curStatusId;
	public String goodssendFlag;
	public String goodsNm;
	public String cardNo;
	public String concludeDate;
	public String concludeTime;
	public String sourceId;
	public String bankOrderId;

	public String getOrdermainId() {
		return ordermainId;
	}

	public void setOrdermainId(String ordermainId) {
		this.ordermainId = ordermainId;
	}

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getStagesNum() {
		return stagesNum;
	}

	public void setStagesNum(String stagesNum) {
		this.stagesNum = stagesNum;
	}

	public String getSinglePrice() {
		return singlePrice;
	}

	public void setSinglePrice(String singlePrice) {
		this.singlePrice = singlePrice;
	}

	public String getPerStage() {
		return perStage;
	}

	public void setPerStage(String perStage) {
		this.perStage = perStage;
	}

	public String getPrePrice() {
		return prePrice;
	}

	public void setPrePrice(String prePrice) {
		this.prePrice = prePrice;
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

	public String getPrivilegeMoney() {
		return privilegeMoney;
	}

	public void setPrivilegeMoney(String privilegeMoney) {
		this.privilegeMoney = privilegeMoney;
	}

	public String getDiscountPrivilege() {
		return discountPrivilege;
	}

	public void setDiscountPrivilege(String discountPrivilege) {
		this.discountPrivilege = discountPrivilege;
	}

	public String getDiscountPrivMon() {
		return discountPrivMon;
	}

	public void setDiscountPrivMon(String discountPrivMon) {
		this.discountPrivMon = discountPrivMon;
	}

	public String getVendorId() {
		return vendorId;
	}

	public void setVendorId(String vendorId) {
		this.vendorId = vendorId;
	}

	public String getVendorFnm() {
		return vendorFnm;
	}

	public void setVendorFnm(String vendorFnm) {
		this.vendorFnm = vendorFnm;
	}

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	public String getCurStatusId() {
		return curStatusId;
	}

	public void setCurStatusId(String curStatusId) {
		this.curStatusId = curStatusId;
	}

	public String getGoodssendFlag() {
		return goodssendFlag;
	}

	public void setGoodssendFlag(String goodssendFlag) {
		this.goodssendFlag = goodssendFlag;
	}

	public String getGoodsNm() {
		return goodsNm;
	}

	public void setGoodsNm(String goodsNm) {
		this.goodsNm = goodsNm;
	}

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

	public String getConcludeDate() {
		return concludeDate;
	}

	public void setConcludeDate(String concludeDate) {
		this.concludeDate = concludeDate;
	}

	public String getConcludeTime() {
		return concludeTime;
	}

	public void setConcludeTime(String concludeTime) {
		this.concludeTime = concludeTime;
	}

	public String getSourceId() {
		return sourceId;
	}

	public void setSourceId(String sourceId) {
		this.sourceId = sourceId;
	}

	public String getBankOrderId() {
		return bankOrderId;
	}

	public void setBankOrderId(String bankOrderId) {
		this.bankOrderId = bankOrderId;
	}

}
