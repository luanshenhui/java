package centling.entity;

import java.io.Serializable;
import java.util.Date;

public class Deal implements Serializable {
	private static final long serialVersionUID = -2927790691715916301L;
	private String ID;           // ID
	private String memo;         // 备注
	private Double accountIn;    // 交易金额（收入）
	private Double accountOut;   // 交易金额（支出）
	private Date dealDate;       // 交易日期
	private Integer dealItemId;  // 交易项目ID
	private String deliveryId;   // 发货ID（发货时必须填写）
	private String ordenId;      // 订单ID（下单或撤销订单时必须填写）
	private String memberId;     // 用户ID
	private Double localNum;     // 当前余额
	public String getID() {
		return ID;
	}
	public void setID(String iD) {
		ID = iD;
	}
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
	public Date getDealDate() {
		return dealDate;
	}
	public void setDealDate(Date dealDate) {
		this.dealDate = dealDate;
	}
	public Integer getDealItemId() {
		return dealItemId;
	}
	public void setDealItemId(Integer dealItemId) {
		this.dealItemId = dealItemId;
	}
	public String getDeliveryId() {
		return deliveryId;
	}
	public void setDeliveryId(String deliveryId) {
		this.deliveryId = deliveryId;
	}
	public String getOrdenId() {
		return ordenId;
	}
	public void setOrdenId(String ordenId) {
		this.ordenId = ordenId;
	}
	public String getMemberId() {
		return memberId;
	}
	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}
	public Double getLocalNum() {
		return localNum;
	}
	public void setLocalNum(Double localNum) {
		this.localNum = localNum;
	}
	public Double getAccountIn() {
		return accountIn;
	}
	public void setAccountIn(Double accountIn) {
		this.accountIn = accountIn;
	}
	public Double getAccountOut() {
		return accountOut;
	}
	public void setAccountOut(Double accountOut) {
		this.accountOut = accountOut;
	}
}
