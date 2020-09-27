package centling.dto;

import java.io.Serializable;

public class DeliveryOrdenDetailDto implements Serializable, Comparable<DeliveryOrdenDetailDto> {
	private static final long serialVersionUID = -564175358433753592L;

	/**
	 * 订单号
	 */
	private String ordenID;
	
	/**
	 * 序号
	 */
	private Integer number;
	
	/**
	 * 服装各类
	 */
	private String closingID;
	
	/**
	 * 数量
	 */
	private String amount;
	
	/**
	 * 面料成份ID
	 */
	private String compositionID;
	
	/**
	 * 面料成分名称
	 */
	private String compositionName;
	
	/**
	 * 客户性别
	 */
	private String customSex;
	
	/**
	 * 服装种类
	 */
	private String closingType;
	
	/**
	 * 订单状态
	 */
	private String statusId;
	
	/**
	 * 订单名称
	 */
	private String statusName;
	
	/**
	 * 类型
	 * 1：来自于delivery表
	 * 2：来自于deliveryPlus表
	 */
	private String type;

	/**
	 * 发货单ID
	 */
	private String deliveryID;
	
	public Integer getNumber() {
		return number;
	}

	public void setNumber(Integer number) {
		this.number = number;
	}

	public String getCompositionName() {
		return compositionName;
	}

	public void setCompositionName(String compositionName) {
		this.compositionName = compositionName;
	}

	public String getCustomSex() {
		return customSex;
	}

	public void setCustomSex(String customSex) {
		this.customSex = customSex;
	}

	public String getClosingType() {
		return closingType;
	}

	public void setClosingType(String closingType) {
		this.closingType = closingType;
	}

	public String getOrdenID() {
		return ordenID;
	}

	public void setOrdenID(String ordenID) {
		this.ordenID = ordenID;
	}

	public String getClosingID() {
		return closingID;
	}

	public void setClosingID(String closingID) {
		this.closingID = closingID;
	}

	public String getCompositionID() {
		return compositionID;
	}

	public void setCompositionID(String compositionID) {
		this.compositionID = compositionID;
	}

	public String getAmount() {
		return amount;
	}

	public void setAmount(String amount) {
		this.amount = amount;
	}

	public String getStatusId() {
		return statusId;
	}

	public void setStatusId(String statusId) {
		this.statusId = statusId;
	}

	public String getStatusName() {
		return statusName;
	}

	public void setStatusName(String statusName) {
		this.statusName = statusName;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getDeliveryID() {
		return deliveryID;
	}

	public void setDeliveryID(String deliveryID) {
		this.deliveryID = deliveryID;
	}

	@Override
	public int compareTo(DeliveryOrdenDetailDto o) {
		return this.deliveryID.compareTo( o.deliveryID);
	}
}