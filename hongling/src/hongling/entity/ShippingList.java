package hongling.entity;

/**
 * ShippingList entity. @author MyEclipse Persistence Tools
 */

public class ShippingList implements java.io.Serializable {

	// Fields

	private String id;
	private String code;
	private String deliveryAddressId;
	private String memberId;
	private String status;
	private String msg;
	private String deliveryNumbr;
	private String waybillNumber;
	private String createTime;
	private String ip;
	private String shippingDate;

	// Constructors

	/** default constructor */
	public ShippingList() {
	}

	/** minimal constructor */
	public ShippingList(String id) {
		this.id = id;
	}

	/** full constructor */
	public ShippingList(String id, String code, String deliveryAddressId,
			String memberId, String status, String msg, String deliveryNumbr,
			String waybillNumber, String createTime, String ip,
			String shippingDate) {
		this.id = id;
		this.code = code;
		this.deliveryAddressId = deliveryAddressId;
		this.memberId = memberId;
		this.status = status;
		this.msg = msg;
		this.deliveryNumbr = deliveryNumbr;
		this.waybillNumber = waybillNumber;
		this.createTime = createTime;
		this.ip = ip;
		this.shippingDate = shippingDate;
	}

	// Property accessors

	public String getId() {
		return this.id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getCode() {
		return this.code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getDeliveryAddressId() {
		return this.deliveryAddressId;
	}

	public void setDeliveryAddressId(String deliveryAddressId) {
		this.deliveryAddressId = deliveryAddressId;
	}

	public String getMemberId() {
		return this.memberId;
	}

	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}

	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getMsg() {
		return this.msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public String getDeliveryNumbr() {
		return this.deliveryNumbr;
	}

	public void setDeliveryNumbr(String deliveryNumbr) {
		this.deliveryNumbr = deliveryNumbr;
	}

	public String getWaybillNumber() {
		return this.waybillNumber;
	}

	public void setWaybillNumber(String waybillNumber) {
		this.waybillNumber = waybillNumber;
	}

	public String getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}

	public String getIp() {
		return this.ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public String getShippingDate() {
		return this.shippingDate;
	}

	public void setShippingDate(String shippingDate) {
		this.shippingDate = shippingDate;
	}

}